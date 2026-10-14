-- Uranium ore dissolved and fluorinated to the hexafluoride. The real
-- route goes through yellowcake, uranium tetrafluoride and elemental
-- fluorine; this is all of it in one chemical plant, with the acid as the
-- only fluorine source the island has.
--
-- Ten ore and 40 hydrofluoric acid for 50 uranium hexafluoride, five
-- seconds. Ten ore is what one vanilla centrifuge run takes, and 50 gas is
-- what one run of the gas centrifuge takes, so a run is a run either way.
return {
    type = "recipe",
    name = "uranium-fluorination",
    category = "chemistry",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item",  name = "uranium-ore",       amount = 10 },
        { type = "fluid", name = "hydrofluoric-acid", amount = 40 },
    },
    results = {
        { type = "fluid", name = "uranium-hexafluoride", amount = 50 },
    },
    -- Productivity here would be uranium out of nothing on a fluid that
    -- carries the ore's count; the centrifuge gets it instead.
    allow_productivity = false,
    allow_quality = false,
    subgroup = "uranium-processing",
    order = "a[uranium-processing]-a[uranium-fluorination]",
    crafting_machine_tint = {
        primary = { r = 0.16, g = 0.90, b = 0.47, a = 1.0 },
        secondary = { r = 0.59, g = 0.92, b = 0.78, a = 1.0 },
    },
}
