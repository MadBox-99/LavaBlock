local lava_cooling_with_liquid_nitrogen = {
    type = "recipe",
    name = "lava-cooling-with-liquid-nitrogen",
    category = "cryogenic-cooling",
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "lava",            amount = 3000 },
        { type = "fluid", name = "liquid-nitrogen", amount = 10 }
    },
    -- 3020 fluid in at 25 kJ/unit (see data-updates.lua) = 75.5 MJ of input heat.
    -- The old 2000 steam @ 1000 C was 394 MJ raw / 194 MJ through a steam turbine
    -- (which caps at 500 C and threw the rest away anyway) -- a 2.6x energy
    -- multiplier out of nothing, which also made geo-thermal-turbine pointless.
    -- 1500 steam @ 500 C is ~145 MJ: still a strong reward, no longer free energy.
    results = {
        { type = "fluid", name = "steam",        amount = 1500, temperature = 500 },
        { type = "item",  name = "stone-brick",  amount = 10,   probability = 0.5 },
        { type = "item",  name = "calcite",      amount = 5,    probability = 0.1 },
        { type = "item",  name = "iron-plate",   amount = 20,   probability = 0.2 },
        { type = "item",  name = "copper-plate", amount = 20,   probability = 0.2 }
    },
    icon = "__LavaBlock-graphics__/graphics/icons/lava-cooling.png",
    icon_size = 64,
    subgroup = "fluid-recipes",
    order = "a[fluid-chemistry]-e[lava-cooling-with-liquid-nitrogen]"

}
return lava_cooling_with_liquid_nitrogen