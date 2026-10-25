-- PVC: ethylene and hydrochloric acid made into vinyl chloride over a
-- copper catalyst with air, and the vinyl chloride polymerised. The real
-- plant has three stages; a chemical plant has two inlets, and the air
-- the oxychlorination takes is drawn in as it is.
--
-- 20 ethylene and 10 acid for three plastic bars, where vanilla makes two
-- from 20 petroleum gas and a coal. Twenty ethylene is eight straw;
-- twenty petroleum gas is about eleven coal through oil extraction and a
-- refinery, and the recipe's own coal on top. So this trades the oil line
-- for the fermentation line and a share of the chlor-alkali cell.
--
-- Not two. Bar for bar, the fermentation line behind the ethylene cost a
-- quarter more than vanilla plastic; three makes it a fifth cheaper.
return {
    type = "recipe",
    name = "plastic-bar-from-ethylene",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "ethylene",          amount = 20 },
        { type = "fluid", name = "hydrochloric-acid", amount = 10 },
    },
    results = {
        { type = "item", name = "plastic-bar", amount = 3 },
    },
    allow_productivity = true,
    -- Plastic keeps recycling the way it did.
    auto_recycle = false,
    icons = {
        {
            icon = "__base__/graphics/icons/plastic-bar.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/ethylene.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "b[chemistry]-b[plastic-bar]-b[ethylene]",
    crafting_machine_tint = {
        primary = { r = 1.00, g = 1.00, b = 1.00, a = 1.0 },
        secondary = { r = 0.94, g = 0.51, b = 0.75, a = 1.0 },
    },
}
