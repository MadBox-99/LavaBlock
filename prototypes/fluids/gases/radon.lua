-- Radon, seeping out of uranium ore as its radium decays. It has a half-life
-- of four days, and what it decays into is a run of short-lived atoms that
-- end as lead, giving off helium nuclei all the way down.
return {
    type = "fluid",
    name = "radon",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -62,
    heat_capacity = "1kJ",
    -- Dull red: radon glows red when it is cooled until it freezes.
    base_color = { r = 0.86, g = 0.47, b = 0.47 },
    flow_color = { r = 0.93, g = 0.73, b = 0.73 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/radon.png",
    icon_size = 64,
    order = "a[gas]-z[radon]",
    auto_barrel = true,
}
