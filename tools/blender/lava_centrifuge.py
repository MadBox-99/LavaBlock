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
RES = 384                        # 6x6 tiles of room around the entity centre
SPIN = math.radians(120)         # 3-fold symmetry -> seamless loop
ELEV = 45.0                      # camera elevation above the ground plane

# A camera tilted to ELEV squashes the ground plane by sin(ELEV), but base-game
# entities fill their square tile footprint - a 3x3 machine covers 3x3 tiles on
# screen, not 3x2.1. Pre-stretching the model along Y by 1/sin(ELEV) cancels the
# squash exactly, so ground shapes come out true to plan while vertical faces
# keep the tilted look. Overridable to compare conventions.
YSCALE = float(arg('--yscale', 1.0 / math.sin(math.radians(ELEV))))

MATS = {}


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
def build():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    build_materials()
    m = MATS
    static, spin = [], []

    # --- foundation: octagonal plate + bolt ring -------------------------
    static.append(cyl(1.46, 0.10, 0.00, verts=8, m=m['dark'], name="pad"))
    static.append(cyl(1.34, 0.08, 0.10, verts=8, m=m['iron'], name="pad2"))
    static += ring_of(lambda x, y, a, z: cyl_at(x, y, z, 0.045, 0.05, m['steel'], verts=6),
                      16, 1.24, 0.20)

    # Wide plinth, narrow tall tower. With the ground unsquashed you see a lot
    # of top surface, so anything wide up high reads as a lid and hides the
    # drum - the base-game centrifuge solves this the same way.

    # --- lower vessel with a glowing heat seam ---------------------------
    static.append(cyl(1.06, 0.62, 0.18, m=m['iron'], name="body"))
    static.append(cyl(1.09, 0.06, 0.80, m=m['dark'], name="bodyRim"))
    static.append(cyl(1.07, 0.05, 0.50, m=m['hot'], name="seam"))

    # radial cooling fins
    static += ring_of(
        lambda x, y, a, z: box(0.30, 0.045, 0.46, (x * 1.08, y * 1.08, z),
                               rot=(0, 0, a), m=m['steel']),
        18, 0.95, 0.46)

    # --- drum cage: two rings + vertical bars, rotor glows between them --
    static.append(cyl(0.86, 0.07, 0.86, m=m['dark'], name="cageLo"))
    static.append(cyl(0.86, 0.08, 1.86, m=m['dark'], name="cageHi"))
    static += ring_of(
        lambda x, y, a, z: box(0.085, 0.07, 0.93, (x, y, z), rot=(0, 0, a), m=m['iron']),
        12, 0.825, 1.395)

    # --- rotor (animated) ------------------------------------------------
    spin.append(cyl(0.68, 0.95, 0.90, m=m['lava'], name="rotorCore"))
    spin += ring_of(
        lambda x, y, a, z: box(0.10, 0.055, 0.88, (x, y, z), rot=(0, 0, a), m=m['dark']),
        9, 0.68, 1.38)
    spin.append(cyl(0.72, 0.05, 0.88, verts=32, m=m['iron'], name="rotorLip"))

    # --- top cap + spindle (flat, so it doesn't swallow the drum) --------
    static.append(cone(0.88, 0.60, 0.20, 1.94, m=m['steel'], name="cap"))
    static.append(cyl(0.62, 0.045, 2.14, m=m['dark'], name="capRim"))
    static += ring_of(lambda x, y, a, z: cyl_at(x, y, z, 0.038, 0.045, m['steel'], verts=6),
                      12, 0.78, 2.00)
    static.append(cyl(0.13, 0.18, 2.185, verts=16, m=m['steel'], name="spindle"))

    # --- counterweight arms (animated): makes the spin unmistakable ------
    spin.append(cyl(0.22, 0.09, 2.32, verts=24, m=m['yellow'], name="hub"))
    for i in range(3):
        a = 2 * math.pi * i / 3
        spin.append(box(0.58, 0.075, 0.06,
                        (0.32 * math.cos(a), 0.32 * math.sin(a), 2.36),
                        rot=(0, 0, a), m=m['yellow']))
        spin.append(cyl_at(0.58 * math.cos(a), 0.58 * math.sin(a), 2.28,
                           0.10, 0.20, m['steel']))

    # --- external bracing struts: base plate up to the cage rim ----------
    for i in range(3):
        a = 2 * math.pi * i / 3 + math.pi / 6
        static.append(box(0.10, 0.09, 1.36,
                          (1.10 * math.cos(a), 1.10 * math.sin(a), 0.87),
                          rot=(0, 0, a), m=m['dark']))

    # --- fluid connections: N in, E in, S out (matches fluid_boxes) ------
    # Deliberately slimmer than a vanilla pipe: the game draws its own
    # pipe_picture and pipe_covers over the connection, and a stub sized to the
    # vanilla pipe doubles up with it. These read as the machine's own ports.
    for dx, dy, hot in ((0, 1, False), (1, 0, False), (0, -1, True)):
        ang = math.atan2(dy, dx)
        axis = (math.pi / 2, 0, ang + math.pi / 2)      # lay the cylinder flat
        # housing block against the vessel, then pipe run, then end flange
        static.append(box(0.34, 0.44, 0.40, (dx * 1.05, dy * 1.05, 0.36),
                          rot=(0, 0, ang), m=m['iron']))
        static.append(cyl_at(dx * 1.30, dy * 1.30, 0.36, 0.165, 0.70, m['steel'],
                             verts=24, rot=axis))
        static.append(cyl_at(dx * 1.46, dy * 1.46, 0.36, 0.215, 0.10, m['dark'],
                             verts=24, rot=axis))
        if hot:
            static.append(cyl_at(dx * 1.34, dy * 1.34, 0.36, 0.115, 0.52, m['hot'],
                                 verts=24, rot=axis))

    finish(static + spin)

    bpy.ops.object.empty_add(location=(0, 0, 0))
    piv = bpy.context.object
    piv.name = "PIVOT"
    for o in spin:
        o.parent = piv
        o.matrix_parent_inverse = Matrix.Identity(4)

    # TURN is the entity's facing. It sits UNDER the Y pre-stretch so the
    # machine turns in plan and only the finished result is stretched; rotating
    # above ROOT would shear the model instead of turning it.
    bpy.ops.object.empty_add(location=(0, 0, 0))
    turn = bpy.context.object
    turn.name = "TURN"
    turn.rotation_euler = (0, 0, -math.radians(DIRECTIONS[DIRECTION]))
    for o in static + [piv]:
        o.parent = turn
        o.matrix_parent_inverse = Matrix.Identity(4)

    # ROOT carries the Y pre-stretch. The rotor spins inside it, so the spin
    # stays circular in plan and only the final projection is stretched.
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.object
    root.name = "ROOT"
    root.scale = (1.0, YSCALE, 1.0)
    turn.parent = root
    turn.matrix_parent_inverse = Matrix.Identity(4)
    return piv, static + spin


