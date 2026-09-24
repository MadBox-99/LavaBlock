"""Build chain-data.js for the production chain viewer.

The viewer reads nothing but this file, and this file is generated from a
Factorio data dump - so what it draws is what the game actually loads, not
what the recipe files were meant to say. Regenerate it after any change to a
recipe, a technology or a machine's crafting categories.

Producing a dump, in an isolated config so your own mods folder is untouched:

    factorio --dump-data --config <cfg> --mod-directory <dir>

which writes script-output/data-raw-dump.json under the config's write-data
path. Then:

    python tools/chain/build.py <path-to-data-raw-dump.json>

Icons are embedded as data URIs rather than linked, because a page opened
from file:// cannot reliably load images from disk in every browser, and
because one self-contained data file is easier to keep in step than a folder
of copies.

Neither the generated data nor the three libraries the viewer draws with are
kept in git - the same reason tools/bin is not. They are fetched on demand:
if vendor/ is empty this script downloads them once, so a fresh clone is one
command away from a working viewer rather than one download away from a
broken one. Pass --no-vendor to skip that and stay offline.

    python tools/chain/build.py DUMP [--factorio DIR] [--out FILE]
"""
import argparse
import base64
import io
import json
import os
import sys
import urllib.request

try:
    from PIL import Image
except ImportError:                                          # pragma: no cover
    sys.exit("Pillow is needed to embed the icons: pip install pillow")

HERE = os.path.dirname(os.path.abspath(__file__))
MOD = os.path.normpath(os.path.join(HERE, "..", ".."))
DEFAULT_FACTORIO = (r"C:/Program Files (x86)/Steam/steamapps/common/"
                    r"Factorio/data")

# Pinned, because an unpinned CDN URL is a viewer that renders differently
# next year for no reason anybody can find.
VENDOR = [
    ("cytoscape.min.js",
     "https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.30.2/cytoscape.min.js"),
    ("dagre.min.js",
     "https://cdnjs.cloudflare.com/ajax/libs/dagre/0.8.5/dagre.min.js"),
    ("cytoscape-dagre.min.js",
     "https://cdn.jsdelivr.net/npm/cytoscape-dagre@2.5.0/cytoscape-dagre.min.js"),
]


def fetch_vendor(quiet=False):
    """Download the viewer's libraries if they are not already beside it."""
    out = os.path.join(HERE, "vendor")
    os.makedirs(out, exist_ok=True)
    for name, url in VENDOR:
        dst = os.path.join(out, name)
        if os.path.exists(dst) and os.path.getsize(dst) > 0:
            continue
        if not quiet:
            print("fetching %s" % name)
        with urllib.request.urlopen(url, timeout=60) as r:
            body = r.read()
        with open(dst, "wb") as f:
            f.write(body)

# A recipe's category says what machine runs it, which is close enough to
# "which line is this part of" for every category the mod defines. Anything
# not listed falls back to the category name itself, so a new category shows
# up in the viewer as its own group without touching this file.
GROUPS = {
    "rock-crushing": "Rock",
    "rock-crushing-oiled": "Rock",
    "water-condensing": "Water",
    "arboretum": "Wood",
    "algae-tank": "Algae",
    "bio-garden": "Algae",
    "chemistry": "Chemistry",
    "gas": "Chemistry",
    "gas-mix": "Chemistry",
    "gas-combining": "Chemistry",
    "air-filtering": "Chemistry",
    "lava-centrifuge": "Lava",
    "lava-crystallizing": "Glass",
    "smelting": "Smelting",
    "crafting": "Build",
    "advanced-crafting": "Build",
    "crafting-with-fluid": "Build",
    "cryogenic-cooling": "Lava",
    "oil-processing": "Chemistry",
    "organic": "Wood",
    "organic-or-hand-crafting": "Wood",
    "organic-or-assembling": "Wood",
}

