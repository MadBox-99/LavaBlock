local pyroclast_silo = table.deepcopy(data.raw["rocket-silo"]["rocket-silo"])
pyroclast_silo.name = "pyroclast-rocket-silo"
pyroclast_silo.minable.result = "pyroclast-rocket-silo"
pyroclast_silo.placeable_by = { item = "pyroclast-rocket-silo", count = 1 }
pyroclast_silo.surface_conditions = {
    { property = "pressure", min = 6000, max = 6000 },
    { property = "gravity",  min = 60,   max = 60   },
}

data:extend({ pyroclast_silo })
