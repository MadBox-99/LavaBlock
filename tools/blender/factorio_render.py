"""Lava centrifuge - Factorio 3x3 entity, rendered for a 64 px/tile sprite sheet.

  blender --background --factory-startup --python lava_centrifuge.py -- \
          --pass entity|shadow --frames 32 --out DIR [--single N]

1 Blender unit = 1 Factorio tile. Orthographic camera at 45 deg elevation,
calibrated against the base-game storage-tank and centrifuge sprites.
"""
import bpy, math, sys, os, subprocess
from mathutils import Vector, Matrix

# ---------------------------------------------------------------- arguments
argv = sys.argv[sys.argv.index('--') + 1:] if '--' in sys.argv else []


def arg(k, d=None):
    return argv[argv.index(k) + 1] if k in argv else d


PASS = arg('--pass', 'entity')
FRAMES = int(arg('--frames', 32))
OUTDIR = arg('--out', '.')
SINGLE = arg('--single')
SAMPLES = int(arg('--samples', 128))
START = int(arg('--start', 0))        # resume after a GPU driver hiccup
DEVICE = arg('--device', 'GPU')

# Factorio turns an entity clockwise on screen, which is negative Z in Blender.
DIRECTIONS = {'north': 0, 'east': 90, 'south': 180, 'west': 270}
DIRECTION = arg('--direction', 'north')
assert DIRECTION in DIRECTIONS, DIRECTION

PX_PER_TILE = 64
# Tiles of room around the entity centre. Six is enough for a 3x3 machine and
# its shadow; a bigger footprint needs a bigger frame or the sun-side shadow
# runs off the canvas and the sheet crops to a lie. A model script passes its
# own default to run(); --frame-tiles overrides it.
FRAME_TILES = float(arg('--frame-tiles', 0)) or None
ELEV = 45.0                      # camera elevation above the ground plane

# The technology icon is a different picture of the same machine. Base-game
# technology icons are product shots, not map sprites: a lower, perspective
# three-quarter view with a soft contact shadow under the object. Rendering
# the entity camera bigger instead gives a 256 px copy of the map sprite,
# which reads as a screenshot pasted into the tech tree.
TECH_ELEV = 30.0                 # lower than the map, so the machine has a face
TECH_AZ = 28.0                   # swung round, so two sides show at once
TECH_LENS = 85.0                 # mild perspective; a wide lens distorts it
# The technology pass stands its subject on a shadow catcher, because a
# machine stands on something. A droplet does not, and no fluid icon in the
# game has a shadow under it, so a model that floats turns the ground off.
GROUND = arg('--ground', '1') != '0'

# A camera tilted to ELEV squashes the ground plane by sin(ELEV), but base-game
# entities fill their square tile footprint - a 3x3 machine covers 3x3 tiles on
# screen, not 3x2.1. Pre-stretching the model along Y by 1/sin(ELEV) cancels the
# squash exactly, so ground shapes come out true to plan while vertical faces
# keep the tilted look. Overridable to compare conventions.
YSCALE = float(arg('--yscale', 1.0 / math.sin(math.radians(ELEV))))

MATS = {}

# The recipe-tinted layer. Factorio multiplies a working visualisation by the
# recipe's own colour, so the same machine can show green, blue or red
# contents without three sprite sheets. TINT holds the objects that layer is
# made of; CLEAR holds glass and the like, which must neither appear in it nor
# punch a hole in it, because they are already drawn in the entity sheet.
TINT = []
CLEAR = []


# ---------------------------------------------------------------- materials
def mat(name, base, rough, metal, emit=None, emit_str=0.0, wear=0.0):
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    nt = m.node_tree
    b = nt.nodes['Principled BSDF']
    b.inputs['Base Color'].default_value = (*base, 1)
    b.inputs['Roughness'].default_value = rough
    b.inputs['Metallic'].default_value = metal
    if emit:
        b.inputs['Emission Color'].default_value = (*emit, 1)
        b.inputs['Emission Strength'].default_value = emit_str
    if wear:
        # Grime and scuffing. Smooth CG metal is the single thing that most
        # gives a render away next to hand-painted base-game sprites.
        tc = nt.nodes.new('ShaderNodeTexCoord')
        ns = nt.nodes.new('ShaderNodeTexNoise')
        ns.inputs['Scale'].default_value = 9.0
        ns.inputs['Detail'].default_value = 8.0
        ns.inputs['Roughness'].default_value = 0.65
        nt.links.new(tc.outputs['Object'], ns.inputs['Vector'])

        ramp = nt.nodes.new('ShaderNodeValToRGB')
        ramp.color_ramp.elements[0].position = 0.38
        ramp.color_ramp.elements[1].position = 0.62
        nt.links.new(ns.outputs['Fac'], ramp.inputs['Fac'])

        mixc = nt.nodes.new('ShaderNodeMix')
        mixc.data_type = 'RGBA'
        mixc.inputs['Factor'].default_value = wear
        mixc.inputs[6].default_value = (*base, 1)
        mixc.inputs[7].default_value = (base[0] * 0.42 + 0.045,
                                        base[1] * 0.38 + 0.020,
                                        base[2] * 0.34 + 0.012, 1)
        nt.links.new(ramp.outputs['Color'], mixc.inputs['Factor'])
        nt.links.new(mixc.outputs[2], b.inputs['Base Color'])

        mixr = nt.nodes.new('ShaderNodeMix')
        mixr.data_type = 'FLOAT'
        mixr.inputs[2].default_value = rough
        mixr.inputs[3].default_value = min(rough + 0.34, 1.0)
        nt.links.new(ramp.outputs['Color'], mixr.inputs['Factor'])
        nt.links.new(mixr.outputs[0], b.inputs['Roughness'])
    return m


