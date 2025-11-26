require("prototypes.recipes.crafting-machine-tints.biochamber")
local industryalised_chemycal_plan = table.deepcopy(data.raw["assembling-machine"]["biochamber"])
data.raw["assembling-machine"]["biochamber"].graphics_set.default_recipe_tint =
{
    primary = { r = 0.75, g = 0.75, b = 1, a = 1 },
    secondary = { r = 1, g = 0.5, b = 0, a = 1 },
    tertiary = { r = 1, g = 0.85, b = 0.75, a = 1 },
    quaternary = { r = 1, g = 1, b = 0, a = 1 },
};
industryalised_chemycal_plan.name = "industryalised-chemycal-plan"
industryalised_chemycal_plan.energy_source = {
    type = "electric",
    usage_priority = "primary-input",
    emissions_per_minute = { pollution = -1 }
}
industryalised_chemycal_plan.crafting_categories = { "chemistry" }
industryalised_chemycal_plan.crafting_speed = 2
industryalised_chemycal_plan.module_slots = 4
industryalised_chemycal_plan.minable = { mining_time = 1, result = "industryalised-chemycal-plan" }

return industryalised_chemycal_plan