-- Calcium carbide dropped into water: it fizzes acetylene and leaves
-- slaked lime behind, which the lime line takes back.
--
-- A carbide and 20 water for 30 acetylene and a slaked lime. No
-- productivity: the slaked lime goes back through limestone to the
-- quicklime the carbide was made of, and productivity here would close
-- that loop at a profit.
return {
    type = "recipe",
    name = "acetylene-generation",
    category = "chemistry",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item",  name = "calcium-carbide", amount = 1 },
        { type = "fluid", name = "water",           amount = 20 },
    },
    results = {
        { type = "fluid", name = "acetylene",   amount = 30 },
        { type = "item",  name = "slaked-lime", amount = 1 },
    },
    main_product = "acetylene",
    allow_productivity = false,
    crafting_machine_tint = {
        primary = { r = 0.94, g = 0.94, b = 0.70, a = 1.0 },
        secondary = { r = 0.90, g = 0.90, b = 0.88, a = 1.0 },
    },
    subgroup = "fluid-recipes",
    order = "b[fluid-chemistry]-z[acetylene-generation]",
}
