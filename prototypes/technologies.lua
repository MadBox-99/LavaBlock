-- Productivity technologies (use loops, keep direct require)
require("prototypes.technologies.stone-item-crafting-productivity")
require("prototypes.technologies.calcite-synthesis-productivity")
require("prototypes.technologies.lava-smelting-productivity")
require("prototypes.technologies.brick-smelting-productivity")
require("prototypes.technologies.foundation-platform-productivity")
require("prototypes.technologies.advanced-lava-smelting-productivity")

-- Base game technology modifications
data.raw.technology["oil-processing"].research_trigger = { type = "craft-fluid", fluid = "crude-oil", amount = 1 }
data.raw.technology["uranium-processing"].research_trigger = { type = "craft-item", item = "uranium-ore" }
data.raw.technology["oil-gathering"].effects = { { type = "unlock-recipe", recipe = "oil-extraction" } }
data.raw.technology["uranium-mining"].effects = {
    { type = "mining-with-fluid", modifier = true },
    { type = "unlock-recipe",     recipe = "uranium-extraction" }
}

-- Custom technologies
local smelting_with_air = require("prototypes.technologies.lava-cooling-with-liquid-nitrogen")
local advanced_lava_cooling = require("prototypes.technologies.advanced-lava-cooling")
local geo_thermal_turbine = require("prototypes.technologies.geo-thermal-turbine")
local offshore_pump_on_lava_block = require("prototypes.technologies.offshore-pump-on-lava-block")
local calcite_processing_on_lava_block = require("prototypes.technologies.calcite-processing-on-lava-block")
local advanced_lava_smelting = require("prototypes.technologies.advanced-lava-smelting")
local air_cooler = require("prototypes.technologies.air-cooler")
local lava_science_pack = require("prototypes.technologies.lava-science-pack")

data:extend({
    smelting_with_air,
    advanced_lava_cooling,
    geo_thermal_turbine,
    offshore_pump_on_lava_block,
    calcite_processing_on_lava_block,
    advanced_lava_smelting,
    air_cooler,
    lava_science_pack,
})