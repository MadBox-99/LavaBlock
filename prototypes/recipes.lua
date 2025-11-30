data.raw.recipe['burner-mining-drill'].enabled = false
require("prototypes.recipes.industrialised-chemical-plant")
require("prototypes.recipes.air.air-electrostatic-adsorption")
require("prototypes.recipes.air.extraction.air-extraction")
require("prototypes.technologies.smelting-with-air")
local lava_cooling = require("prototypes.recipes.lava-cooling")
local calcite_synthesis = require("prototypes.recipes.calcite-synthesis")
local steam_generation = require("prototypes.recipes.steam-generation")
local brick_smelting = require("prototypes.recipes.brick-smelting")
local wood_extraction = require("prototypes.recipes.extraction.wood-extraction")
local coal_extraction = require("prototypes.recipes.extraction.coal-extraction")
local iron_extraction = require("prototypes.recipes.extraction.iron-extraction")
local iron_smelting = require("prototypes.recipes.smelting.iron.iron-smelting")
local iron_smelting_cooling = require("prototypes.recipes.smelting.iron.iron-smelting-cooling")
local copper_smelting = require("prototypes.recipes.smelting.copper.copper-smelting")
local copper_smelting_cooling = require("prototypes.recipes.smelting.copper.copper-smelting-cooling")
local copper_extraction = require("prototypes.recipes.extraction.copper-extraction")
local ore_clearing = require("prototypes.recipes.ore-clearing")
local oil_extraction = require("prototypes.recipes.extraction.oil-extraction")
local uranium_extraction = require("prototypes.recipes.extraction.uranium-extraction")
local air_cooler = require("prototypes.recipes.air.air-cooler")
local liquid_nitrogen_production = require("prototypes.recipes.liquid-nitrogen-production")
local iron_smelting_cryo_cooling = require("prototypes.recipes.smelting.iron.iron-smelting-cryo-cooling")
local copper_smelting_cryo_cooling = require("prototypes.recipes.smelting.copper.copper-smelting-cryo-cooling")
local gas_turbine = require("prototypes.recipes.geo-thermal-turbine")
local lava_cooling_with_liquid_nitrogen = require("prototypes.recipes.lava-cooling-with-liquid-nitrogen")
data:extend({
    lava_cooling_with_liquid_nitrogen,
    lava_cooling,
    calcite_synthesis,
    steam_generation,
    ore_clearing,
    brick_smelting,
    wood_extraction,
    coal_extraction,
    iron_extraction,
    iron_smelting,
    iron_smelting_cooling,
    copper_extraction,
    copper_smelting,
    copper_smelting_cooling,
    oil_extraction,
    uranium_extraction,
    air_cooler,
    liquid_nitrogen_production,
    iron_smelting_cryo_cooling,
    copper_smelting_cryo_cooling,
    gas_turbine,
})