def build_materials():
    # Factorio machines read as mid grey-beige with ochre accents; emission is
    # kept low enough that the glow stays orange instead of clipping to white.
    MATS.update(
        iron=mat("iron", (0.175, 0.165, 0.150), 0.50, 1.0, wear=0.85),
        steel=mat("steel", (0.400, 0.380, 0.345), 0.36, 1.0, wear=0.70),
        dark=mat("dark", (0.085, 0.080, 0.075), 0.62, 1.0, wear=0.60),
        yellow=mat("yellow", (0.560, 0.390, 0.055), 0.42, 0.35, wear=0.75),
        hot=mat("hot", (0.180, 0.060, 0.020), 0.55, 0.7,
                emit=(1.00, 0.20, 0.02), emit_str=1.5),
        lava=mat("lava", (0.090, 0.030, 0.010), 0.75, 0.0,
                 emit=(1.00, 0.24, 0.02), emit_str=1.9),
    )


# ---------------------------------------------------------------- primitives
def cyl(r, h, z, verts=64, m=None, name="c"):
    bpy.ops.mesh.primitive_cylinder_add(vertices=verts, radius=r, depth=h,
                                        location=(0, 0, z + h / 2))
    o = bpy.context.object
    o.name = name
    if m:
        o.data.materials.append(m)
    return o


def cyl_at(x, y, z, r, h, m, verts=20, rot=(0, 0, 0)):
    bpy.ops.mesh.primitive_cylinder_add(vertices=verts, radius=r, depth=h,
                                        location=(x, y, z), rotation=rot)
    o = bpy.context.object
    o.data.materials.append(m)
    return o


def cone(r1, r2, h, z, verts=64, m=None, name="k"):
    bpy.ops.mesh.primitive_cone_add(vertices=verts, radius1=r1, radius2=r2,
                                    depth=h, location=(0, 0, z + h / 2))
    o = bpy.context.object
    o.name = name
    if m:
        o.data.materials.append(m)
    return o


def box(sx, sy, sz, loc, rot=(0, 0, 0), m=None, name="b"):
    bpy.ops.mesh.primitive_cube_add(size=1, location=loc, rotation=rot)
    o = bpy.context.object
    o.name = name
    o.scale = (sx, sy, sz)
    if m:
        o.data.materials.append(m)
    return o


def bar(p1, p2, thickness, material):
    """A square bar spanning two points - a rib, a brace, a run of pipe.

    A box rotated by (0, pitch, yaw) sends its local +X to
    (cos p cos y, cos p sin y, -sin p), so the pitch is negated.
    """
    d = (p2[0] - p1[0], p2[1] - p1[1], p2[2] - p1[2])
    length = math.sqrt(sum(c * c for c in d))
    mid = tuple((a + b) / 2 for a, b in zip(p1, p2))
    yaw = math.atan2(d[1], d[0])
    pitch = -math.asin(d[2] / length)
    return box(length, thickness, thickness, mid, rot=(0, pitch, yaw),
               m=material)


def torus_at(loc, major, minor, material, rot=(0, 0, 0), segments=40):
    bpy.ops.mesh.primitive_torus_add(location=loc, rotation=rot,
                                     major_radius=major, minor_radius=minor,
                                     major_segments=segments, minor_segments=8)
    o = bpy.context.object
    o.data.materials.append(material)
    return o


