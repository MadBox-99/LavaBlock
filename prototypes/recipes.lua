-- Disable base recipes
data.raw.recipe['burner-mining-drill'].enabled = false

-- The arboretum closes its own loop, so Space Age's seed recipe has to be
-- runnable in it. additional_categories is additive: wood-processing keeps
-- working everywhere it already worked.
local wp = data.raw.recipe['wood-processing']
if wp then
    wp.additional_categories = wp.additional_categories or {}
    table.insert(wp.additional_categories, 'arboretum')
end

-- Air recipes
local air_compressor = require("prototypes.recipes.air.air-compressor")
local air_electrostatic_adsorption = require("prototypes.recipes.air.air-electrostatic-adsorption")
local air_extraction = require("prototypes.recipes.air.extraction.air-extraction")
local extraction_from_air = require("prototypes.recipes.air.extraction.extraction-from-air")
local air_cooler = require("prototypes.recipes.air.air-cooler")

-- Extraction recipes
local wood_extraction = require("prototypes.recipes.extraction.wood-extraction")
local coal_extraction = require("prototypes.recipes.extraction.coal-extraction")
local iron_extraction = require("prototypes.recipes.extraction.iron-extraction")
local copper_extraction = require("prototypes.recipes.extraction.copper-extraction")
local oil_extraction = require("prototypes.recipes.extraction.oil-extraction")
local uranium_extraction = require("prototypes.recipes.extraction.uranium-extraction")

-- Smelting recipes
local brick_smelting = require("prototypes.recipes.smelting.brick.brick-smelting")
local iron_smelting = require("prototypes.recipes.smelting.iron.iron-smelting")
local iron_smelting_cooling = require("prototypes.recipes.smelting.iron.iron-smelting-cooling")
local iron_smelting_cryo_cooling = require("prototypes.recipes.smelting.iron.iron-smelting-cryo-cooling")
local copper_smelting = require("prototypes.recipes.smelting.copper.copper-smelting")
local copper_smelting_cooling = require("prototypes.recipes.smelting.copper.copper-smelting-cooling")
local copper_smelting_cryo_cooling = require("prototypes.recipes.smelting.copper.copper-smelting-cryo-cooling")

-- Lava processing recipes
local lava_cooling = require("prototypes.recipes.lava-cooling")
local lava_cooling_with_liquid_nitrogen = require("prototypes.recipes.lava-cooling-with-liquid-nitrogen")
local liquid_nitrogen_production = require("prototypes.recipes.liquid-nitrogen-production")

-- Other recipes
local calcite_synthesis = require("prototypes.recipes.calcite-synthesis")
local steam_generation = require("prototypes.recipes.steam-generation")
local ore_clearing = require("prototypes.recipes.ore-clearing")
local gas_turbine = require("prototypes.recipes.geo-thermal-turbine")
local industrialised_chemical_plant = require("prototypes.recipes.industrialised-chemical-plant")
local lava_science_pack = require("prototypes.recipes.lava-science-pack")
local foundation_platform = require("prototypes.recipes.foundation-platform")
local foundation_catalyst = require("prototypes.recipes.foundation-catalyst")

-- Enchanted science pack recipe
local enchanted_science_pack = require("prototypes.recipes.enchanting.enchanted-science-pack")

-- Military Science Pack 2 recipe
local military_science_pack_2 = require("prototypes.recipes.military-science-pack-2")

-- Circuit Science Pack recipe
local circuit_science_pack = require("prototypes.recipes.circuit-science-pack")

-- XP Lab recipe
local xp_lab = require("prototypes.recipes.xp-lab")

-- Bio Garden recipes
local bio_garden = require("prototypes.recipes.bio-garden")
local algae_tank = require("prototypes.recipes.algae-tank")
local algae_cultivation = require("prototypes.recipes.algae.algae-cultivation")
local algae_processing = require("prototypes.recipes.algae.algae-processing")

-- Oxygen recipes
local water_electrolysis = require("prototypes.recipes.gases.water-electrolysis")
local volcanic_gas_scrubbing = require("prototypes.recipes.gases.volcanic-gas-scrubbing")
local oxygen_enriched = require("prototypes.recipes.smelting.oxygen-enriched")

-- Crusher recipes
local crusher_recipes = require("prototypes.recipes.crusher")
local basalt_casting = require("prototypes.recipes.crusher.basalt-casting")
local stone_crushing = require("prototypes.recipes.crusher.stone-crushing")
local crusher_roll = require("prototypes.recipes.parts.crusher-roll")
local culture_column = require("prototypes.recipes.parts.culture-column")

-- Crystallizer recipes
local crystallizer = require("prototypes.recipes.crystallizer")
local silica_crystallizing = require("prototypes.recipes.crystallizer.silica-crystallizing")
local silica_crystallizing_purified = require("prototypes.recipes.crystallizer.silica-crystallizing-purified")
local silica_crystallizing_shielded = require("prototypes.recipes.crystallizer.silica-crystallizing-shielded")

-- Gas combiner recipes
local gas_combiner = require("prototypes.recipes.gas-combiner")
local air_filter = require("prototypes.recipes.air-filter")
local shielding_gas = require("prototypes.recipes.gas-combiner.shielding-gas")
local argon_extraction = require("prototypes.recipes.air.argon-extraction")
local glass = require("prototypes.recipes.smelting.glass")
local glazed_panel = require("prototypes.recipes.parts.glazed-panel")
local grow_lamp = require("prototypes.recipes.parts.grow-lamp")
local condenser_coil = require("prototypes.recipes.parts.condenser-coil")