# ---------------------------------------------------------------- scene
def setup_scene(objs):
    sc = bpy.context.scene

    # The icon is the same model under the same camera, just framed tight and
    # rendered large so it can be downsampled to a crisp 64 px item icon.
    res = 512 if PASS == 'icon' else RES
    tiles_across = 4.3 if PASS == 'icon' else RES / PX_PER_TILE

    cam_d = bpy.data.cameras.new("cam")
    cam_d.type = 'ORTHO'
    cam_d.ortho_scale = tiles_across
    cam = bpy.data.objects.new("cam", cam_d)
    sc.collection.objects.link(cam)
    sc.camera = cam
    rx = math.radians(90 - ELEV)
    cam.rotation_euler = (rx, 0, 0)
    cam.location = (0, -math.sin(rx) * 40, math.cos(rx) * 40)

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
    fl.energy = 1.1
    fo = bpy.data.objects.new("fill", fl)
    sc.collection.objects.link(fo)
    fo.rotation_euler = Vector((-0.6, 0.7, -0.9)).normalized() \
        .to_track_quat('-Z', 'Y').to_euler()

    w = bpy.data.worlds.new("w")
    sc.world = w
    w.use_nodes = True
    w.node_tree.nodes['Background'].inputs[0].default_value = (0.06, 0.07, 0.09, 1)
    w.node_tree.nodes['Background'].inputs[1].default_value = 0.45

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
def main():
    piv, objs = build()
    sc = setup_scene(objs)
    os.makedirs(OUTDIR, exist_ok=True)
    if PASS == 'icon':
        frames = [0]
    elif SINGLE is not None:
        frames = [int(SINGLE)]
    else:
        frames = range(START, FRAMES)
    for f in frames:
        piv.rotation_euler = (0, 0, SPIN * f / FRAMES)
        sc.render.filepath = os.path.join(OUTDIR, "%s_%03d.png" % (PASS, f))
        bpy.ops.render.render(write_still=True)
        print("FRAME", f, flush=True)


main()
