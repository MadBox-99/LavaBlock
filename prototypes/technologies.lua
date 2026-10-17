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
require("prototypes.technologies.xp-quests.handcrafting-mastery")
require("prototypes.technologies.xp-quests.mining-mastery")

local utils = require("lib.utils")

-- Base game technology modifications. Effects are edited one unlock at a
-- time, never reassigned, so unlocks other mods added survive.

-- Oil processing: the chemical plant comes earlier, from Calcite
-- processing on lava block, and sulfur comes from lava here.
data.raw.technology["oil-processing"].research_trigger = { type = "craft-fluid", fluid = "crude-oil", amount = 1 }
utils.remove_recipe_unlock("oil-processing", "chemical-plant")
table.insert(data.raw.technology["oil-processing"].effects, { type = "unlock-recipe", recipe = "sulfur-lava" })
data.raw.technology["uranium-processing"].research_trigger = { type = "craft-item", item = "uranium-ore" }
-- Oil gathering: no oil patches on the island, so crude oil is extracted
-- from lava instead of pumped.
utils.remove_recipe_unlock("oil-gathering", "pumpjack")
table.insert(data.raw.technology["oil-gathering"].effects, { type = "unlock-recipe", recipe = "oil-extraction" })
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
table.insert(data.raw.technology["uranium-mining"].effects, { type = "unlock-recipe", recipe = "uranium-extraction" })

-- Add explosives-from-lava to explosives technology
-- Every train now takes condenser coils and pumps. The coil is otherwise
-- unlocked by the Water Condenser, which needs chemical science, so Railway
-- unlocks it too rather than pushing trains back to blue science; the pump
-- is plain Fluid handling, a red-and-green research, so it simply becomes a
-- prerequisite.
table.insert(data.raw.technology["railway"].effects, {
    type = "unlock-recipe",
    recipe = "condenser-coil",
})
table.insert(data.raw.technology["railway"].prerequisites, "fluid-handling")

-- Trains are only built in the train factory, so Railway hands over the
-- factory with the locomotive and the wagon.
table.insert(data.raw.technology["railway"].effects, {
    type = "unlock-recipe",
    recipe = "train-factory",
})

-- The island link pole comes with the big pole it is built from.
table.insert(data.raw.technology["electric-energy-distribution-1"].effects, {
    type = "unlock-recipe",
    recipe = "island-link-pole",
})

table.insert(data.raw.technology["explosives"].effects, {
    type = "unlock-recipe",
    recipe = "explosives-from-lava",
})

