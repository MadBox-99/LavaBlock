-- Geothermal brine: hot water that has run through volcanic rock and come
-- out carrying its salt. Iceland's and the Salton Sea's power plants bring
-- it up by the million tonnes. The island has no sea to boil for salt, so
-- this is where its sodium and chloride come from, and the chlor-alkali
-- cell is what it is for.
return {
    type = "fluid",
    name = "brine",
    subgroup = "fluid",
    default_temperature = 15,
    heat_capacity = "0.2kJ",
    -- Grey teal, cloudier and darker than liquid nitrogen's clear blue.
    base_color = { r = 0.37, g = 0.55, b = 0.59 },
    flow_color = { r = 0.60, g = 0.75, b = 0.78 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/brine.png",
    icon_size = 64,
    order = "a[fluid]-z[brine]",
    auto_barrel = true,
}
