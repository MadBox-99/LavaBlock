-- Lithium hexafluorophosphate dissolved in carbonate solvent: the
-- electrolyte every lithium-ion cell is filled with. Lithium for the salt,
-- phosphorus and fluorine for its anion. It is made cold because the salt
-- falls apart if it is not, which is what Aquilo's cryogenic plant is for.
return {
    type = "fluid",
    name = "lithium-electrolyte",
    subgroup = "fluid",
    default_temperature = 15,
    heat_capacity = "0.2kJ",
    -- Clear in a bottle; drawn pale lilac so the pipes have a colour.
    base_color = { r = 0.66, g = 0.60, b = 0.86 },
    flow_color = { r = 0.82, g = 0.78, b = 0.96 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/lithium-electrolyte.png",
    icon_size = 64,
    order = "a[fluid]-z[lithium-electrolyte]",
    auto_barrel = true,
}
