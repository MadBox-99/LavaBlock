require("prototypes.entity.pipecovers")
require("prototypes.entity.assemblerpipes")
local geo_thermal_turbine = table.deepcopy(data.raw["generator"]["steam-turbine"])
geo_thermal_turbine.name = "geo-thermal-turbine"
geo_thermal_turbine.icon_size = 64
geo_thermal_turbine.flags = { "placeable-neutral", "player-creation" }
geo_thermal_turbine.minable = { mining_time = 1, result = "geo-thermal-turbine" }
geo_thermal_turbine.max_health = 400
geo_thermal_turbine.corpse = "big-remnants"
geo_thermal_turbine.dying_explosion = "medium-explosion"
geo_thermal_turbine.effectivity = 1
geo_thermal_turbine.fluid_usage_per_tick = 1
geo_thermal_turbine.maximum_temperature = 2500
geo_thermal_turbine.burns_fluid = true
geo_thermal_turbine.fluid_box.filter = "lava"
geo_thermal_turbine.fluid_box.minimum_temperature = 1000
geo_thermal_turbine.fast_replaceable_group = "geo-thermal-turbine"

return geo_thermal_turbine