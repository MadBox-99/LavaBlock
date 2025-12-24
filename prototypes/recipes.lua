-- Disable base recipes
data.raw.recipe['burner-mining-drill'].enabled = false

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
local enchanter = require("prototypes.recipes.enchanter")

-- Enchanting recipes
local base_magma_ball = require("prototypes.recipes.enchanting.base-magma-ball")
local fusioning_lava = require("prototypes.recipes.enchanting.fusioning-lava")
local stronger_fusioning_lava = require("prototypes.recipes.enchanting.stronger-fusioning-lava")
local enchanted_lava = require("prototypes.recipes.enchanting.enchanted-lava")
local lava_science_pack_enchanted = require("prototypes.recipes.enchanting.lava-science-pack-enchanted")
local low_density_structure_enchanted = require("prototypes.recipes.enchanting.low-density-structure-enchanted")
local electronic_circuit_enchanting = require("prototypes.recipes.enchanting.electronic-circuit-enchanting")
local advanced_circuit_enchanting = require("prototypes.recipes.enchanting.advanced-circuit-enchanting")
local processing_unit_enchanting = require("prototypes.recipes.enchanting.processing-unit-enchanting")

-- Module recipes
local lava_efficiency_module = require("prototypes.recipes.modules.efficiency-module")
local lava_speed_module = require("prototypes.recipes.modules.speed-module")

-- Robot recipes
local lava_flying_robot_frame = require("prototypes.recipes.flying-robot-frame")

-- Modified base recipes (Nauvis only)
local sulfur_lava = require("prototypes.recipes.sulfur-lava")

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
    lava_speed_module,
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
    enchanter,
    -- Enchanting recipes
    base_magma_ball,
    fusioning_lava,
    stronger_fusioning_lava,
    enchanted_lava,
    lava_science_pack_enchanted,
    low_density_structure_enchanted,
    -- Circuit enchanting recipes
    electronic_circuit_enchanting[1],
    electronic_circuit_enchanting[2],
    electronic_circuit_enchanting[3],
    advanced_circuit_enchanting[1],
    advanced_circuit_enchanting[2],
    advanced_circuit_enchanting[3],
    processing_unit_enchanting[1],
    processing_unit_enchanting[2],
    processing_unit_enchanting[3],
    -- Modified base recipes (Nauvis only)
    sulfur_lava,
})