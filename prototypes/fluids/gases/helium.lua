-- Helium, the alpha particles of radioactive decay with electrons back on
-- them. All the helium on any planet was made that way, deep in the rock.
return {
    type = "fluid",
    name = "helium",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -269,
    heat_capacity = "1kJ",
    -- Pale gold, after the yellow line helium was first found by in the light of
    -- the Sun.
    base_color = { r = 0.98, g = 0.86, b = 0.62 },
    flow_color = { r = 0.99, g = 0.93, b = 0.81 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/helium.png",
    icon_size = 64,
    order = "a[gas]-z[helium]",
    auto_barrel = true,
}
