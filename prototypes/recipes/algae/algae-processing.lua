-- Extracting what each strain concentrated while it grew.
--
-- All three run in the bio garden itself, not in a chemical plant. The garden
-- grows the mass and presses it in the same building, the way the arboretum
-- turns its own logs back into seed: one machine closes the loop, and you are
-- not belting harvest across the base to a generic chemical plant that has no
-- other reason to be in the biology chain.
--
-- It does mean the garden is a busy building - six recipes - and that the
-- processing runs at the garden's crafting speed of 1.0 rather than a
-- chemical plant's 2.0, so a harvest line needs roughly twice the buildings
-- it would have. That is the trade for keeping the chain in one machine.
--
-- The costs below are quoted in lava, since that is the island's only real
-- input. The conversions used: 500 steam -> 250 water in the condenser, and
-- 100 lava -> 70 steam in lava cooling, so one water is about 2.86 lava and
-- one steam about 1.43. One cultivation craft is 100 water plus its medium.
local ICON = "__LavaBlock__/graphics/icons/items/algae-%s.png"

-- Green: 5 algae cost 100 water + 100 lava = 386 lava, so wood lands at about
-- 97 lava each. The arboretum is 200 water for 8 wood but has to spend 2 of
-- them on the next seed, which works out at about 95 lava a log - the two
-- routes are a genuine choice, not an upgrade. The garden is 3x3 and needs no
-- seed stock; the arboretum is 5x5 and closes its own loop.
local fibre_pressing = {
    type = "recipe",
    name = "algae-fibre-pressing",
    category = "bio-garden",
    subgroup = "raw-material",
    order = "a[wood]-c[algae-fibre-pressing]",
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "item", name = "algae-green", amount = 5 },
    },
    results = {
        { type = "item", name = "wood", amount = 4 },
    },
    allow_productivity = true,
    icons = {
        { icon = "__base__/graphics/icons/wood.png", icon_size = 64 },
        {
            icon = string.format(ICON, "green"),
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.28, g = 0.86, b = 0.34, a = 1.0 },
        secondary = { r = 0.62, g = 0.52, b = 0.28, a = 1.0 },
    },
}

-- Blue: 5 algae cost 100 water + 400 air = 400 lava, and the craft adds 50
-- water, so 100 liquid nitrogen costs about 543 lava - against 386 lava for
-- 50 by the lava route. Around 1.4x cheaper, which unsticks cryogenic cooling
-- without making it free.
local nitrogen_fixation = {
    type = "recipe",
    name = "nitrogen-fixation",
    category = "bio-garden",
    subgroup = "fluid-recipes",
    order = "a[fluid-chemistry]-d[nitrogen-fixation]",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "algae-blue", amount = 5 },
        { type = "fluid", name = "water",      amount = 50 },
    },
    results = {
        { type = "fluid", name = "liquid-nitrogen", amount = 100 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock__/graphics/icons/fluid/liquid_nitrogen.png",
            icon_size = 32,
        },
        {
            icon = string.format(ICON, "blue"),
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.26, g = 0.56, b = 1.00, a = 1.0 },
        secondary = { r = 0.70, g = 0.86, b = 1.00, a = 1.0 },
    },
}

-- Red: 5 algae cost 100 water + 200 steam = 572 lava for 3 calcite, about 191
-- lava each. Calcite synthesis is 5000 lava plus coal and brick for 10, so
-- 500 lava each before the solids - roughly two and a half times dearer. The
-- old recipe stays for anyone who has lava to burn and no gardens built.
local calcite_precipitation = {
    type = "recipe",
    name = "calcite-precipitation",
    category = "bio-garden",
    subgroup = "raw-material",
    order = "a[algae]-d[calcite-precipitation]",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "algae-red", amount = 5 },
    },
    results = {
        { type = "item", name = "calcite", amount = 3 },
    },
    allow_productivity = true,
    icons = {
        { icon = "__space-age__/graphics/icons/calcite.png", icon_size = 64 },
        {
            icon = string.format(ICON, "red"),
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 1.00, g = 0.26, b = 0.32, a = 1.0 },
        secondary = { r = 0.92, g = 0.88, b = 0.80, a = 1.0 },
    },
}

return { fibre_pressing, nitrogen_fixation, calcite_precipitation }
