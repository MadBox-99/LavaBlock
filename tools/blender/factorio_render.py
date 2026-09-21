"""Lava centrifuge - Factorio 3x3 entity, rendered for a 64 px/tile sprite sheet.

  blender --background --factory-startup --python lava_centrifuge.py -- \
          --pass entity|shadow --frames 32 --out DIR [--single N]

1 Blender unit = 1 Factorio tile. Orthographic camera at 45 deg elevation,
calibrated against the base-game storage-tank and centrifuge sprites.
"""
import bpy, math, sys, os
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


def _as_groups(spin, pivot, default_degrees):
    """Accept either a flat list of objects (one group, the common case) or a
    list of Spin/Slide groups."""
    if spin and isinstance(spin[0], (Spin, Slide, Grow)):
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


def setup_scene(objs, frame_tiles):
    sc = bpy.context.scene

    # The icon is the same model under the same camera, just framed tight and
    # rendered large so it can be downsampled to a crisp 64 px item icon.
    res = 512 if PASS == 'icon' else int(round(frame_tiles * PX_PER_TILE))
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

    # key sun from WNW ~50 deg up: shadow lands right and slightly down,
    # matching the base-game shadow shift offsets
    d = Vector((0.671, -0.741, -1.19)).normalized()
    s = bpy.data.lights.new("sun", 'SUN')
    # an icon is read at 64 px, so it needs more light than the world sprite
    s.energy, s.angle = (7.5 if PASS == 'icon' else 5.5), math.radians(2.5)
    so = bpy.data.objects.new("sun", s)
    sc.collection.objects.link(so)
    so.rotation_euler = d.to_track_quat('-Z', 'Y').to_euler()

    fl = bpy.data.lights.new("fill", 'SUN')
    # An icon is read at 64 px with no ground and no neighbours to give it
    # context, so shadowed faces that are merely moody on a world sprite just
    # go black and take the silhouette with them. Fill harder for the icon.
    fl.energy = 2.8 if PASS == 'icon' else 1.1
    fo = bpy.data.objects.new("fill", fl)
    sc.collection.objects.link(fo)
    fo.rotation_euler = Vector((-0.6, 0.7, -0.9)).normalized() \
        .to_track_quat('-Z', 'Y').to_euler()

    w = bpy.data.worlds.new("w")
    sc.world = w
    w.use_nodes = True
    w.node_tree.nodes['Background'].inputs[0].default_value = (0.06, 0.07, 0.09, 1)
    w.node_tree.nodes['Background'].inputs[1].default_value = 0.9 if PASS == 'icon' else 0.45

    sc.render.engine = 'CYCLES'
    prefs = bpy.context.preferences.addons['cycles'].preferences
    if DEVICE == 'GPU':
        try:
            prefs.compute_device_type = 'OPTIX'
            prefs.get_devices()
            for dv in prefs.devices:
                dv.use = True
            sc.cycles.device = 'GPU'
        except Exception:
            sc.cycles.device = 'CPU'
    else:
        sc.cycles.device = 'CPU'
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
        for o in TINT:
            o.visible_camera = False

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
    if PASS == 'icon':
        frames = [0]
    elif SINGLE is not None:
        frames = [int(SINGLE)]
    else:
        frames = range(START, FRAMES)
    for f in frames:
        for piv, g in pivots:
            g.pose(piv, f, FRAMES)
        sc.render.filepath = os.path.join(OUTDIR, "%s_%03d.png" % (PASS, f))
        bpy.ops.render.render(write_still=True)
        print("FRAME", f, flush=True)


