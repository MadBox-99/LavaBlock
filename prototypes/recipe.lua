data.raw.recipe['burner-mining-drill'].enabled = false
local lava_cooling = require("prototypes.recipes.lava-cooling")
local calcite_synthesis = require("prototypes.recipes.calcite-synthesis")
local steam_generation = require("prototypes.recipes.steam-generation")
local brick_smelting = require("prototypes.recipes.brick-smelting")
local wood_extraction = require("prototypes.recipes.wood-extraction")
local coal_extraction = require("prototypes.recipes.coal-extraction")
local iron_extraction = require("prototypes.recipes.iron-extraction")
local iron_smelting = require("prototypes.recipes.iron-smelting")
local iron_smelting_cooling = require("prototypes.recipes.iron-smelting-cooling")
local copper_smelting = require("prototypes.recipes.copper-smelting")
local copper_smelting_cooling = require("prototypes.recipes.copper-smelting-cooling")
local copper_extraction = require("prototypes.recipes.copper-extraction")
local ore_clearing = require("prototypes.recipes.ore-clearing")
local oil_extraction = require("prototypes.recipes.oil-extraction")
local uranium_extraction = require("prototypes.recipes.uranium-extraction")
local air_cooler = require("prototypes.recipes.air-cooler")
data:extend({
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
})
