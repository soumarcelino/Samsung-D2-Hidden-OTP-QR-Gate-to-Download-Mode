#!/usr/bin/env python3
"""Extrai o primeiro PE/COFF OdinApp de um firmware volume já descompactado.

Uso: extract_odinapp.py abl_decompressed.bin OdinApp.efi [offset]
Requer: pefile. O offset padrão é 0xac para o artefato documentado.
"""
import sys
import pefile

src, dst = sys.argv[1:3]
offset = int(sys.argv[3], 0) if len(sys.argv) > 3 else 0xAC
data = open(src, "rb").read()
pe = pefile.PE(data=data[offset:])
end = max(s.PointerToRawData + s.SizeOfRawData for s in pe.sections)
with open(dst, "wb") as f:
    f.write(data[offset:offset + end])
print(f"offset={offset:#x} size={end:#x} machine={pe.FILE_HEADER.Machine:#x}")
