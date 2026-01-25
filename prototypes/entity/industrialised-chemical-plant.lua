local utils = require("lib.utils")

local industrialised_chemical_plant = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
industrialised_chemical_plant.name = "industrialised-chemical-plant"
industrialised_chemical_plant.minable.result = "industrialised-chemical-plant"
industrialised_chemical_plant.crafting_categories = { "chemical" }
industrialised_chemical_plant.crafting_speed = 2.0

industrialised_chemical_plant.graphics_set = utils.make_rotated_graphics_set({
    filename = "__LavaBlock__/graphics/icons/entity/industrialised_factory.png",
    width = 256,
    height = 256,
    frame_count = 4,
    scale = 0.5,
})

utils.remove_pipe_covers(industrialised_chemical_plant)

return industrialised_chemical_plant