-- Nitric acid, made the first way it was ever made at scale: nitrogen and
-- oxygen forced together in an electric arc, and the oxide washed into
-- water. Its use here is the one it has always had - nitrating, with
-- sulfuric acid, the coal tar that becomes explosives.
return {
    type = "fluid",
    name = "nitric-acid",
    subgroup = "fluid",
    default_temperature = 15,
    heat_capacity = "0.2kJ",
    -- Coral. Strong nitric acid fumes red-brown and stains everything it
    -- touches yellow; this sits between the two.
    base_color = { r = 0.98, g = 0.47, b = 0.35 },
    flow_color = { r = 1.00, g = 0.68, b = 0.58 },
    icon = "__LavaBlock-graphics__/graphics/icons/fluid/nitric-acid.png",
    icon_size = 64,
    order = "a[fluid]-z[nitric-acid]",
    auto_barrel = true,
}
