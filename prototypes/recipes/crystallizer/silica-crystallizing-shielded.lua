-- The best pass: clean melt, grown under a controlled atmosphere.
--
-- Purified lava already removed what seeds a hundred small grains. The
-- shielding gas deals with the other half of the problem, which is the air
-- above the pan: an open hearth loses composition to it all day, and the
-- crystal that comes off is the worse for it.
--
-- Seven against the purified pass's five, for a whole gas line - argon out
-- of air on the compressor, blended with oxygen on the combiner, piped to
-- the second inlet. Ten gas a pass: the gas is a blanket over the pan, not
-- something the crystal is made of.
--
-- Not 50. Fifty units were 45 argon, 1100 air, and cost far more than the
-- two extra crystals were worth - the best pass made the dearest crystal on
-- the island. At ten it is about a tenth cheaper than the purified pass.
return {
    type = "recipe",
    name = "silica-crystallizing-shielded",
    categories = { "lava-crystallizing" },
    subgroup = "raw-material",
    order = "b[silica-crystal]-c",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "fluid", name = "purified-lava",  amount = 200 },
        { type = "fluid", name = "shielding-gas",  amount = 10 },
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
