-- Productivity technologies (use loops, keep direct require)
require("prototypes.technologies.stone-item-crafting-productivity")
require("prototypes.technologies.calcite-synthesis-productivity")
require("prototypes.technologies.lava-smelting-productivity")
require("prototypes.technologies.brick-smelting-productivity")
require("prototypes.technologies.foundation-platform-productivity")
require("prototypes.technologies.foundation-platform-disable")
require("prototypes.technologies.advanced-lava-smelting-productivity")

-- XP Quest technologies (use loops, keep direct require)
require("prototypes.technologies.xp-quests.crafting-mastery")
require("prototypes.technologies.xp-quests.smelting-mastery")

-- Base game technology modifications
data.raw.technology["oil-processing"].research_trigger = { type = "craft-fluid", fluid = "crude-oil", amount = 1 }
data.raw.technology["oil-processing"].effects = {
    { type = "unlock-recipe", recipe = "basic-oil-processing" },
    { type = "unlock-recipe", recipe = "solid-fuel-from-petroleum-gas" },
    { type = "unlock-recipe", recipe = "oil-refinery" },
    { type = "unlock-recipe", recipe = "sulfur-lava" }
}
data.raw.technology["uranium-processing"].research_trigger = { type = "craft-item", item = "uranium-ore" }
data.raw.technology["oil-gathering"].effects = { { type = "unlock-recipe", recipe = "oil-extraction" } }
data.raw.technology["oil-gathering"].prerequisites = { "lava-science-pack" }
data.raw.technology["oil-gathering"].unit = {
    count = 100,
    ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack",   1 },
        { "lava-science-pack",       5 }
    },
    time = 30
}
data.raw.technology["uranium-mining"].effects = {
    { type = "mining-with-fluid", modifier = true },
    { type = "unlock-recipe",     recipe = "uranium-extraction" }
}

-- Add explosives-from-lava to explosives technology
table.insert(data.raw.technology["explosives"].effects, {
    type = "unlock-recipe",
    recipe = "explosives-from-lava",
})

-- Custom technologies
local smelting_with_air = require("prototypes.technologies.lava-cooling-with-liquid-nitrogen")
local advanced_lava_cooling = require("prototypes.technologies.advanced-lava-cooling")
local geo_thermal_turbine = require("prototypes.technologies.geo-thermal-turbine")
local offshore_pump_on_lava_block = require("prototypes.technologies.offshore-pump-on-lava-block")
local calcite_processing_on_lava_block = require("prototypes.technologies.calcite-processing-on-lava-block")
local advanced_lava_smelting = require("prototypes.technologies.advanced-lava-smelting")
local air_cooler = require("prototypes.technologies.air-cooler")
local lava_science_pack = require("prototypes.technologies.lava-science-pack")

-- Module technologies
local lava_modules = require("prototypes.technologies.modules.lava-modules")
local lava_efficiency_module = require("prototypes.technologies.modules.lava-efficiency-module")
local lava_efficiency_module_2 = require("prototypes.technologies.modules.lava-efficiency-module-2")
local lava_efficiency_module_3 = require("prototypes.technologies.modules.lava-efficiency-module-3")
local lava_speed_module = require("prototypes.technologies.modules.lava-speed-module")
local lava_speed_module_2 = require("prototypes.technologies.modules.lava-speed-module-2")
local lava_speed_module_3 = require("prototypes.technologies.modules.lava-speed-module-3")

-- Robot technologies
local lava_flying_robot_frame = require("prototypes.technologies.lava-flying-robot-frame")

-- Enchanted science pack technology
local enchanted_science_pack = require("prototypes.technologies.enchanted-science-pack")

-- Lava Centrifuge technologies
local lava_centrifuge_techs = require("prototypes.technologies.lava-centrifuge")

-- XP Lab technology
local xp_lab = require("prototypes.technologies.xp-lab")

data:extend({
    smelting_with_air,
    advanced_lava_cooling,
    geo_thermal_turbine,
    offshore_pump_on_lava_block,
    calcite_processing_on_lava_block,
    advanced_lava_smelting,
    air_cooler,
    lava_science_pack,
    lava_modules,
    lava_efficiency_module,
    lava_efficiency_module_2,
    lava_efficiency_module_3,
    lava_speed_module,
    lava_speed_module_2,
    lava_speed_module_3,
    lava_flying_robot_frame,
    enchanted_science_pack,
    lava_centrifuge_techs[1],
    lava_centrifuge_techs[2],
    xp_lab,
})

-- Space Age only: Tungsten from lava technology
if mods["space-age"] then
    data:extend({ lava_centrifuge_techs[3] })
end