def perforated_drum(x, y, z, r_out, wall, h, m, rows=6, per_row=24,
                    hole_r=0.045, stagger=True, verts=48, name="drum"):
    """A thin-walled cylinder drilled with a grid of round holes.

    Standing in front of something lit - a glowing rotor, a culture, a flame
    - the holes are what make it read as a screen rather than as a painted
    tube. A ring of separate bars does not: at 64 px a tile the gaps between
    bars close up and it goes back to being a tube.

    The pattern repeats every 360/per_row degrees, and a staggered row is
    offset by half of one step, so every row shares that same symmetry. A
    Spin over the sheet must therefore turn the drum by a whole number of
    steps or the loop jumps - assert it at the call site, the way the fan
    blades do.
    """
    bpy.ops.mesh.primitive_cylinder_add(vertices=verts, radius=r_out,
                                        depth=h, location=(x, y, z))
    shell = bpy.context.object
    shell.name = name
    shell.data.materials.append(m)

    # Bore and holes are two separate booleans on purpose. Joined into one
    # cutter they would overlap each other, and the exact solver is much
    # happier subtracting two clean meshes than one self-intersecting one.
    bpy.ops.mesh.primitive_cylinder_add(vertices=verts, radius=r_out - wall,
                                        depth=h + 0.02, location=(x, y, z))
    bore = bpy.context.object

    step = 2 * math.pi / per_row
    holes = []
    for i in range(rows):
        cz = z - h / 2 + h * (i + 0.5) / rows
        off = step / 2 if (stagger and i % 2) else 0.0
        for k in range(per_row):
            a = k * step + off
            bpy.ops.mesh.primitive_cylinder_add(
                vertices=12, radius=hole_r, depth=wall * 4,
                location=(x + (r_out - wall / 2) * math.cos(a),
                          y + (r_out - wall / 2) * math.sin(a), cz),
                rotation=(0, math.pi / 2, a))
            holes.append(bpy.context.object)

    # One join and one solve. A modifier per hole would be a hundred and
    # fifty boolean solves every time build() runs, and it runs once per
    # facing per pass.
    bpy.ops.object.select_all(action='DESELECT')
    for o in holes:
        o.select_set(True)
    bpy.context.view_layer.objects.active = holes[0]
    bpy.ops.object.join()
    drill = bpy.context.object

    for cutter in (bore, drill):
        mod = shell.modifiers.new("cut", 'BOOLEAN')
        mod.operation = 'DIFFERENCE'
        mod.object = cutter
        bpy.context.view_layer.objects.active = shell
        bpy.ops.object.modifier_apply(modifier=mod.name)

    # Delete the cutters outright. assemble() asserts that every mesh in the
    # scene came back from build(), and a cutter left behind would trip it -
    # which is exactly what that assert is there for.
    for cutter in (bore, drill):
        mesh = cutter.data
        bpy.data.objects.remove(cutter, do_unlink=True)
        bpy.data.meshes.remove(mesh)
    return shell


def cone_at(x, y, z, r1, r2, h, m, verts=24):
    bpy.ops.mesh.primitive_cone_add(vertices=verts, radius1=r1, radius2=r2,
                                    depth=h, location=(x, y, z + h / 2))
    o = bpy.context.object
    o.data.materials.append(m)
    return o


def ring_of(fn, count, radius, z, phase=0.0):
    out = []
    for i in range(count):
        a = phase + 2 * math.pi * i / count
        out.append(fn(radius * math.cos(a), radius * math.sin(a), a, z))
    return out


def finish(objs, width=0.012, segments=2):
    """Bevelled edges + auto smooth: gives the crisp specular edge highlights
    that make a render read as Factorio art."""
    for o in objs:
        if o.type != 'MESH':
            continue
        mo = o.modifiers.new("bev", 'BEVEL')
        mo.width, mo.segments = width, segments
        mo.limit_method = 'ANGLE'
        mo.angle_limit = math.radians(40)
        bpy.context.view_layer.objects.active = o
        try:
            bpy.ops.object.shade_auto_smooth(angle=math.radians(35))
        except Exception:
            for p in o.data.polygons:
                p.use_smooth = False


# ---------------------------------------------------------------- the model


AXES = {'X': 0, 'Y': 1, 'Z': 2}


class Spin:
    """One independently turning assembly.

    A machine is rarely one moving thing. Each Spin carries its own objects,
    its own axis of rotation, and how far it turns over the whole sheet - so a
    big slow fan and two small quick extractors can live in the same model and
    still loop seamlessly, as long as each angle is one the parts are
    symmetric under.

    `axis` is 'X', 'Y' or 'Z' in entity space. Z is a fan lying flat; Y is a
    wheel standing up and facing the camera.
    """

    def __init__(self, objs, pivot=(0, 0, 0), axis='Z', degrees=None):
        assert axis in AXES, axis
        self.objs = list(objs)
        self.pivot = pivot
        self.axis = axis
        self.degrees = degrees        # None: take run()'s spin_degrees

    def pose(self, empty, f, frames):
        rot = [0.0, 0.0, 0.0]
        rot[AXES[self.axis]] = math.radians(self.degrees) * f / frames
        empty.rotation_euler = rot


class Slide:
    """One independently reciprocating assembly - a piston, a ram, a shuttle.

    Not everything on a machine turns, and a part that only goes up and down
    says "pump" in a way no amount of spinning does. Offset over the sheet is
    amplitude*sin(2*pi*f/frames), which is back where it started on the last
    frame, so the loop closes for the same reason a whole number of turns
    does - and it eases at both ends of the stroke, the way a crank-driven
    piston actually moves.

    `phase` is in turns, so two rams can be given 0 and 0.5 to work against
    each other.
    """

    def __init__(self, objs, axis='Z', amplitude=0.15, phase=0.0):
        assert axis in AXES, axis
        self.objs = list(objs)
        self.pivot = (0, 0, 0)        # children keep their authored positions
        self.axis = axis
        self.amplitude = amplitude
        self.phase = phase

    def pose(self, empty, f, frames):
        loc = [0.0, 0.0, 0.0]
        loc[AXES[self.axis]] = self.amplitude * math.sin(
            2 * math.pi * (f / frames + self.phase))
        empty.location = loc