# A few recipes belong to a line their crafting category cannot express.
# Glass is smelted in an ordinary furnace and its panel is assembled on an
# ordinary bench, so by category they land in Smelting and Build - and with
# those lines off, the graph shows crystal being made and nothing eating it,
# which is precisely the hole this page exists to find. The line a recipe
# belongs to is about what it is for, not about which machine runs it.
RECIPE_GROUPS = {
    "glass": "Glass",
    "glazed-panel": "Glass",
}

VANILLA_NAMES = {
    "lava": "Lava", "water": "Water", "steam": "Steam", "air": "Air",
    "stone": "Stone", "stone-brick": "Stone Brick", "iron-plate": "Iron Plate",
    "copper-plate": "Copper Plate", "steel-plate": "Steel Plate",
    "iron-gear-wheel": "Iron Gear Wheel", "pipe": "Pipe",
    "electronic-circuit": "Electronic Circuit",
    "advanced-circuit": "Advanced Circuit", "lubricant": "Lubricant",
    "wood": "Wood", "tree-seed": "Tree Seed", "calcite": "Calcite",
    "liquid-nitrogen": "Liquid Nitrogen", "coal": "Coal",
    "sulfur": "Sulfur", "sulfuric-acid": "Sulfuric Acid",
    "petroleum-gas": "Petroleum Gas", "crude-oil": "Crude Oil",
    "chemical-plant": "Chemical Plant", "oil-refinery": "Oil Refinery",
    "electric-furnace": "Electric Furnace", "foundry": "Foundry",
    "assembling-machine-1": "Assembling Machine 1",
    "assembling-machine-2": "Assembling Machine 2",
    "assembling-machine-3": "Assembling Machine 3",
}


def read_locale(mod):
    """Display names, straight out of the shipped English locale."""
    out, cur = {}, None
    path = os.path.join(mod, "locale", "en", "LavaBlock.cfg")
    for line in io.open(path, encoding="utf-8"):
        line = line.strip()
        if line.startswith("[") and line.endswith("]"):
            cur = line[1:-1]
        elif cur and "=" in line and not line.startswith("#"):
            k, v = line.split("=", 1)
            out.setdefault(cur, {})[k.strip()] = v.strip()
    return out


