-- The plain pass: raw lava, straight off the island, cooled slowly enough
-- that it grows crystal instead of freezing to basalt.
--
-- Raw lava rather than purified, and that is a deliberate correction to the
-- first sketch of this chain. Purified lava comes out of the centrifuge,
-- which is a 500-count research behind two lava science packs; glass out of
-- this machine goes into the arboretum, which is a 100-count research on
-- red and green. Feeding the early building from the late fluid would have
-- put a whole end-game branch in front of the first glasshouse.
--
-- Purified lava still has its recipe - see silica-crystallizing-purified -
-- as the better one, the same way the smelters take oxygen and the crusher
-- takes lubricant. A second recipe on the same machine is this mod's usual
-- shape for "you can do this better later".
return {
    type = "recipe",
    name = "silica-crystallizing",
    category = "lava-crystallizing",
    subgroup = "raw-material",
    order = "b[silica-crystal]-a",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "fluid", name = "lava", amount = 600 },
    },
    results = {
        { type = "item", name = "silica-crystal", amount = 2 }
    },
    crafting_machine_tint = {
        primary = { r = 0.62, g = 0.30, b = 0.95, a = 1.0 },
        secondary = { r = 1.00, g = 0.42, b = 0.08, a = 1.0 },
    },
    allow_productivity = true,
}
