-- Rocket fuel from ethanol and oxygen, which is what the first big liquid
-- rockets actually flew on: the V-2 and the Redstone burned alcohol against
-- liquid oxygen.
--
-- 200 ethanol is 100 MJ at the fluid's own fuel value, and one rocket fuel
-- is 100 MJ, so the recipe loses nothing and gains nothing; the oxygen is
-- what makes it rocket fuel rather than a tank of spirit. Against the
-- vanilla recipe (ten solid fuel, 120 MJ, plus light oil) it is the cheaper
-- one in energy, and it needs no refinery at all.
--
-- It runs in the Fuel Plant and not in a chemical plant: charging a rocket
-- with liquid oxygen is a job for a cryogenic tank and a filling line, not
-- for the plant that also makes plastic.
return {
    type = "recipe",
    name = "ethanol-rocket-fuel",
    categories = { "fuel-synthesizing" },
    subgroup = "intermediate-product",
    order = "d[rocket-parts]-b[rocket-fuel]-b[ethanol]",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "fluid", name = "ethanol", amount = 200 },
        { type = "fluid", name = "oxygen",  amount = 100 },
    },
    results = {
        { type = "item", name = "rocket-fuel", amount = 1 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__base__/graphics/icons/rocket-fuel.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/ethanol.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.78, g = 0.66, b = 0.30, a = 1.0 },
        secondary = { r = 0.30, g = 0.64, b = 1.00, a = 1.0 },
    },
}