-- Arboretum recipes
local arboretum = require("prototypes.recipes.arboretum")
local tree_cultivation = require("prototypes.recipes.wood.tree-cultivation")

-- Water Condenser recipes
local water_condenser = require("prototypes.recipes.water-condenser")
local quench_pit = require("prototypes.recipes.quench-pit")
local steam_condensing = require("prototypes.recipes.water.steam-condensing")

-- Lava Centrifuge recipes
local lava_centrifuge = require("prototypes.recipes.lava-centrifuge")
local lava_purification = require("prototypes.recipes.centrifuge.lava-purification")
local lava_purification_chlorinated = require("prototypes.recipes.centrifuge.lava-purification-chlorinated")
local rare_mineral_extraction = require("prototypes.recipes.centrifuge.rare-mineral-extraction")
local concentrated_ore_extraction = require("prototypes.recipes.centrifuge.concentrated-ore-extraction")

-- Module recipes
local lava_efficiency_module = require("prototypes.recipes.modules.efficiency-module")
local lava_efficiency_module_2 = require("prototypes.recipes.modules.efficiency-module-2")
local lava_efficiency_module_3 = require("prototypes.recipes.modules.efficiency-module-3")
local lava_speed_module = require("prototypes.recipes.modules.speed-module")
local lava_speed_module_2 = require("prototypes.recipes.modules.speed-module-2")
local lava_speed_module_3 = require("prototypes.recipes.modules.speed-module-3")

-- Robot recipes
local lava_flying_robot_frame = require("prototypes.recipes.flying-robot-frame")

-- Modified base recipes (Nauvis only)
local sulfur_lava = require("prototypes.recipes.sulfur-lava")

-- Vulcanus-specific recipes
local explosives_from_lava = require("prototypes.recipes.explosives-from-lava")

-- Fulgora-specific recipes
require("prototypes.recipes.fulgora.bacteria.uranium")

data:extend({
    -- Air recipes
    air_compressor,
    air_electrostatic_adsorption,
    air_extraction,
    extraction_from_air[1],
    extraction_from_air[2],
    air_cooler,
    -- Extraction recipes
    wood_extraction,
    coal_extraction,
    iron_extraction,
    copper_extraction,
    oil_extraction,
    uranium_extraction,
    -- Smelting recipes
    brick_smelting,
    iron_smelting,
    iron_smelting_cooling,
    iron_smelting_cryo_cooling,
    copper_smelting,
    copper_smelting_cooling,
    copper_smelting_cryo_cooling,
    -- Lava processing recipes
    lava_cooling,
    lava_cooling_with_liquid_nitrogen,
    liquid_nitrogen_production,
    -- Module recipes
    lava_efficiency_module,
    lava_efficiency_module_2,
    lava_efficiency_module_3,
    lava_speed_module,
    lava_speed_module_2,
    lava_speed_module_3,
    -- Robot recipes
    lava_flying_robot_frame,
    -- Other recipes
    calcite_synthesis,
    steam_generation,
    ore_clearing,
    gas_turbine,
    industrialised_chemical_plant,
    lava_science_pack,
    foundation_platform,
    foundation_catalyst,
    -- Enchanted science pack recipe
    enchanted_science_pack,
    -- Military Science Pack 2 recipe
    military_science_pack_2,
    -- Circuit Science Pack recipe
    circuit_science_pack,
    -- XP Lab recipe
    xp_lab,
    -- Bio Garden recipes
    bio_garden,
    algae_tank,
    algae_cultivation[1],
    algae_cultivation[2],
    algae_cultivation[3],
    algae_processing[1],
    algae_processing[2],
    algae_processing[3],
    -- Oxygen recipes
    water_electrolysis,
    volcanic_gas_scrubbing,
    oxygen_enriched[1],
    oxygen_enriched[2],
    -- Crusher recipes
    crusher_recipes[1],
    crusher_recipes[2],
    crusher_recipes[3],
    basalt_casting,
    stone_crushing[1],
    stone_crushing[2],
    stone_crushing[3],
    stone_crushing[4],
    crusher_roll,
    culture_column,
    -- Crystallizer recipes
    crystallizer,
    silica_crystallizing,
    silica_crystallizing_purified,
    silica_crystallizing_shielded,
    -- Gas combiner recipes
    gas_combiner,
    air_filter,
    shielding_gas,
    argon_extraction,
    glass,
    glazed_panel,
    grow_lamp,
    condenser_coil,
    -- Arboretum recipes
    arboretum,
    tree_cultivation,
    -- Water Condenser recipes
    water_condenser,
    quench_pit,
    steam_condensing,
    -- Lava Centrifuge recipes
    lava_centrifuge,
    lava_purification,
    lava_purification_chlorinated,
    rare_mineral_extraction[1],
    concentrated_ore_extraction,
    -- Modified base recipes (Nauvis only)
    sulfur_lava,
    -- Vulcanus-specific recipes
    explosives_from_lava,
})

-- Space Age only: Tungsten processing recipes
if mods["space-age"] then
    local tungsten_plate_from_lava = require("prototypes.recipes.foundry.tungsten-plate-from-lava")
    data:extend({
        rare_mineral_extraction[2], -- hot-tungsten-ore-from-lava
        rare_mineral_extraction[3], -- liquid-tungsten-from-hot-ore
        tungsten_plate_from_lava,
    })
end