class Builder(object):
    def __init__(self, dump, factorio, mod):
        self.m = json.load(io.open(dump, encoding="utf-8"))
        self.factorio = factorio.rstrip("/") + "/"
        self.mod = mod.replace("\\", "/").rstrip("/") + "/"
        # The sprite sheets and icons were split out into LavaBlock-graphics,
        # which sits next to this mod in the mods folder. Derived rather than
        # passed in, because there is exactly one place it can be: Factorio
        # resolves `__LavaBlock-graphics__` the same way.
        self.graphics = self.mod.rstrip("/") + "-graphics/"
        self.loc = read_locale(mod)
        self.icons = {}

        # Every item in Factorio is an item, but not every item is an "item".
        # Science packs are tools, jelly and bioflux are capsules, modules,
        # ammunition, guns and armour are each their own prototype type -
        # eighteen types in the current dump. Looking only in data.raw.item
        # left eighteen nodes with no icon, and a node with no icon took the
        # whole graph down with it.
        #
        # What they have in common is a stack size: that is what makes a
        # prototype an item. Indexing on it rather than on a list of type
        # names means the next type the game adds is already handled.
        self.things = {}
        for kind, protos in self.m.items():
            if not isinstance(protos, dict):
                continue
            for name, proto in protos.items():
                if isinstance(proto, dict) and "stack_size" in proto:
                    self.things.setdefault(name, proto)
        for name, proto in self.m.get("fluid", {}).items():
            self.things.setdefault(name, proto)

        self.cat_machines = {}
        for kind in ("assembling-machine", "furnace"):
            for name, e in self.m.get(kind, {}).items():
                for c in e.get("crafting_categories") or []:
                    self.cat_machines.setdefault(c, []).append(name)

        self.unlock = {}
        for tn, t in self.m["technology"].items():
            for e in t.get("effects") or []:
                if e.get("type") == "unlock-recipe":
                    self.unlock[e["recipe"]] = tn

    # ---------------------------------------------------------------- names
    def nice(self, name, *sections):
        for sec in sections:
            if name in self.loc.get(sec, {}):
                return self.loc[sec][name]
        if name in VANILLA_NAMES:
            return VANILLA_NAMES[name]
        return name.replace("-", " ").title()

    def thing_name(self, name):
        return self.nice(name, "item-name", "fluid-name", "entity-name")

    def recipe_name(self, name):
        return self.nice(name, "recipe-name", "item-name", "entity-name")

    # ---------------------------------------------------------------- icons
    def _resolve(self, path):
        for tag, root in (("__base__/", self.factorio + "base/"),
                          ("__core__/", self.factorio + "core/"),
                          ("__space-age__/", self.factorio + "space-age/"),
                          ("__quality__/", self.factorio + "quality/"),
                          ("__elevated-rails__/",
                           self.factorio + "elevated-rails/"),
                          # The pictures live in a mod of their own, so that
                          # a release touching only recipes or text does not
                          # make everyone download them again. Both tags are
                          # kept: icons moved, but a path in an older dump
                          # still says __LavaBlock__.
                          ("__LavaBlock-graphics__/", self.graphics),
                          ("__LavaBlock__/", self.mod)):
            path = path.replace(tag, root)
        return path

    def icon(self, name):
        """Embed a 48 px copy of an item or fluid icon, tint applied."""
        if name in self.icons:
            return
        p = self.things.get(name) or {}
        src = p.get("icon") or (p.get("icons") or [{}])[0].get("icon")
        if not src:
            self.icons[name] = None
            return
        src = self._resolve(src)
        if not os.path.exists(src):
            self.icons[name] = None
            return
        im = Image.open(src).convert("RGBA")
        if im.width > im.height:      # a mipmap strip: the lead square is full res
            im = im.crop((0, 0, im.height, im.height))
        layers = p.get("icons") or []
        if layers and layers[0].get("tint"):
            t = layers[0]["tint"]
            r, g, b, a = im.split()
            im = Image.merge("RGBA", (
                r.point(lambda v: int(v * t.get("r", 1))),
                g.point(lambda v: int(v * t.get("g", 1))),
                b.point(lambda v: int(v * t.get("b", 1))), a))
        im = im.resize((48, 48), Image.LANCZOS)
        buf = io.BytesIO()
        im.save(buf, "PNG", optimize=True)
        self.icons[name] = ("data:image/png;base64,"
                            + base64.b64encode(buf.getvalue()).decode())

    # -------------------------------------------------------------- recipes
    def side(self, lst):
        out = []
        for x in lst or []:
            self.icon(x["name"])
            amount = x.get("amount")
            if amount is None:
                amount = x.get("amount_min")
            out.append({"n": x["name"], "l": self.thing_name(x["name"]),
                        "a": amount, "f": x.get("type") == "fluid",
                        "p": x.get("probability")})
        return out

    def recipe(self, name, r):
        cat = r.get("category", "crafting")
        machines = sorted(self.cat_machines.get(cat, []))
        for mn in machines:
            self.icon(mn)
        return {"n": name, "l": self.recipe_name(name), "cat": cat,
                "group": RECIPE_GROUPS.get(name, GROUPS.get(cat, cat)),
                "t": r.get("energy_required", 0.5),
                "in": self.side(r.get("ingredients")),
                "out": self.side(r.get("results")),
                "prod": bool(r.get("allow_productivity")),
                "machines": [{"n": mn, "l": self.thing_name(mn)}
                             for mn in machines],
                "tech": self.unlock.get(name)}

    def run(self, vanilla_recipes):
        recipes = []
        for name, r in sorted(self.m["recipe"].items()):
            if name in vanilla_recipes:
                continue
            if r.get("hidden") or name.endswith("-recycling"):
                continue
            recipes.append(self.recipe(name, r))

        techs = {}
        for name in sorted(set(self.unlock.values())):
            t = self.m["technology"].get(name)
            if not t:
                continue
            unit = t.get("unit") or {}
            techs[name] = {
                "l": self.nice(name, "technology-name"),
                "pre": t.get("prerequisites") or [],
                "count": unit.get("count"),
                "packs": [i[0].replace("-science-pack", "")
                          for i in unit.get("ingredients", [])]}

        return {"recipes": recipes, "techs": techs,
                "icons": {k: v for k, v in self.icons.items() if v}}


