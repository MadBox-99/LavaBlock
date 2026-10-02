-- A wafer printed into chips. The tin is fired into the laser's path and
-- spent as plasma, the copper is the wiring laid down between the layers,
-- and the laser source goes in and, nearly always, comes back out.
--
-- 98% back: one craft in fifty burns it up, so a source lasts about fifty
-- crafts and two hundred chips. Productivity is not allowed to hand back
-- more sources than went in - ignored_by_productivity covers the one that
-- returns - so the chips are the only thing it multiplies.
return {
    type = "recipe",
    name = "microchip",
    category = "chip-lithography",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item", name = "silicon-wafer", amount = 1 },
        { type = "item", name = "tin-plate",     amount = 1 },
        { type = "item", name = "copper-plate",  amount = 2 },
        { type = "item", name = "laser-source",  amount = 1 },
    },
    results = {
        { type = "item", name = "microchip",    amount = 4 },
        {
            type = "item",
            name = "laser-source",
            amount = 1,
            probability = 0.98,
            ignored_by_productivity = 1,
        },
    },
    main_product = "microchip",
    allow_productivity = true,
}
