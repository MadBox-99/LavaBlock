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


def assemble(static, spin, pivot=(0, 0, 0)):
    """Wire a model's objects into the hierarchy the renderer expects.

    PIVOT  - the moving parts; run() turns this once per frame. It sits at
             `pivot`, which must be the moving assembly's own axis: a part
             modelled away from the origin would otherwise orbit the entity
             centre instead of spinning in place.
    TURN   - the entity's facing. It sits UNDER the Y pre-stretch, so the
             machine turns in plan; rotating above ROOT would shear it.
    ROOT   - the Y pre-stretch that squares up the footprint.
    """
    finish(static + spin)

    bpy.ops.object.empty_add(location=pivot)
    piv = bpy.context.object
    piv.name = "PIVOT"
    # Cancel the pivot's own translation, so the children keep the world
    # positions build() gave them and only the rotation centre moves.
    inv = Matrix.Translation(-Vector(pivot))
    for o in spin:
        o.parent = piv
        o.matrix_parent_inverse = inv

    bpy.ops.object.empty_add(location=(0, 0, 0))
    turn = bpy.context.object
    turn.name = "TURN"
    turn.rotation_euler = (0, 0, -math.radians(DIRECTIONS[DIRECTION]))
    for o in static + [piv]:
        o.parent = turn
        o.matrix_parent_inverse = Matrix.Identity(4)

    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.object
    root.name = "ROOT"
    root.scale = (1.0, YSCALE, 1.0)
    turn.parent = root
    turn.matrix_parent_inverse = Matrix.Identity(4)
    return piv, static + spin


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
def run(build, spin_degrees=120, pivot=(0, 0, 0)):
    """Entry point for a model script.

    `build` returns (static_objects, moving_objects). The moving ones are
    turned by `spin_degrees` about `pivot` over the whole frame range; choose
    an angle they are symmetric under so the loop closes seamlessly - 120 for
    three arms. `pivot` defaults to the origin, which is right only when the
    moving assembly is modelled there.
    """
    spin = math.radians(spin_degrees)
    piv, objs = assemble(*build(), pivot=pivot)
    sc = setup_scene(objs)
    os.makedirs(OUTDIR, exist_ok=True)
    if PASS == 'icon':
        frames = [0]
    elif SINGLE is not None:
        frames = [int(SINGLE)]
    else:
        frames = range(START, FRAMES)
    for f in frames:
        piv.rotation_euler = (0, 0, spin * f / FRAMES)
        sc.render.filepath = os.path.join(OUTDIR, "%s_%03d.png" % (PASS, f))
        bpy.ops.render.render(write_still=True)
        print("FRAME", f, flush=True)


