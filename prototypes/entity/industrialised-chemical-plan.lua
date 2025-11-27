local industrialised_chemical_plan = table.deepcopy(data.raw["assembling-machine"]["biochamber"])
industrialised_chemical_plan.name = "industrialised-chemical-plan"
industrialised_chemical_plan.energy_source = {
    type = "electric",
    usage_priority = "primary-input",
    emissions_per_minute = { pollution = -1 }
}
industrialised_chemical_plan.crafting_categories = { "chemical" }
industrialised_chemical_plan.crafting_speed = 2
industrialised_chemical_plan.module_slots = 4
industrialised_chemical_plan.minable = { mining_time = 1, result = "industrialised-chemical-plan" }

return industrialised_chemical_plan