# ---------------------------------------------------------------------------
# LavaBlock - remove the 34 orphaned Pyroclast files left over from the 0.1.1
# split, plus the stray empty migration.
#
# Verified before writing this script:
#   * none of these files is reachable from data.lua / data-updates.lua /
#     data-final-fixes.lua / control.lua / settings.lua via require()
#   * the standalone Pyroclast 0.1.17 mod contains no require("__LavaBlock__...")
#     and does not depend on LavaBlock; it ships its own, newer copies of all
#     of them
#   * deleting them orphans no graphics file that actually exists
#
# Run from the LavaBlock folder:
#     .\cleanup-pyroclast.ps1
# ---------------------------------------------------------------------------

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Test-Path '.git')) { throw "Not a git repository: $PSScriptRoot" }
if (-not (Test-Path 'info.json')) { throw "info.json not found - wrong folder?" }

$before = (git ls-files | Measure-Object).Count
Write-Host "Tracked files before: $before"

$paths = @(
    # 12 recipes
    'prototypes/recipes/pyroclast',
    # 1 planet
    'prototypes/planet',
    # 1 tile
    'prototypes/tiles',
    # 2 crafting machine tints (unreferenced, and one has a typo'd prototype name)
    'prototypes/recipes/crafting-machine-tints',
    # 2 entities
    'prototypes/entity/pyroclast-geysers.lua',
    'prototypes/entity/pyroclast-rocket-silo.lua',
    # 4 items
    'prototypes/items/pyroclast-assembly-materials.lua',
    'prototypes/items/pyroclast-items.lua',
    'prototypes/items/pyroclast-materials.lua',
    'prototypes/items/pyroclast-rocket-silo.lua',
    # 1 noise expression
    'prototypes/noise-expressions/pyroclast-generator.lua',
    # 1 science pack tool
    'prototypes/tools/pyroclast-science-pack.lua',
    # 9 technologies
    'prototypes/technologies/planet-discovery-pyroclast.lua',
    'prototypes/technologies/pyroclast-assembly-1.lua',
    'prototypes/technologies/pyroclast-assembly-2.lua',
    'prototypes/technologies/pyroclast-assembly-3.lua',
    'prototypes/technologies/pyroclast-assembly-4.lua',
    'prototypes/technologies/pyroclast-explosives.lua',
    'prototypes/technologies/pyroclast-heavy-explosives.lua',
    'prototypes/technologies/pyroclast-materials.lua',
    'prototypes/technologies/pyroclast-refined.lua',
    'prototypes/technologies/pyroclast-science-pack.lua',
    # stray empty migration (the real one is LavaBlock_0.1.7.json)
    'migrations/LavaBlock_0.1.8.json'
)

foreach ($p in $paths) {
    if (Test-Path $p) {
        git rm -r --quiet -- $p
        Write-Host "  removed  $p"
    } else {
        Write-Host "  skipped  $p  (already gone)"
    }
}

$after = (git ls-files | Measure-Object).Count
Write-Host ""
Write-Host "Tracked files after: $after   (removed: $($before - $after))"
Write-Host "Expected removal count: 35 (34 orphaned Lua files + 1 stray migration)"
Write-Host ""
Write-Host "Nothing is committed yet. Review with 'git status', then:"
Write-Host "    git commit -m `"Remove Pyroclast leftovers extracted into the standalone mod in 0.1.1`""