-- Simple coal liquefaction runs on sulfuric acid, so it comes with the acid.
table.insert(data.raw.technology["sulfur-processing"].effects, {
    type = "unlock-recipe",
    recipe = "simple-coal-liquefaction",
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

-- Lava Centrifuge technologies
local lava_centrifuge_techs = require("prototypes.technologies.lava-centrifuge")
local uranium_hexafluoride_tech = require("prototypes.technologies.uranium-hexafluoride")

-- Bio Garden technology
local bio_garden_tech = require("prototypes.technologies.bio-garden")

-- Oxygen technology
local oxygen_processing_tech = require("prototypes.technologies.oxygen-processing")

-- The fluid lines: volcanic gas
local volcanic_gas_processing_tech = require("prototypes.technologies.volcanic-gas-processing")
local chlor_alkali_process_tech = require("prototypes.technologies.chlor-alkali-process")
local glass_melting_tech = require("prototypes.technologies.glass-melting")
local float_glass_tech = require("prototypes.technologies.float-glass")
local oxygen_steelmaking_tech = require("prototypes.technologies.oxygen-steelmaking")
local silicon_refining_tech = require("prototypes.technologies.silicon-refining")
local nitric_acid_tech = require("prototypes.technologies.nitric-acid")

-- Blue algae: needs the air chain, so it follows the compressor line
local nitrogen_fixation_tech = require("prototypes.technologies.nitrogen-fixation")

-- Crusher technology: early, because land expansion is available from the
-- first minute and its stone bill is the biggest cost in the mod.
local stone_crushing_techs = require("prototypes.technologies.stone-crushing")

-- Arboretum technology
local lava_crystallization_tech = require("prototypes.technologies.lava-crystallization")
local refined_crystallization_tech = require("prototypes.technologies.refined-crystallization")
local shielded_crystallization_tech = require("prototypes.technologies.shielded-crystallization")
local crystal_growing_tech = require("prototypes.technologies.crystal-growing")
local magnetite_growing_tech = require("prototypes.technologies.magnetite-growing")
local crystal_circuit_board_tech = require("prototypes.technologies.crystal-circuit-board")
local laser_cutting_tech = require("prototypes.technologies.laser-cutting")
local euv_lithography_tech = require("prototypes.technologies.euv-lithography")
local gas_lasers_tech = require("prototypes.technologies.gas-lasers")
local microchip_modules_tech = require("prototypes.technologies.microchip-modules")
local magma_power_tech = require("prototypes.technologies.magma-power")
local ferromagnetism_tech = require("prototypes.technologies.ferromagnetism")
local limestone_processing_tech = require("prototypes.technologies.limestone-processing")
local chlorinated_purification_tech = require("prototypes.technologies.chlorinated-purification")
local arboretum_tech = require("prototypes.technologies.arboretum")
local algae_cultivation_tech = require("prototypes.technologies.algae-cultivation")

-- Water Condenser technology
local water_condenser_tech = require("prototypes.technologies.water-condenser")
local quench_pit_tech = require("prototypes.technologies.quench-pit")
local adobe_bricks_tech = require("prototypes.technologies.adobe-bricks")
local bio_ethanol_tech = require("prototypes.technologies.bio-ethanol")
local synthetic_ethanol_tech = require("prototypes.technologies.synthetic-ethanol")
local ethanol_rocket_fuel_tech = require("prototypes.technologies.ethanol-rocket-fuel")
local biogas_tech = require("prototypes.technologies.biogas")
local diamond_synthesis_tech = require("prototypes.technologies.diamond-synthesis")
local bio_plastics_tech = require("prototypes.technologies.bio-plastics")

-- The arc furnace, and the metals and alloys it smelts
local arc_smelting_tech = require("prototypes.technologies.arc-smelting")
local sulfide_ores_tech = require("prototypes.technologies.sulfide-ores")
local alloy_steels_tech = require("prototypes.technologies.alloy-steels")
local copper_alloys_tech = require("prototypes.technologies.copper-alloys")
local light_metals_tech = require("prototypes.technologies.light-metals")
local boron_processing_tech = require("prototypes.technologies.boron-processing")
local titanium_processing_tech = require("prototypes.technologies.titanium-processing")
local rare_earth_processing_tech = require("prototypes.technologies.rare-earth-processing")
local superalloys_tech = require("prototypes.technologies.superalloys")
local precious_metals_tech = require("prototypes.technologies.precious-metals")
local ammonia_synthesis_tech = require("prototypes.technologies.ammonia-synthesis")
local fertilizer_tech = require("prototypes.technologies.fertilizer")

-- XP Lab technology
local xp_lab = require("prototypes.technologies.xp-lab")

-- Military Science Pack 2 technology
local military_science_pack_2 = require("prototypes.technologies.military-science-pack-2")

-- Asteroid productivity technologies (Space Age)
local asteroid_productivity_simple = require("prototypes.technologies.asteroid-productivity-simple")
local asteroid_productivity_advanced = require("prototypes.technologies.asteroid-productivity-advanced")

-- Industrialised Chemical Plant technology (space-age only: needs `biochamber`)
local industrialised_chemical_plant_tech = require("prototypes.technologies.industrialised-chemical-plant")

-- Circuit Science Pack technologies
local circuit_science_pack_tech = require("prototypes.technologies.circuit-science-pack")
local circuit_crafting_productivity = require("prototypes.technologies.circuit-crafting-productivity")

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
    stone_crushing_techs[1],
    stone_crushing_techs[2],
    stone_crushing_techs[3],
    stone_crushing_techs[4],
    stone_crushing_techs[5],
    lava_crystallization_tech,
    refined_crystallization_tech,
    shielded_crystallization_tech,
    crystal_growing_tech,
    magnetite_growing_tech,
    crystal_circuit_board_tech,
    laser_cutting_tech,
    euv_lithography_tech,
    gas_lasers_tech,
    microchip_modules_tech,
    magma_power_tech,
    ferromagnetism_tech,
    limestone_processing_tech,
    chlorinated_purification_tech,
    arboretum_tech,
    algae_cultivation_tech,
    bio_garden_tech,
    oxygen_processing_tech,
    volcanic_gas_processing_tech,
    chlor_alkali_process_tech,
    glass_melting_tech,
    float_glass_tech,
    oxygen_steelmaking_tech,
    silicon_refining_tech,
    nitric_acid_tech,
    nitrogen_fixation_tech,
    water_condenser_tech,
    quench_pit_tech,
    adobe_bricks_tech,
    bio_ethanol_tech,
    synthetic_ethanol_tech,
    ethanol_rocket_fuel_tech,
    biogas_tech,
    diamond_synthesis_tech,
    bio_plastics_tech,
    arc_smelting_tech,
    sulfide_ores_tech,
    alloy_steels_tech,
    copper_alloys_tech,
    light_metals_tech,
    boron_processing_tech,
    titanium_processing_tech,
    rare_earth_processing_tech,
    superalloys_tech,
    precious_metals_tech,
    ammonia_synthesis_tech,
    fertilizer_tech,
    lava_centrifuge_techs[1],
    lava_centrifuge_techs[2],
    uranium_hexafluoride_tech,
    xp_lab,
    military_science_pack_2,
    circuit_science_pack_tech,
    circuit_crafting_productivity,
})

-- Space Age only: Tungsten from lava technology
if mods["space-age"] then
    data:extend({
        lava_centrifuge_techs[3],
        asteroid_productivity_simple,
        asteroid_productivity_advanced,
        industrialised_chemical_plant_tech,
    })
end