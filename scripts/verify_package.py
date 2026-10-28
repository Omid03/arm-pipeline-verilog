#!/usr/bin/env python3
"""Check package integrity only. This is not an HDL functional test."""
from pathlib import Path
import hashlib,json,re
root=Path(__file__).resolve().parents[1]
manifest=json.loads((root/'results/source-manifest.json').read_text())
for item in manifest:
    path=root/item['file']
    assert hashlib.sha256(path.read_bytes()).hexdigest()==item['sha256'], item['file']
for snapshot in ['hazard','forwarding','sram','sram-alternate']:
    base=root/'snapshots'/snapshot
    for relative in ['rtl/ARM.v','tb/ARM_TB.v','memory/output.coe','ip/dist_mem_gen_0/dist_mem_gen_0.xci']:
        assert (base/relative).is_file(), str(base/relative)
    coe=(base/'memory/output.coe').read_text()
    assert len(re.findall(r'\b[01]{32}\b',coe))==47
    for path in (base/'ip').glob('*/*.xci'):
        for value in re.findall(r'referenceId="PARAM_VALUE.coefficient_file">([^<]+)',path.read_text()):
            if value and value.lower()!='no_coe_file_loaded':
                assert (path.parent/value).is_file(),str(path)
for path in root.rglob('*.md'):
    text=path.read_text()
    for value in re.findall(r'\]\(([^)]+)\)|src="([^"]+)"',text):
        target=next(v for v in value if v)
        if not target.startswith(('http:','https:','#')):
            assert (path.parent/target.split('#')[0]).exists(),(str(path),target)
assert not re.search(r'\breport\b',(root/'README.md').read_text(),re.I)
print(f'PASS: {len(manifest)} original source/test/constraint hashes; 4 snapshots; ROM and documentation paths.')
print('No HDL simulation, synthesis or functional verification is performed by this script.')
