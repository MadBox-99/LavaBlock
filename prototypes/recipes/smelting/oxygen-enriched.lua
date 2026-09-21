-- Oxygen-enriched smelting: what the bio garden's oxygen is actually for.
--
-- The plain recipes pour 5000 lava through a machine for 50 molten metal, and
-- lava is not scarce - it is a throughput problem. Five thousand a craft is
-- what forces a wall of pumps and a bundle of pipes behind every smelter.
--
-- Lancing the melt with oxygen is the real metallurgical answer to that, and
-- here it halves the lava for the same output. The trade is a gas line and a
-- row of gardens against half the plumbing, which is a choice rather than a
-- straight upgrade.
local function enriched(metal, ore, molten, icon)
    return {
        type = "recipe",
        name = metal .. "-smelting-oxygen",
        energy_required = 3,
        enabled = false,
        ingredients = {
            { type = "fluid", name = "lava",   amount = 2500 },
            { type = "item",  name = ore,      amount = 5 },
            { type = "fluid", name = "oxygen", amount = 100 },
        },
        surface_conditions = {
            { property = "pressure", min = 1000, max = 1000 },
            { property = "gravity",  min = 10,   max = 10 },
        },
        results = {
            { type = "fluid", name = molten, amount = 50 }
        },
        main_product = molten,
        icons = {
            { icon = icon, icon_size = 64 },
            {
                icon = "__LavaBlock__/graphics/icons/gas/oxygen.png",
                icon_size = 64,
                scale = 0.25,
                shift = { 8, -8 },
            },
        },
        category = "oil-processing",
        subgroup = "fluid-recipes",
        allow_productivity = true,
        allow_quality = false,
    }
end

return {
    enriched("iron", "iron-ore", "molten-iron",
             "__LavaBlock__/graphics/icons/iron-lava-smelt.png"),
    enriched("copper", "copper-ore", "molten-copper",
             "__LavaBlock__/graphics/icons/copper-lava-smelt.png"),
}
