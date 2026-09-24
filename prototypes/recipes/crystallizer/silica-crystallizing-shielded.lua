-- The best pass: clean melt, grown under a controlled atmosphere.
--
-- Purified lava already removed what seeds a hundred small grains. The
-- shielding gas deals with the other half of the problem, which is the air
-- above the pan: an open hearth loses composition to it all day, and the
-- crystal that comes off is the worse for it.
--
-- Seven against the purified pass's five, for a whole gas line - argon out
-- of air on the compressor, blended with oxygen on the combiner, piped to
-- the second inlet. Forty per cent more crystal is a fair price for that
-- and not a replacement for the recipe below it: a base running well on
-- purified lava has no obligation to build any of this.
return {
    type = "recipe",
    name = "silica-crystallizing-shielded",
    category = "lava-crystallizing",
    subgroup = "raw-material",
    order = "b[silica-crystal]-c",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "fluid", name = "purified-lava",  amount = 200 },
        { type = "fluid", name = "shielding-gas",  amount = 50 },
    },
    results = {
        { type = "item", name = "silica-crystal", amount = 7 }
    },
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/silica-crystal.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/shielding-gas.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.62, g = 0.30, b = 0.95, a = 1.0 },
        secondary = { r = 1.00, g = 0.60, b = 0.00, a = 1.0 },
    },
    allow_productivity = true,
}
