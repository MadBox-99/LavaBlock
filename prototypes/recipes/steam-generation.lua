-- Lava for the heat, coal and a stick of wood to get it burning: steam
-- without water, which is what makes it the island's first real power.
--
-- 3 MW a chemical plant - 1000 steam at 165 every ten seconds, three steam
-- engines and a bit. It was 150 MW, from 5000 lava, a wood and five coal a
-- second: one plant ran 166 engines, and it made every other power source in
-- the mod pointless from the first minute.
--
-- It stays ahead of the vanilla boiler on purpose. A boiler makes 1.8 MW
-- from 0.45 coal and 60 water a second; this makes 3 MW from 0.2 coal and
-- 0.1 wood, and no water, which early on is the scarce thing. The lava
-- supplies the rest - 30 MJ of steam for 10 MJ of fuel.
--
-- The ladder above it: geothermal turbines at 6 MW burning lava alone, then
-- cryogenic lava cooling at nearly 50 MW an air cooler.
local steam_generation = {
    type = "recipe",
    name = "steam-generation",
    energy_required = 10,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 2000 },
        { type = "item",  name = "wood", amount = 1 },
        { type = "item",  name = "coal", amount = 2 }

    },
    results = {
        { type = "fluid", name = "steam", amount = 1000, temperature = 165 }
    },
    icon = "__base__/graphics/icons/fluid/steam.png",
    icon_size = 64,
    categories = { "chemistry" },
    subgroup = "fluid-recipes",
}
return steam_generation
