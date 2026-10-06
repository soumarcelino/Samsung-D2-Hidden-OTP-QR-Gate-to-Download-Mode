#!/usr/bin/env python3
"""Extrai JPEGs válidos de um blob para inspeção visual. Requer Pillow."""
from pathlib import Path
from PIL import Image
import io, sys

source = Path(sys.argv[1])
out = Path(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)
data = source.read_bytes()
pos = count = 0
while True:
    start = data.find(b"\xff\xd8\xff", pos)
    if start < 0:
        break
    end = data.find(b"\xff\xd9", start + 3)
    if end < 0:
        break
    try:
        image = Image.open(io.BytesIO(data[start:end + 2]))
        image.load()
        name = f"{count:02d}_{start:08x}_{image.width}x{image.height}.png"
        image.save(out / name)
        print(name)
        count += 1
        pos = end + 2
    except Exception:
        pos = start + 3
