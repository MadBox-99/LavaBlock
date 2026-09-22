# The production chain viewer

`tools/chain/index.html` draws the mod's recipes as a graph: items and
recipes as nodes, ingredients and products as arrows, laid out left to right.
Open the file in a browser. There is no server and no build step for the page
itself.

It exists to answer the questions the Lua files cannot: whether a new item
has anything that makes it, whether anything downstream eats it, and which
technology actually hands a recipe over. Reading that out of thirty recipe
files is how a chain ends up with a hole in it.

## Regenerating the data

The page reads `chain-data.js` and nothing else, and that file is generated
from a Factorio data dump — so it shows what the game loads, not what the
recipe files were meant to say. **Regenerate after any change to a recipe, a
technology, or a machine's crafting categories**, or the graph quietly goes
stale.

```sh
# 1. dump the data stage with the mod loaded (see the dump script you use for
#    the vanilla-overwrite check - the same dump serves both)
# 2. rebuild the page's data
python tools/chain/build.py <dump>/script-output/data-raw-dump.json \
       --vanilla <vanilla-dump>/script-output/data-raw-dump.json
```

`--vanilla` takes a dump made *without* LavaBlock. Recipes present in it are
left out, so the graph is the mod's own chain rather than the whole game. Drop
the flag to see everything.

## What is in git and what is not

Neither `chain-data.js` nor `tools/chain/vendor/` is committed, for the same
reason `tools/bin` is not: they are rebuilt on demand and would only churn
the history — and `fmtk publish` would otherwise ship 1.3 MB of developer
tooling to everyone who downloads the mod.

`build.py` downloads the three libraries into `vendor/` the first time it
runs, so a fresh clone is one command away from a working viewer. The
versions are pinned in the script; `--no-vendor` skips the download.

## Sharing it

GitHub serves a repository's HTML as **source**, not as a page, so a link to
`index.html` on github.com shows the markup. There are two ways to give
someone something they can actually click:

**One file.** `--single` writes `chain.html` with the libraries and the data
inlined — about 1.3 MB, no folder, no server, opens anywhere:

```sh
python tools/chain/build.py <dump>/script-output/data-raw-dump.json \
       --vanilla <vanilla-dump>/script-output/data-raw-dump.json --single
```

**A link.** `tools/chain/publish.sh` pushes that one file to an orphan
`gh-pages` branch as `index.html`, through a temporary worktree, so `main` is
never touched and the branch carries the page and nothing else:

```sh
bash tools/chain/publish.sh
```

The first time, switch Pages on: **Settings → Pages → Deploy from a branch →
`gh-pages`, folder `/ (root)`**. The URL is then
`https://<user>.github.io/<repo>/`, which the script prints. Pages is free on
a public repository; a private one needs a paid plan.

Re-run both after regenerating the data, or the published page keeps showing
the old chain.

## Reading it

- **Round icons are items, boxes are recipes.** A dashed blue arrow is a
  fluid.
- **Click anything** to light the whole chain running through it, upstream
  and downstream, and open a panel with the details. The panel says in words
  when nothing makes an item, or nothing eats it — which is what a hole in
  the chain looks like.
- **The group buttons** filter by production line. Only the four lines the
  new machines run are on by default; `Build` roughly doubles the graph,
  because every machine and part recipe joins in.
- A recipe whose research reads **"never unlocked"** is disabled with no
  technology handing it over: it can never be crafted.
