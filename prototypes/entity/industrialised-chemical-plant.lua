--[[ local industrialised_chemical_plant = table.deepcopy(data.raw["assembling-machine"]["biochamber"])
industrialised_chemical_plant.name = "industrialised-chemical-plan"
industrialised_chemical_plant.energy_source = {
    type = "electric",
    usage_priority = "primary-input",
    emissions_per_minute = { pollution = -1 }
}
industrialised_chemical_plant.crafting_categories = { "chemical" }
industrialised_chemical_plant.crafting_speed = 2
industrialised_chemical_plant.module_slots = 4
industrialised_chemical_plant.minable = { mining_time = 1, result = "industrialised-chemical-plan" }
 ]]

local industrialised_chemical_plant = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
local number_tint = { r = 1, g = 1, b = 1, a = 1 }
industrialised_chemical_plant.name = "industrialised-chemical-plant"
industrialised_chemical_plant.minable.result = "industrialised-chemical-plant"
industrialised_chemical_plant.crafting_categories = { "chemistry" }
industrialised_chemical_plant.crafting_speed = 2.0
industrialised_chemical_plant.fluid_boxes_off_when_no_fluid_recipe = true
industrialised_chemical_plant.graphics_set.animation = {
    filename = "__LavaBlock__/graphics/entity/industrialised-chemical-plant/industrialised-chemical-plant-128.png",
    width = 128,
    height = 128,
    frame_count = 1,
    tint = number_tint,
}
industrialised_chemical_plant.fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            { direction = 0, position = { 0, 1 }, flow_direction = "input", }
        },
        base_area = 10,
        base_level = -1,
        height = 2,
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        volume = 1000,
    },
    {
        production_type = "output",
        pipe_connections = {
            { direction = 4, position = { 0, -1 }, flow_direction = "output", }
        },
        base_area = 10,
        base_level = 1,
        height = 2,
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        volume = 1000,
    }
}
return industrialised_chemical_plant