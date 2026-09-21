"""Exit 0 if any PNG under the given directory has a single opaque pixel.

render_all.sh uses this to decide whether a pass produced anything worth
packing. A file size test cannot answer that: a fully transparent frame out
of Cycles still weighs tens of kilobytes, because the colour channels are
full of sampling noise underneath a zero alpha.
"""
import glob
import os
import sys

from PIL import Image

root = sys.argv[1]
for f in glob.glob(os.path.join(root, '*', '*.png')):
    if Image.open(f).convert('RGBA').split()[3].getbbox():
        sys.exit(0)
sys.exit(1)