class Swing:
    """One assembly hinged on a line and rocked back and forth about it.

    For a part that is held at one end and free at the other: a louvre
    blade, a hanging plate, a damper flap - anything the airflow through a
    machine would move rather than drive. Spin turns a thing that is driven;
    this rocks a thing that is pushed.

    Unlike Spin the hinge is an arbitrary vector, not one of X, Y and Z. A
    plate standing on the flank of a round tower hinges about a horizontal
    line that is tangential there, which is only an axis-aligned direction
    at four places around the ring. Blender is asked for the rotation in
    axis-angle form, which takes that vector directly and needs no euler
    gymnastics to compose.

    The angle is degrees*sin(2*pi*(f/frames + phase)), which is back where
    it started on the last frame, so the loop closes for the same reason
    Slide's does - and it eases at both ends of the travel, the way
    something moved by a fluid actually settles rather than snapping.

    `phase` is in turns. Give a ring of plates evenly spaced phases and the
    movement runs round the machine as a wave instead of every plate
    flapping in unison, which is the difference between air moving through
    a building and a row of parts sharing one animation.
    """

    def __init__(self, objs, pivot, axis_vec, degrees=7.0, phase=0.0):
        self.objs = list(objs)
        self.pivot = tuple(pivot)
        n = math.sqrt(sum(c * c for c in axis_vec))
        assert n > 1e-9, "Swing needs a non-degenerate axis"
        self.axis_vec = tuple(c / n for c in axis_vec)
        self.degrees = degrees
        self.phase = phase

    def pose(self, empty, f, frames):
        ang = math.radians(self.degrees) * math.sin(
            2 * math.pi * (f / frames + self.phase))
        empty.rotation_mode = 'AXIS_ANGLE'
        empty.rotation_axis_angle = (ang,) + self.axis_vec


class Grow:
    """One assembly that fills up in place and then drains - a culture tube,
    a hopper, a settling tank.

    Growth is the one motion that does not loop by itself: a thing that gets
    bigger every frame has to get back to nothing somehow. It does that by
    draining over the tail of the sheet instead of snapping back, so the
    curve is continuous at the seam and there is no pop. `hold` is the
    fraction of the sheet spent filling; the rest is the drain.

    `phase` is in turns. A ring of tubes given evenly spaced phases never all
    drains at once, which is what makes a rack of them read as a process
    rather than as one animation copied six times.

    `low` keeps a sliver of substance at the bottom: a zero-scaled mesh
    renders as a degenerate sliver rather than as nothing, and an empty tube
    that is never quite empty also just looks better.
    """

    def __init__(self, objs, pivot=(0, 0, 0), axis='Z', phase=0.0,
                 low=0.05, hold=0.85):
        assert axis in AXES, axis
        assert 0.0 < hold < 1.0, hold
        self.objs = list(objs)
        self.pivot = pivot            # scale about the base, not the centre
        self.axis = axis
        self.phase = phase
        self.low = low
        self.hold = hold

    def pose(self, empty, f, frames):
        t = (f / frames + self.phase) % 1.0
        k = t / self.hold if t < self.hold else (1.0 - t) / (1.0 - self.hold)
        sc = [1.0, 1.0, 1.0]
        sc[AXES[self.axis]] = self.low + (1.0 - self.low) * max(0.0, min(1.0, k))
        empty.scale = sc


def slider_crank(centre, radius, length, f, frames, sign=1, phase=0.0,
                 bore=(0.0, 1.0)):
    """Where the two ends of a connecting rod are on frame f.

    The big end runs round an eccentric or crank pin of `radius` on the shaft
    at `centre`; the small end is held on a bore through that shaft, so its
    travel is not a sine - the rod leans, and a short rod leans a lot, so the
    small end dwells noticeably longer at the far end of its stroke than at
    the near one. A Slide gives the symmetric version of the same stroke, and
    that reads as a pump rather than as an engine.

    `bore` is the direction the small end runs, in the XZ plane - the plane
    the eccentric turns in, since the shaft lies along Y. It does not have to
    be straight up, and usually should not be: a bore pointing at the sky puts
    the cylinder over whatever the machine is there to show, while one angled
    outwards puts it in the corner of the sprite where there is nothing.

    Returns (big_x, big_z, tilt, small_x, small_z) in entity space.
    """
    assert length > radius, "a rod shorter than the throw cannot turn the shaft"
    ux, uz = bore
    n = math.hypot(ux, uz)
    assert n > 1e-9, "the bore has no direction"
    ux, uz = ux / n, uz / n
    a = 2 * math.pi * (sign * f / frames + phase)
    bx = centre[0] + radius * math.sin(a)
    bz = centre[2] + radius * math.cos(a)
    k = ux * (bx - centre[0]) + uz * (bz - centre[2])
    disc = length * length - radius * radius + k * k
    assert disc > 0.0, "the rod cannot reach the bore"
    t = k + math.sqrt(disc)
    sx, sz = centre[0] + t * ux, centre[2] + t * uz
    return bx, bz, math.atan2(sx - bx, sz - bz), sx, sz


