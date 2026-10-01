#!/bin/bash
# Render every pass for every facing, then pack the frames into Factorio
# spritesheets with spritter.
#
#   render_all.sh <model-script> <entity-name> <scratch-dir> [frames] [facings] [extra]
#
#   extra:   handed straight to the model script, unquoted, for models that
#            render more than one machine - e.g. "--variant burner".
#
#   facings: "all" (default) for a rotatable entity, or "north" for one that
#            cannot be rotated - a quarter of the render time.
#
# Frames land in <scratch>/frames/<pass>/<entity>-<pass>-<facing>/, which is the
# one-folder-per-sheet layout spritter's --recursive mode expects. Sheets and
# their .lua data files land in <scratch>/sheets/.
#
# How a pass survives this card. The GPU faults every so often - "Misaligned
# address in CUDA queue", on OptiX and CUDA alike and with memory to spare
# (see docs/blender-renders.md, "The GPU") - and a faulted CUDA context cannot
# be brought back inside the process that holds it. So Blender runs with
# --on-gpu-fault exit: on a fault it quits, and the loop below starts a fresh
# process, back on the GPU, at the frame that failed. A relaunch costs about
# fifteen seconds. The old in-process fallback finished the pass on the CPU
# instead, and one fault early in a sheet cost half an hour.
#
# A frame that faults three launches running is rendered on its own with the
# CPU fallback allowed, and the pass goes back to the GPU after it. Blender
# dying outright is handled the same way, since it also leaves the count of
# frames written where it was.
set -u
BLENDER="/c/Program Files/Blender Foundation/Blender 5.0/blender.exe"
HERE="$(cd "$(dirname "$0")" && pwd)"
SPRITTER="$HERE/../bin/spritter.exe"

MODEL="$1"
ENTITY="$2"
SP="$3"
N="${4:-32}"
FACINGS="${5:-all}"
EXTRA="${6:-}"
[ "$FACINGS" = "all" ] && FACINGS="north east south west"

for dir in $FACINGS; do
  # The tint pass is mostly holdout, so it is cheap; it still wants enough
  # samples not to grain up the one thing the player is looking at.
  for spec in "entity 160" "shadow 64" "tint 128"; do
    set -- $spec
    pass="$1"; samples="$2"
    out="$SP/frames/$pass/$ENTITY-$pass-$dir"
    mkdir -p "$out"
    last=-1; stuck=0; faults=0
    for launch in $(seq 1 30); do
      have=$(ls "$out"/*.png 2>/dev/null | wc -l)
      [ "$have" -ge "$N" ] && break
      if [ "$have" -eq "$last" ]; then stuck=$((stuck + 1)); else stuck=0; fi
      last=$have
      if [ "$stuck" -ge 2 ]; then
        frames="--single $have"; onfault=cpu
      else
        frames="--start $have"; onfault=exit
      fi
      "$BLENDER" --background --factory-startup --python "$MODEL" -- \
           --pass "$pass" --direction "$dir" --frames "$N" $frames \
           --on-gpu-fault $onfault --samples "$samples" --out "$out" $EXTRA \
           >> "$SP/render_${dir}_${pass}.log" 2>&1
      [ $? -eq 75 ] && faults=$((faults + 1))
    done
    echo "$dir/$pass: $(ls "$out"/*.png 2>/dev/null | wc -l)/$N, $faults GPU fault(s)"
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
echo "sheets in $SP/sheets - copy the .png AND .lua files into ../LavaBlock-graphics/graphics/entity/$ENTITY/"
du -sh "$SP/sheets"