def inline_script(body):
    """Wrap JavaScript so it survives being pasted into an HTML document.

    A closing script tag inside the source would end the block early. None of
    these files contains one today, but a version bump is not the moment to
    find that out, so anything that does is handed over as a data URI rather
    than inlined as text.
    """
    if "</script" in body.lower():
        return ('<script src="data:text/javascript;base64,%s"></script>'
                % base64.b64encode(body.encode("utf-8")).decode())
    return "<script>\n" + body + "\n</script>"


def single(dst):
    """One HTML file with the libraries and the data inside it.

    GitHub serves a repository's HTML as source, not as a page, so sharing
    the viewer means GitHub Pages or handing someone a file - and both are
    easier with one file than with a folder whose two largest pieces,
    vendor/ and chain-data.js, are deliberately not in git.
    """
    html = io.open(os.path.join(HERE, "index.html"), encoding="utf-8").read()
    pieces = (("vendor/cytoscape.min.js", ("vendor", "cytoscape.min.js")),
              ("vendor/dagre.min.js", ("vendor", "dagre.min.js")),
              ("vendor/cytoscape-dagre.min.js",
               ("vendor", "cytoscape-dagre.min.js")),
              ("chain-data.js", ("chain-data.js",)))
    for src, parts in pieces:
        tag = '<script src="%s"></script>' % src
        if tag not in html:
            raise SystemExit("index.html no longer loads %s the expected way"
                             % src)
        path = os.path.join(HERE, *parts)
        html = html.replace(tag, inline_script(
            io.open(path, encoding="utf-8").read()), 1)
    io.open(dst, "w", encoding="utf-8", newline="\n").write(html)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("dump", help="path to data-raw-dump.json (with the mod on)")
    ap.add_argument("--vanilla", help="a dump taken WITHOUT the mod; recipes "
                                      "present in it are left out of the graph")
    ap.add_argument("--factorio", default=DEFAULT_FACTORIO,
                    help="Factorio data directory, for the base game's icons")
    ap.add_argument("--out", default=os.path.join(HERE, "chain-data.js"))
    ap.add_argument("--no-vendor", action="store_true",
                    help="do not download the viewer's libraries if missing")
    ap.add_argument("--single", metavar="FILE", nargs="?",
                    const=os.path.join(HERE, "chain.html"),
                    help="also write one self-contained HTML file, libraries "
                         "and data inlined - what to publish, or to hand to "
                         "someone, when a folder will not do")
    a = ap.parse_args()

    if not a.no_vendor:
        try:
            fetch_vendor()
        except Exception as e:                  # offline is not a build failure
            print("could not fetch the viewer libraries (%s) - the graph will "
                  "not draw until vendor/ is filled" % e)

    vanilla = set()
    if a.vanilla:
        vr = json.load(io.open(a.vanilla, encoding="utf-8")).get("recipe", {})
        vanilla = set(vr)

    b = Builder(a.dump, a.factorio, MOD)
    data = b.run(vanilla)
    body = json.dumps(data, separators=(",", ":"), sort_keys=True)
    io.open(a.out, "w", encoding="utf-8", newline="\n").write(
        "// Generated by tools/chain/build.py - do not edit by hand.\n"
        "window.CHAIN = " + body + ";\n")
    groups = sorted(set(r["group"] for r in data["recipes"]))
    print("%s\n  %d recipes, %d icons, %d KB\n  groups: %s"
          % (a.out, len(data["recipes"]), len(data["icons"]),
             round(os.path.getsize(a.out) / 1024), ", ".join(groups)))

    if a.single:
        single(a.single)
        print("%s\n  %d KB, self-contained"
              % (a.single, round(os.path.getsize(a.single) / 1024)))


if __name__ == "__main__":
    main()