class Rod:
    """A connecting rod: round big end on the shaft, small end in the bore.

    Unlike Spin and Slide this poses both the location and the rotation of its
    empty, because a rod neither turns in place nor slides in a line - it does
    both at once, and that combination is the whole reason it reads as an
    engine rather than as a part being animated.

    Model the shank running straight up (+Z) from the big end, wherever the
    bore actually points: the empty carries the whole tilt, including on
    frame 0, so the authored pose only has to get the length right.

    `sign` and `phase` must match the Spin of the shaft it sits on, or the
    big end parts company with its pin - and nothing will warn you, the two
    just drift.
    """

    def __init__(self, objs, centre, radius, length, phase=0.0, sign=1,
                 bore=(0.0, 1.0)):
        self.objs = list(objs)
        self.centre = tuple(centre)
        self.radius = radius
        self.length = length
        self.phase = phase
        self.sign = sign
        self.bore = bore
        bx, bz = self._solve(0, 1)[0], self._solve(0, 1)[1]
        self.pivot = (bx, centre[1], bz)          # rest pose, frame 0

    def _solve(self, f, frames):
        return slider_crank(self.centre, self.radius, self.length, f, frames,
                            self.sign, self.phase, self.bore)

    def pose(self, empty, f, frames):
        bx, bz, tilt, _, _ = self._solve(f, frames)
        empty.location = (bx, self.centre[1], bz)
        empty.rotation_euler = (0, tilt, 0)


class Piston:
    """The small end of a Rod - the crosshead, or the piston itself.

    Its own group because it does not tilt with the rod, it only rides the
    bore. Built with the same centre, radius, length and bore as its Rod, and
    posed from the same solution, so the two cannot drift apart. Model it
    where frame 0 puts it, like the rod.
    """

    def __init__(self, objs, centre, radius, length, phase=0.0, sign=1,
                 bore=(0.0, 1.0)):
        self.objs = list(objs)
        self.centre = tuple(centre)
        self.radius = radius
        self.length = length
        self.phase = phase
        self.sign = sign
        self.bore = bore
        self.pivot = (0, 0, 0)        # children keep their authored positions
        self.rest = self._solve(0, 1)[3:]

    def _solve(self, f, frames):
        return slider_crank(self.centre, self.radius, self.length, f, frames,
                            self.sign, self.phase, self.bore)

    def pose(self, empty, f, frames):
        sx, sz = self._solve(f, frames)[3:]
        empty.location = (sx - self.rest[0], 0, sz - self.rest[1])


def _as_groups(spin, pivot, default_degrees):
    """Accept either a flat list of objects (one group, the common case) or a
    list of Spin/Slide groups."""
    if spin and isinstance(spin[0], (Spin, Slide, Swing, Grow, Rod,
                                     Piston)):
        groups = spin
    else:
        groups = [Spin(spin, pivot=pivot)]
    for g in groups:
        if isinstance(g, Spin) and g.degrees is None:
            g.degrees = default_degrees
    return groups


def assemble(static, spin, pivot=(0, 0, 0), degrees=120):
    """Wire a model's objects into the hierarchy the renderer expects.

    SPIN.n - one empty per moving assembly; run() turns each once per frame.
             Each sits at its group's own axis: a part modelled away from the
             origin would otherwise orbit the entity centre instead of
             spinning in place.
    TURN   - the entity's facing. It sits UNDER the Y pre-stretch, so the
             machine turns in plan; rotating above ROOT would shear it.
    ROOT   - the Y pre-stretch that squares up the footprint.
    """
    groups = _as_groups(spin, pivot, degrees)
    moving = [o for g in groups for o in g.objs]

    # A model that builds an object but forgets to hand it back is the easiest
    # mistake to make here and the hardest to see: it still renders, but it
    # never gets parented, so it keeps its own position while the rest of the
    # machine is turned to face a direction and pre-stretched along Y - and in
    # the tint pass it is never made a holdout either. Catch it now rather
    # than in a sheet three facings later.
    # An object handed back in *both* lists is the nastiest version of the
    # same mistake: the static pass below re-parents it to TURN after its
    # group has claimed it, so it renders in the right place and simply never
    # moves. Nothing looks broken; the animation is just dead.
    static_ids = set(id(o) for o in static)
    both = [o.name for o in moving if id(o) in static_ids]
    assert not both, "objects in both static and a moving group: %s" % both

    known = set(id(o) for o in static + moving)
    stray = [o.name for o in bpy.data.objects
             if o.type == 'MESH' and id(o) not in known]
    assert not stray, "objects built but not returned by build(): %s" % stray
    for name, group in (('TINT', TINT), ('CLEAR', CLEAR)):
        loose = [o.name for o in group if id(o) not in known]
        assert not loose, "%s objects missing from static/moving: %s" % (
            name, loose)

    finish(static + moving)

    pivots = []
    for i, g in enumerate(groups):
        bpy.ops.object.empty_add(location=g.pivot)
        piv = bpy.context.object
        piv.name = "SPIN.%d" % i
        # Cancel the pivot's own translation, so the children keep the world
        # positions build() gave them and only the rotation centre moves.
        inv = Matrix.Translation(-Vector(g.pivot))
        for o in g.objs:
            o.parent = piv
            o.matrix_parent_inverse = inv
        pivots.append((piv, g))

    bpy.ops.object.empty_add(location=(0, 0, 0))
    turn = bpy.context.object
    turn.name = "TURN"
    turn.rotation_euler = (0, 0, -math.radians(DIRECTIONS[DIRECTION]))
    for o in static + [p for p, _ in pivots]:
        o.parent = turn
        o.matrix_parent_inverse = Matrix.Identity(4)

    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.object
    root.name = "ROOT"
    root.scale = (1.0, YSCALE, 1.0)
    turn.parent = root
    turn.matrix_parent_inverse = Matrix.Identity(4)
    return pivots, static + moving


