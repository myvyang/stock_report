"""Inventory indexed public PDFs; prune only a reviewed manifest, retaining text."""
import argparse
import hashlib
import json
from pathlib import Path
from urllib.parse import urlsplit


def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def inventory(root):
    entries, refused = [], []
    for index in sorted(root.glob('*/*/filing-index.json')):
        try:
            data = json.loads(index.read_text())
            meta = json.loads((index.parent / 'metadata.json').read_text())
            url = meta['source_url']
            host = urlsplit(url).hostname or ''
            allowed = ('cninfo.com.cn', 'hkexnews.hk', 'sse.com.cn', 'szse.cn', 'sec.gov')
            if not any(host == h or host.endswith('.' + h) for h in allowed):
                raise ValueError('source outside exchange/regulator whitelist')
            if urlsplit(url).username or urlsplit(url).password:
                raise ValueError('URL contains credentials')
            pdf = index.parent / data['pdf']['file']
            text = index.parent / data['authoritative_text']
            for path in (pdf, text):
                if path.is_symlink() or path.resolve().parent != index.parent.resolve():
                    raise ValueError('unsafe path')
            if not pdf.is_file() or not text.is_file() or text.stat().st_size == 0:
                raise ValueError('PDF or extracted text absent')
            if digest(pdf) != data['pdf']['sha256'] or meta.get('pdf_sha256') != data['pdf']['sha256']:
                raise ValueError('PDF checksum mismatch')
            entries.append({'pdf': str(pdf.relative_to(root)), 'sha256': data['pdf']['sha256'],
                'bytes': pdf.stat().st_size, 'text': str(text.relative_to(root)),
                'text_sha256': digest(text), 'source_url': url,
                'report_title': meta.get('report_title'), 'period': meta.get('period'),
                'company': meta.get('company'), 'publication_time': meta.get('publication_time')})
        except (KeyError, ValueError, OSError) as error:
            refused.append({'index': str(index.relative_to(root)), 'reason': str(error)})
    return {'version': 1, 'entries': entries, 'refused': refused,
            'bytes': sum(row['bytes'] for row in entries)}


def prune(root, manifest):
    deleted, refused = [], []
    for row in manifest['entries']:
        pdf, text = root / row['pdf'], root / row['text']
        try:
            for p in (pdf, text):
                if p.is_symlink() or root not in p.resolve().parents:
                    raise ValueError('unsafe path')
            if pdf.suffix != '.pdf' or pdf.parent != text.parent:
                raise ValueError('unexpected file type/location')
            if not pdf.exists():
                continue
            if digest(pdf) != row['sha256'] or digest(text) != row['text_sha256']:
                raise ValueError('file changed since inventory')
            pdf.unlink()
            deleted.append({'pdf': row['pdf'], 'bytes': row['bytes']})
        except (ValueError, OSError) as error:
            refused.append({'pdf': row['pdf'], 'reason': str(error)})
    return {'deleted': deleted, 'refused': refused, 'bytes': sum(r['bytes'] for r in deleted)}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['inventory', 'prune'])
    parser.add_argument('--root', required=True, type=Path)
    parser.add_argument('--manifest', type=Path)
    parser.add_argument('--confirm-root')
    args = parser.parse_args()
    root = args.root.resolve()
    if args.root.is_symlink() or root.name != 'stock_research_store' or not root.is_dir():
        parser.error('expected exact existing stock_research_store directory')
    if args.action == 'prune':
        if args.confirm_root != str(root) or not args.manifest:
            parser.error('prune requires reviewed manifest and exact root confirmation')
        output = prune(root, json.loads(args.manifest.read_text()))
    else:
        output = inventory(root)
    print(json.dumps(output, ensure_ascii=False, indent=2))
