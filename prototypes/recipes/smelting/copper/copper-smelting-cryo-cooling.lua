-- Quenching the melt in liquid nitrogen instead of water. It gave 80 plates
-- for 200 melt, twice what water cooling gets out of the same melt, which on
-- top of the smelting route's own doubling turned one ore into four plates.
-- 50 is 2.5 plates an ore against water's 2: a little more, and far faster
-- on one machine, which is what the liquid nitrogen is paid for.
local copper_smelting_cryo_cooling = {
    type = "recipe",
    name = "copper-smelting-cryo-cooling",
    categories = { "cryogenic-cooling" },
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "molten-copper",   amount = 200 },
        { type = "fluid", name = "liquid-nitrogen", amount = 200 }
    },
    results = {
        { type = "item", name = "copper-plate", amount = 50 }
    },
    icon = "__base__/graphics/icons/copper-plate.png",
    icon_size = 64,
    subgroup = "raw-material",
    order = "c[copper-plate]-c[cryo]"
}

return copper_smelting_cryo_cooling