def hide_completely(o):
    """Take an object out of the render entirely, for every ray type.

    Cycles' visible_camera only stops the object being seen directly; it
    still blocks light, casts shadows and bounces colour. For contents that
    belong to another sheet that is never what is wanted.
    """
    for attr in ('visible_camera', 'visible_diffuse', 'visible_glossy',
                 'visible_transmission', 'visible_volume_scatter',
                 'visible_shadow'):
        setattr(o, attr, False)


def free_vram():
    """Megabytes of video memory not already spoken for, or None if unknown."""
    try:
        out = subprocess.run(
            ['nvidia-smi', '--query-gpu=memory.free',
             '--format=csv,noheader,nounits'],
            capture_output=True, text=True, timeout=10)
        return int(out.stdout.split()[0])
    except Exception:
        return None


# Under this much free video memory, OptiX is liable to fail mid-kernel rather
# than refuse the job up front. Measured, not guessed: the scenes here fit in
# well under a gigabyte, and the renders that died were the ones started with
# the game and a browser already holding four and a half.
VRAM_FLOOR = 1500


def pick_device():
    """Configure Cycles' compute devices and say which one we got.

    Two things here are worth stating, because either one gets you "Illegal
    address in CUDA queue" halfway through a sprite sheet and neither shows
    up in the error.

    The device list holds the same card twice - once as CUDA, once as OPTIX -
    and the CPU once, shared between the backends. Enabling everything, which
    is the obvious loop to write, silently turns on hybrid CPU+GPU rendering:
    the scene is then resident in host memory as well as in VRAM, and at 64
    to 256 pixels the GPU has finished the frame before the CPU has finished
    its first tile. All cost, no gain. So only the devices belonging to the
    backend we asked for are switched on.

    And this is a 6 GB card with the desktop on it. With Factorio and a
    browser open, under 1.5 GB is left, and OptiX does not report that as out
    of memory - the allocation fails inside a kernel and surfaces as an
    illegal address. The free memory is therefore measured and printed,
    because the fix is to close something and no log line will ever say so.
    """
    if DEVICE != 'GPU':
        print("device: CPU (asked for)", flush=True)
        return 'CPU'

    prefs = bpy.context.preferences.addons['cycles'].preferences
    for backend in ('OPTIX', 'CUDA'):
        try:
            prefs.compute_device_type = backend
        except Exception:
            continue                      # not built in, or no driver for it
        prefs.get_devices()
        picked = [d for d in prefs.devices if d.type == backend]
        if not picked:
            continue
        for d in prefs.devices:
            d.use = d.type == backend     # never the CPU alongside it
        mb = free_vram()
        room = "%d MB free" % mb if mb is not None else "free VRAM unknown"
        print("device: %s, %s (%s)"
              % (backend, picked[0].name, room), flush=True)
        if mb is not None and mb < VRAM_FLOOR:
            print("WARNING: only %d MB of video memory is free. Close"
                  " Factorio and the browser, or this render will fall back"
                  " to the CPU part way through." % mb, flush=True)
        return 'GPU'

    print("device: CPU (no usable GPU backend)", flush=True)
    return 'CPU'


_ON_CPU = False        # once the GPU has let us down, it does not get it back


def fall_back_to_cpu(sc):
    """Take Cycles off the GPU for the rest of this process.

    Setting scene.cycles.device is not enough, and finding that out cost a
    whole sheet of "Failed to retain CUDA context" retries. Once a kernel
    faults, the CUDA context is poisoned, and Cycles goes on trying to
    retain that same dead context for every later render - the scene-level
    device only chooses which device to *use*, it does not tell the add-on
    to stop holding the one it already has.

    Turning the backend itself off does: with compute_device_type at NONE
    and every device unticked, there is no CUDA context to retain.
    """
    global _ON_CPU
    _ON_CPU = True
    sc.cycles.device = 'CPU'
    try:
        prefs = bpy.context.preferences.addons['cycles'].preferences
        for d in prefs.devices:
            d.use = d.type == 'CPU'
        prefs.compute_device_type = 'NONE'
    except Exception as e:
        print("could not release the GPU backend: %s" % e, flush=True)


