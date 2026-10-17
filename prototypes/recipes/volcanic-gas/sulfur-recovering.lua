-- The Claus process: two parts hydrogen sulfide burnt against one of
-- sulfur dioxide, and liquid sulfur and water run out of the bottom.
-- 2 H2S + SO2 -> 3 S + 2 H2O, and the amounts follow the equation: twenty
-- and ten in, thirty sulfur out.
--
-- One unit of sulfur gas is one unit of sulfur here, and a sulfur is ten
-- units, the same ten that vanilla's acid recipe turns into fifty acid for
-- five sulfur. So sulfur and sulfuric acid off this line cost the same gas,
-- and neither use of the sulfur dioxide is the obvious one.
--
-- What it is worth against sulfur from lava: one refinery's worth of
-- volcanic gas - 1000 lava, two degassing plants, the refinery - gives 2.25
-- sulfur and 7.5 acid every five seconds, about seven building-seconds a
-- sulfur and no oil. Sulfur from lava is one second in a chemical plant,
-- but its 15 petroleum gas a sulfur is coal extraction, oil extraction and a
-- refinery behind it, about sixteen building-seconds in all. Cheaper in
-- buildings, then, but five recipes, three machine types, and steam and
-- water to put somewhere: the same trade lime concrete makes against
-- vanilla concrete.
return {
    type = "recipe",
    name = "sulfur-recovering",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "hydrogen-sulfide", amount = 20 },
        { type = "fluid", name = "sulfur-dioxide",   amount = 10 },
    },
    results = {
        { type = "fluid", name = "molten-sulfur", amount = 30 },
        { type = "fluid", name = "water",         amount = 20 },
    },
    main_product = "molten-sulfur",
    -- Fluids into fluids; productivity here would make sulfur out of nothing.
    allow_productivity = false,
    allow_quality = false,
    subgroup = "fluid-recipes",
    order = "c[volcanic-gas]-c[sulfur-recovering]",
    crafting_machine_tint = {
        primary = { r = 0.94, g = 0.63, b = 0.00, a = 1.0 },
        secondary = { r = 0.59, g = 0.63, b = 0.20, a = 1.0 },
    },
}
