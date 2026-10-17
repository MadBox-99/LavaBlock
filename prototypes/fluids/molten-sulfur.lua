-- What the Claus process runs out at the bottom: sulfur, liquid at 140
-- degrees. Real sulfur plants keep it liquid all the way to the customer,
-- in heated pipes and tank cars, and only prill it into solid pellets at
-- the end. Here it goes to a prilling tower for sulfur, or straight into
-- sulfur concrete, which needs it hot.
return {
    type = "fluid",
    name = "molten-sulfur",
    subgroup = "fluid",
    default_temperature = 140,
    heat_capacity = "1kJ",
    -- Gold. Sulfur melts amber and darkens towards red as it heats; this is
    -- the colour at the temperature the Claus process lets it out.
    base_color = { r = 0.94, g = 0.63, b = 0.00 },
    flow_color = { r = 1.00, g = 0.80, b = 0.30 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-sulfur.png",
    icon_size = 64,
    order = "a[fluid]-z[molten-sulfur]",
    -- No barrel, like the island's other melts: it sets solid as soon as it
    -- leaves the heated pipe.
    auto_barrel = false,
}
