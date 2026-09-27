"""Fermentation Tank - Factorio 3x3 entity, rendered at 64 px/tile.

  blender --background --factory-startup --python fermentation_tank.py -- \
          --pass entity|shadow|tint --direction north --frames 16 --out DIR

The camera, materials, primitives and render loop live in factorio_render.

A closed stainless vessel with a coned roof, the way every modern fermenter
is built: two dimpled cooling-jacket bands round the shell, tall sight
glasses on all four quarters where the brew shows, and the agitator drive on the roof.
The stainless is the one light, clean metal in the mod - everything else
here is weathered plate - because a fermenter is kept clean or the batch is
lost, and that is what should tell it apart from the algae tank's green
glass and the bio garden's dome at a glance.

Two moving parts. The agitator coupling turns flat on the roof, with the
motor driving it from behind through a right-angle box, so nothing stands
over it. The CO2 that a ferment gives off leaves through a water seal on the
east side, and its float bobs as the gas bubbles through - the one sign a
brewer looks for that the batch is alive.

Four facings: the water inlet is on the north face and the wash outlet on
the south, and both turn with the entity.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import math                                                   # noqa: E402
import bpy                                                    # noqa: E402
import factorio_render as fr                                  # noqa: E402
from factorio_render import (build_materials, cyl_at, cone_at,  # noqa: E402
                             torus_at, box, MATS, mat, Spin, Slide)

# --- plan ------------------------------------------------------------------
# Vessel pushed a little north, so the wash outlet and the sight glass on
# the south face have ground of their own in front of it.
VX, VY = 0.0, 0.10
V_R = 1.00
SKIRT_Z, SKIRT_H = 0.25, 0.16
SHELL_Z = SKIRT_Z + SKIRT_H             # bottom of the shell
SHELL_H = 1.20
ROOF_H = 0.34
ROOF_TOP = SHELL_Z + SHELL_H + ROOF_H   # ~1.95

# Cooling jacket bands: slightly proud of the shell and darker, so they read
# as a second skin clamped on rather than as painted stripes.
JACKETS = ((SHELL_Z + 0.20, 0.24), (SHELL_Z + 0.74, 0.24))

# Sight glass on the south face of the shell.
WIN_W, WIN_H = 0.34, 0.74
WIN_Z = SHELL_Z + 0.22                  # bottom of the window
WIN_Y = VY - V_R                        # the shell's front face
HX = VX - (V_R + 0.06) * math.sqrt(0.5)  # coolant headers, south-west
HY = VY - (V_R + 0.06) * math.sqrt(0.5)

# Agitator coupling, turning flat on the roof. Four spokes, so one sheet is
# a quarter turn.
SPOKES = 4
SPIN = 360 / SPOKES
HUB_Z = ROOF_TOP + 0.10
COUP_R = 0.30

# CO2 water seal, on the deck to the east of the vessel.
SX, SY = 1.12, -0.62
SEAL_Z, SEAL_H = 0.25, 0.46
FLOAT_STROKE = 0.045                    # a bob, not a stroke

STUB_Z = 0.36


def port(static, m, x, sign):
    """A modelled pipe stub reaching to the entity edge at +/-1.46 in Y."""
    axis = (math.pi / 2, 0, 0)
    static.append(box(0.34, 0.40, 0.40, (x, sign * 1.05, STUB_Z), m=m['iron']))
    static.append(cyl_at(x, sign * 1.30, STUB_Z, 0.165, 0.70, m['steel'],
                         verts=24, rot=axis))
    static.append(cyl_at(x, sign * 1.46, STUB_Z, 0.215, 0.10, m['dark'],
                         verts=24, rot=axis))


def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    # Stainless. Light, so no wear at all - the grime ramp turns any light
    # colour into dark coins (docs/blender-renders.md, Materials). Not
    # fully metallic, or the side of the shell has nothing to reflect under
    # this dim world and goes black.
    m['ss'] = mat("ss", (0.430, 0.435, 0.440), 0.30, 0.75)
    # The roof is the biggest near-horizontal face on the sprite, and this sun
    # turns a glossy one into a white disc. Rougher than the shell.
    m["roof"] = mat("roof", (0.300, 0.305, 0.310), 0.70, 0.55)
    m['jacket'] = mat("jacket", (0.215, 0.220, 0.225), 0.45, 0.85, wear=0.40)
    m['deck'] = mat("deck", (0.060, 0.058, 0.055), 0.80, 0.20, wear=0.55)
    # The brew. Near-neutral in its own sheet so the recipe tint supplies
    # the colour; the icon is not tinted, so there it is straw gold.
    m['brew'] = mat("brew",
                    (0.740, 0.740, 0.725) if fr.PASS == 'tint'
                    else (0.360, 0.250, 0.075),
                    0.35, 0.0)
    # The empty window: what an idle tank shows, and what the brew is drawn
    # over while it runs.
    m['recess'] = mat("recess", (0.018, 0.018, 0.020), 0.60, 0.0)

    static, moving = [], []
    add = static.append

    # --- skid base --------------------------------------------------------
    add(box(2.92, 2.92, 0.12, (0, 0, 0.06), m=m['dark']))
    add(box(2.72, 2.72, 0.09, (0, 0, 0.16), m=m['deck']))
    for sx in (-1, 1):
        for sy in (-1, 1):
            add(cyl_at(sx * 1.24, sy * 1.24, 0.23, 0.075, 0.08, m['steel'],
                       verts=6))

    # --- the vessel -------------------------------------------------------
    add(cyl_at(VX, VY, SKIRT_Z + SKIRT_H / 2, V_R - 0.06, SKIRT_H,
               m['jacket'], verts=48))
    add(cyl_at(VX, VY, SHELL_Z + SHELL_H / 2, V_R, SHELL_H, m['ss'],
               verts=64))
    add(cone_at(VX, VY, SHELL_Z + SHELL_H, V_R, 0.30, ROOF_H, m['roof'],
                verts=64))
    # A rolled rim where roof meets shell, so the two are one vessel and not
    # a cone sitting on a drum.
    add(torus_at((VX, VY, SHELL_Z + SHELL_H), V_R + 0.005, 0.030,
                 m['jacket'], segments=64))
    for z, h in JACKETS:
        add(cyl_at(VX, VY, z + h / 2, V_R + 0.030, h, m['jacket'], verts=64))
        # Coolant headers: short stubs on the south-west flank, between two
        # of the sight glasses, feeding each band.
        add(cyl_at(HX, HY, z + h / 2, 0.055, 0.16, m['steel'], verts=10,
                   rot=(0, math.pi / 2, math.radians(225))))
    add(cyl_at(HX - 0.06, HY - 0.06, (JACKETS[0][0] + JACKETS[1][0]
                                      + JACKETS[1][1]) / 2 + 0.06,
               0.055, JACKETS[1][0] - JACKETS[0][0] + 0.30, m['steel'],
               verts=10))

    # --- sight glasses ----------------------------------------------------
    # A dark recess set into the shell, the brew in front of it, and a frame
    # standing proud of both, in light steel: framed in the jacket's dark
    # grey the window vanished into the bands either side of it. The brew is
    # on the tint sheet and hidden from the entity sheet, so an idle tank
    # shows an empty dark window.
    #
    # One on each quarter of the shell, not one on the front. The camera only
    # ever sees the south face, and a single window turns away with the
    # entity: the first render had brew in the north sheet and nothing at all
    # in the other three.
    for q in range(4):
        a = q * math.pi / 2
        win = [box(WIN_W, 0.10, WIN_H, (VX, WIN_Y + 0.03, WIN_Z + WIN_H / 2),
                   m=m['recess'])]
        brew = box(WIN_W - 0.04, 0.06, WIN_H - 0.16,
                   (VX, WIN_Y - 0.01, WIN_Z + (WIN_H - 0.16) / 2 + 0.04),
                   m=m['brew'])
        fr.TINT.append(brew)
        win.append(brew)
        for sx in (-1, 1):
            win.append(box(0.05, 0.08, WIN_H + 0.06,
                           (VX + sx * (WIN_W / 2 + 0.02), WIN_Y - 0.03,
                            WIN_Z + WIN_H / 2), m=m['steel']))
        for z in (WIN_Z - 0.02, WIN_Z + WIN_H + 0.02):
            win.append(box(WIN_W + 0.10, 0.08, 0.05, (VX, WIN_Y - 0.03, z),
                           m=m['steel']))
        for o in win:
            dx, dy = o.location.x - VX, o.location.y - VY
            o.location.x = VX + dx * math.cos(a) - dy * math.sin(a)
            o.location.y = VY + dx * math.sin(a) + dy * math.cos(a)
            o.rotation_euler[2] += a
            add(o)

    # --- agitator drive ---------------------------------------------------
    # Gearbox on the roof crown, and the motor lying behind it to the north.
    # North of the coupling it is drawn over BY the coupling, which keeps the
    # one turning part on the roof unobstructed.
    add(cyl_at(VX, VY, ROOF_TOP + 0.01, 0.30, 0.06, m['jacket'], verts=32))
    add(box(0.30, 0.30, 0.14, (VX, VY + 0.30, ROOF_TOP + 0.07),
            m=m['iron']))
    add(cyl_at(VX, VY + 0.62, ROOF_TOP + 0.09, 0.14, 0.40, m['yellow'],
               verts=20, rot=(math.pi / 2, 0, 0)))
    add(cyl_at(VX, VY + 0.84, ROOF_TOP + 0.09, 0.15, 0.05, m['dark'],
               verts=20, rot=(math.pi / 2, 0, 0)))

    coupling = [cyl_at(VX, VY, HUB_Z, 0.09, 0.10, m['steel'], verts=16)]
    coupling.append(torus_at((VX, VY, HUB_Z), COUP_R, 0.030, m['steel'],
                             segments=32))
    for i in range(SPOKES):
        a = 2 * math.pi * i / SPOKES
        coupling.append(box(COUP_R * 2 - 0.02, 0.07, 0.05,
                            (VX, VY, HUB_Z), rot=(0, 0, a), m=m['dark']))
        # A bolt head on each spoke end, so the turn reads at 64 px even
        # where the spokes blur together.
        coupling.append(cyl_at(VX + (COUP_R - 0.02) * math.cos(a + math.pi / 4),
                               VY + (COUP_R - 0.02) * math.sin(a + math.pi / 4),
                               HUB_Z + 0.03, 0.035, 0.04, m['yellow'],
                               verts=8))
    moving.append(Spin(coupling, pivot=(VX, VY, 0), axis='Z', degrees=SPIN))

    # --- CO2 vent and water seal ------------------------------------------
    # Vent from the roof, over the east shoulder and down to the seal pot on
    # the deck. It runs along the east edge, clear of the roof crown.
    vx = VX + 0.62
    add(cyl_at(vx, VY - 0.30, SHELL_Z + SHELL_H + 0.20, 0.050, 0.30,
               m['steel'], verts=10))
    add(cyl_at((vx + SX) / 2, VY - 0.30, SHELL_Z + SHELL_H + 0.34, 0.050,
               SX - vx, m['steel'], verts=10, rot=(0, math.pi / 2, 0)))
    add(cyl_at(SX, VY - 0.30, (SEAL_Z + SEAL_H + SHELL_Z + SHELL_H + 0.34) / 2,
               0.050, SHELL_Z + SHELL_H + 0.34 - SEAL_Z - SEAL_H, m['steel'],
               verts=10))
    add(cyl_at(SX, (VY - 0.30 + SY) / 2, SEAL_Z + SEAL_H - 0.02, 0.050,
               abs(SY - VY + 0.30), m['steel'], verts=10,
               rot=(math.pi / 2, 0, 0)))
    add(cyl_at(SX, SY, SEAL_Z + SEAL_H / 2, 0.20, SEAL_H, m['jacket'],
               verts=24))
    add(torus_at((SX, SY, SEAL_Z + SEAL_H), 0.19, 0.022, m['steel'],
                 segments=24))
    bob = [cyl_at(SX, SY, SEAL_Z + SEAL_H + 0.04, 0.13, 0.06, m['yellow'],
                  verts=20)]
    moving.append(Slide(bob, axis='Z', amplitude=FLOAT_STROKE))

    # --- pipework ---------------------------------------------------------
    # Water in from the north port up to the shell; wash out of the bottom
    # of the vessel to the south port, passing west of the sight glass.
    add(cyl_at(0, 1.05, 0.60, 0.085, 0.50, m['steel'], verts=14))
    add(cyl_at(-0.50, VY - V_R + 0.02, 0.33, 0.090, 0.30, m['steel'],
               verts=14, rot=(math.pi / 2, 0, 0)))
    add(cyl_at(-0.25, -0.98, STUB_Z, 0.090, 0.52, m['steel'], verts=14,
               rot=(0, math.pi / 2, 0)))

    # --- fluid connections: N in (water), S out (wash) -------------------
    port(static, m, 0.0, 1)
    port(static, m, 0.0, -1)

    return static, moving


fr.run(build)
