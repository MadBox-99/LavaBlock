#!/bin/bash
# Render every pass for every facing, resuming a pass if the CUDA driver dies
# mid-sequence (Cycles on OptiX throws "Misaligned address in CUDA queue" every
# so often on this machine).
#
#   render_all.sh <scratch-dir> [frames]
#
# Frames land in <scratch-dir>/seq/<direction>/<pass>_<frame>.png.
set -u
B="/c/Program Files/Blender Foundation/Blender 5.0/blender.exe"
SP="$1"
N="${2:-32}"
SCRIPT="$(cd "$(dirname "$0")" && pwd)/lava_centrifuge.py"

for dir in north east south west; do
  for spec in "entity 160" "shadow 64"; do
    set -- $spec
    pass="$1"; samples="$2"
    out="$SP/seq/$dir"
    mkdir -p "$out"
    for attempt in 1 2 3 4 5 6; do
      have=$(ls "$out/${pass}_"*.png 2>/dev/null | wc -l)
      [ "$have" -ge "$N" ] && break
      "$B" --background --factory-startup --python "$SCRIPT" -- \
           --pass "$pass" --direction "$dir" --frames "$N" --start "$have" \
           --samples "$samples" --out "$out" >> "$SP/render_${dir}_${pass}.log" 2>&1
    done
    echo "$dir/$pass: $(ls "$out/${pass}_"*.png 2>/dev/null | wc -l)/$N"
  done
done
