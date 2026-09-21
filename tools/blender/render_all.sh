#!/bin/bash
# Render every pass for every facing, then pack the frames into Factorio
# spritesheets with spritter.
#
#   render_all.sh <model-script> <entity-name> <scratch-dir> [frames] [facings]
#
#   facings: "all" (default) for a rotatable entity, or "north" for one that
#            cannot be rotated - a quarter of the render time.
#
# Frames land in <scratch>/frames/<pass>/<entity>-<pass>-<facing>/, which is the
# one-folder-per-sheet layout spritter's --recursive mode expects. Sheets and
# their .lua data files land in <scratch>/sheets/.
#
# Cycles on OptiX dies with "Misaligned address in CUDA queue" every so often on
# this machine, so each pass is retried from the last frame it managed to write.
set -u
BLENDER="/c/Program Files/Blender Foundation/Blender 5.0/blender.exe"
HERE="$(cd "$(dirname "$0")" && pwd)"
SPRITTER="$HERE/../bin/spritter.exe"

MODEL="$1"
ENTITY="$2"
SP="$3"
N="${4:-32}"
FACINGS="${5:-all}"
[ "$FACINGS" = "all" ] && FACINGS="north east south west"

for dir in $FACINGS; do
  # The tint pass is mostly holdout, so it is cheap; it still wants enough
  # samples not to grain up the one thing the player is looking at.
  for spec in "entity 160" "shadow 64" "tint 128"; do
    set -- $spec
    pass="$1"; samples="$2"
    out="$SP/frames/$pass/$ENTITY-$pass-$dir"
    mkdir -p "$out"
    for attempt in 1 2 3 4 5 6; do
      have=$(ls "$out"/*.png 2>/dev/null | wc -l)
      [ "$have" -ge "$N" ] && break
      "$BLENDER" --background --factory-startup --python "$MODEL" -- \
           --pass "$pass" --direction "$dir" --frames "$N" --start "$have" \
           --samples "$samples" --out "$out" >> "$SP/render_${dir}_${pass}.log" 2>&1
    done
    echo "$dir/$pass: $(ls "$out"/*.png 2>/dev/null | wc -l)/$N"
  done
done

# Entity and shadow are packed separately: the shadow needs a crop-alpha high
# enough to ignore Cycles' sampling noise, which would otherwise stretch the
# crop across the whole canvas. Never pass --transparent-black here, it would
# erase a shadow entirely.
mkdir -p "$SP/sheets"
"$SPRITTER" spritesheet -r -l -t 64        "$SP/frames/entity" "$SP/sheets"
"$SPRITTER" spritesheet -r -l -t 64 -a 16  "$SP/frames/shadow" "$SP/sheets"
# A model with no recipe-tinted contents renders a tint pass of fully
# transparent frames; skip it rather than handing spritter a folder of blank
# frames, which it answers with four "all images are empty" errors. A file
# size test does not find them - a transparent 384x384 PNG out of Cycles
# still weighs 30 KB, because the RGB channels are full of sampling noise
# under a zero alpha. Ask about the alpha itself.
if python "$HERE/has_alpha.py" "$SP/frames/tint"; then
  "$SPRITTER" spritesheet -r -l -t 64      "$SP/frames/tint" "$SP/sheets"
fi
echo
echo "sheets in $SP/sheets - copy the .png AND .lua files into graphics/entity/$ENTITY/"
du -sh "$SP/sheets"
