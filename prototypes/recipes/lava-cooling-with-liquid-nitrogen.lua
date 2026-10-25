local lava_cooling_with_liquid_nitrogen = {
    type = "recipe",
    name = "lava-cooling-with-liquid-nitrogen",
    categories = { "cryogenic-cooling" },
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
    -- 1500 steam @ 500 C (~145 MJ) still put out twice the heat that went in:
    -- one air cooler at 210 kW fed eight steam turbines, 48 MW, more than a
    -- nuclear reactor, and the magma reactor was worth building only for its
    -- footprint. 750 steam @ 500 C is ~73 MJ, the heat that went in: 24 MW a
    -- cooler, four turbines, 24 kJ a unit of lava as the geo-thermal turbine
    -- gets. The plates are the reward, not the power.
    results = {
        { type = "fluid", name = "steam",        amount = 750,  temperature = 500 },
        { type = "item",  name = "stone-brick",  amount = 10,   independent_probability = 0.5 },
        { type = "item",  name = "calcite",      amount = 5,    independent_probability = 0.1 },
        { type = "item",  name = "iron-plate",   amount = 20,   independent_probability = 0.2 },
        { type = "item",  name = "copper-plate", amount = 20,   independent_probability = 0.2 }
    },
    icon = "__LavaBlock-graphics__/graphics/icons/lava-cooling.png",
    icon_size = 64,
    subgroup = "lava-block-lava-smelting",
    order = "a[fluid-chemistry]-e[lava-cooling-with-liquid-nitrogen]"

}
return lava_cooling_with_liquid_nitrogen