def render_to(sc, path):
    """Render one frame to `path`, surviving a GPU that dies under us.

    A driver fault is not something a render script can prevent, so it takes
    the fault instead of the loss and moves the whole run to the CPU on the
    first failure. Not one GPU retry first: when this card goes it goes
    several times in a row, so a retry only buys another minute of the same
    error. Slow frames beat a sheet missing its last ten, which is what a
    bare render call leaves behind.

    The caller is expected to be re-runnable as well - see the retry loop in
    render_all.sh. A fresh process gets a fresh CUDA context and is back on
    the GPU, which is much faster than finishing a long sheet on the CPU, so
    this fallback is the safety net rather than the plan.
    """
    sc.render.filepath = path
    for attempt in (1, 2, 3):
        try:
            bpy.ops.render.render(write_still=True)
            if os.path.exists(path):
                return
            why = "the render reported success but wrote no file"
        except Exception as e:
            why = (str(e).strip().splitlines() or [repr(e)])[0]
        print("RENDER FAILED (attempt %d): %s" % (attempt, why), flush=True)
        if not _ON_CPU:
            fall_back_to_cpu(sc)
            print("switching to the CPU for the rest of this run", flush=True)
    raise RuntimeError("gave up on %s after three attempts" % path)


def setup_scene(objs, frame_tiles):
    sc = bpy.context.scene

    # The icon is the same model under the same camera, just framed tight and
    # rendered large so it can be downsampled to a crisp 64 px item icon.
    res = 512 if PASS in ('icon', 'tech') else int(round(frame_tiles * PX_PER_TILE))
    tiles_across = 4.3 if PASS == 'icon' else frame_tiles

    cam_d = bpy.data.cameras.new("cam")
    cam_d.type = 'ORTHO'
    cam_d.ortho_scale = tiles_across
    cam = bpy.data.objects.new("cam", cam_d)
    sc.collection.objects.link(cam)
    sc.camera = cam
    rx = math.radians(90 - ELEV)
    cam.rotation_euler = (rx, 0, 0)
    cam.location = (0, -math.sin(rx) * 40, math.cos(rx) * 40)

    if PASS == 'icon':
        # Centre and fit the icon frame on the model. The world sprite must
        # stay anchored on the entity origin - Factorio needs a stable origin
        # to line the sheet up with the tile - but an icon only has to show the
        # whole machine, and a tall one runs straight out of the top of a frame
        # centred on the ground.
        bpy.context.view_layer.update()
        up = Vector((0, math.cos(rx), math.sin(rx)))     # screen up, in world
        right = Vector((1, 0, 0))
        us, rs = [], []
        for o in objs:
            if o.type != 'MESH':
                continue
            for c in o.bound_box:
                w = o.matrix_world @ Vector(c)
                us.append(w.dot(up))
                rs.append(w.dot(right))
        cu, cr = (min(us) + max(us)) / 2, (min(rs) + max(rs)) / 2
        cam_d.ortho_scale = max(max(us) - min(us), max(rs) - min(rs)) * 1.06
        cam.location = Vector(cam.location) + up * cu + right * cr

    if PASS == 'tech':
        # The Y pre-stretch squares the footprint up under the 45 degree map
        # camera. This camera is free of that convention, so leaving the
        # stretch in would simply make the machine half again too deep.
        bpy.data.objects['ROOT'].scale = (1, 1, 1)
        bpy.context.view_layer.update()
        cam_d.type = 'PERSP'
        cam_d.lens = TECH_LENS

        pts = [o.matrix_world @ Vector(c)
               for o in objs if o.type == 'MESH' for c in o.bound_box]
        lo = Vector((min(v.x for v in pts), min(v.y for v in pts),
                     min(v.z for v in pts)))
        hi = Vector((max(v.x for v in pts), max(v.y for v in pts),
                     max(v.z for v in pts)))
        ctr, radius = (lo + hi) / 2, (hi - lo).length / 2

        az, el = math.radians(TECH_AZ), math.radians(TECH_ELEV)
        away = Vector((math.sin(az) * math.cos(el),
                       -math.cos(az) * math.cos(el), math.sin(el)))
        # Fit the bounding sphere, then back off a little further: the contact
        # shadow spreads away from the sun and is part of the picture.
        dist = radius / math.sin(cam_d.angle / 2) * 1.16
        cam.location = ctr + away * dist
        cam.rotation_euler = (ctr - cam.location).to_track_quat(
            '-Z', 'Y').to_euler()

    # key sun from WNW ~50 deg up: shadow lands right and slightly down,
    # matching the base-game shadow shift offsets
    d = Vector((0.671, -0.741, -1.19)).normalized()
    s = bpy.data.lights.new("sun", 'SUN')
    # an icon is read at 64 px, so it needs more light than the world sprite
    bright = PASS in ('icon', 'tech')
    s.energy, s.angle = (7.5 if bright else 5.5), math.radians(2.5)
    if PASS == 'tech':
        # Steeper and much softer than the map sun. The sprite sun is set up
        # to throw a long shadow sideways, which is what Factorio draws as a
        # separate shadow layer; here the shadow is inside the picture, and a
        # long hard one both pushes the machine out of the frame and reads as
        # a second object. Base-game technology icons sit on a short, soft
        # contact shadow instead.
        d = Vector((0.55, -0.62, -1.75)).normalized()
        s.angle = math.radians(9.0)
    so = bpy.data.objects.new("sun", s)
    sc.collection.objects.link(so)
    so.rotation_euler = d.to_track_quat('-Z', 'Y').to_euler()

    fl = bpy.data.lights.new("fill", 'SUN')
    # An icon is read at 64 px with no ground and no neighbours to give it
    # context, so shadowed faces that are merely moody on a world sprite just
    # go black and take the silhouette with them. Fill harder for the icon.
    fl.energy = 2.8 if bright else 1.1
    fo = bpy.data.objects.new("fill", fl)
    sc.collection.objects.link(fo)
    fo.rotation_euler = Vector((-0.6, 0.7, -0.9)).normalized() \
        .to_track_quat('-Z', 'Y').to_euler()

    w = bpy.data.worlds.new("w")
    sc.world = w
    w.use_nodes = True
    w.node_tree.nodes['Background'].inputs[0].default_value = (0.06, 0.07, 0.09, 1)
    w.node_tree.nodes['Background'].inputs[1].default_value = 0.9 if bright else 0.45

    sc.render.engine = 'CYCLES'
    sc.cycles.device = pick_device()
    sc.cycles.samples = SAMPLES
    sc.cycles.use_denoising = True
    sc.render.film_transparent = True
    sc.render.resolution_x = sc.render.resolution_y = res
    sc.render.resolution_percentage = 100
    sc.render.image_settings.file_format = 'PNG'
    sc.render.image_settings.color_mode = 'RGBA'
    sc.view_settings.view_transform = 'Standard'     # no AgX washout on the glow

    if PASS == 'tint':
        # Everything that is not the tinted contents becomes a holdout: it
        # stays in the scene, so the contents are still lit and shadowed the
        # way they are in the entity sheet, but it renders as a hole. That is
        # what makes the layer safe to draw on top - a rib crossing a tube
        # cuts the tube out of this sheet exactly where it covers it.
        keep, see = set(o.name for o in TINT), set(o.name for o in CLEAR)
        for o in objs:
            if o.name in keep:
                continue
            if o.name in see:
                o.visible_camera = False
            else:
                o.is_holdout = True

    elif PASS in ('entity', 'shadow'):
        # The tinted contents belong to their own sheet only. Drawing them in
        # the entity sheet as well would paint them twice, once untinted.
        # The icon keeps them: an item icon of six empty tubes says nothing.
        #
        # Out of every ray type, not just the camera. Clearing visible_camera
        # alone leaves the object lighting the scene: the bio garden's pool of
        # pulp is a disc filling the whole thickener pan, and although the
        # entity sheet did not show it, it laid a shadow over everything in
        # the pan - which came out as a black hole under a glass dome.
        for o in TINT:
            hide_completely(o)

    if PASS == 'tech' and GROUND:
        # A shadow catcher, not a floor. With a transparent film Cycles writes
        # the shadow into the alpha and the ground itself stays invisible,
        # which is exactly the soft contact shadow base-game technology icons
        # sit on - and it is what stops the machine floating in the tech tree.
        bpy.ops.mesh.primitive_plane_add(size=60, location=(0, 0, 0))
        bpy.context.object.is_shadow_catcher = True

    if PASS == 'shadow':
        bpy.ops.mesh.primitive_plane_add(size=40, location=(0, 0, 0))
        bpy.context.object.is_shadow_catcher = True
        for o in objs:
            o.visible_camera = False                 # cast only, stay invisible
        # Sun only. Sky and fill light would blanket the catcher in a wide, faint
        # ambient-occlusion halo, which is not what a Factorio shadow sprite is.
        fl.energy = 0.0
        w.node_tree.nodes['Background'].inputs[1].default_value = 0.0
    return sc


# ---------------------------------------------------------------- render
def run(build, spin_degrees=120, pivot=(0, 0, 0), frame_tiles=6):
    """Entry point for a model script.

    `build` returns (static_objects, moving). `moving` is either a flat list of
    objects, all turned by `spin_degrees` about `pivot`, or a list of Spin and
    Slide groups, each with its own axis and motion. Choose turn angles the
    parts are symmetric under so the loop closes seamlessly - 120 for three
    arms, 60 for a six-blade fan; a Slide closes on its own. `pivot` defaults
    to the origin, which is right only when the moving assembly is modelled
    there.
    """
    pivots, objs = assemble(*build(), pivot=pivot, degrees=spin_degrees)
    sc = setup_scene(objs, FRAME_TILES or frame_tiles)
    os.makedirs(OUTDIR, exist_ok=True)
    if PASS in ('icon', 'tech'):
        frames = [0]
    elif SINGLE is not None:
        frames = [int(SINGLE)]
    else:
        frames = range(START, FRAMES)
    for f in frames:
        for piv, g in pivots:
            g.pose(piv, f, FRAMES)
        render_to(sc, os.path.join(OUTDIR, "%s_%03d.png" % (PASS, f)))
        print("FRAME", f, flush=True)


