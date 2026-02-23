--require("util")
require("prototypes.recipe-category")
require("prototypes.item-groups")
require("prototypes.fluids")
require("prototypes.items")
require("prototypes.recipes")
require("prototypes.entities")
require("prototypes.technologies")
require("prototypes.island-generation")
require("prototypes.planet.pyroclast")
require("helpers.functions")
require("prototypes.tools")

remove_technology("electric-mining-drill")

if mods["space-age"] then
    -- Sulfuric acid lake tile for Pyroclast (deepcopied from water)
    data:extend({ require("prototypes.tiles.sulfuric-acid-lake") })

    -- Molten-metal geysers for Pyroclast (deepcopied from sulfuric-acid-geyser)
    data:extend(require("prototypes.entity.pyroclast-geysers"))

    -- Pyroclast Rocket Silo (deepcopied from rocket-silo, Pyroclast only)
    require("prototypes.entity.pyroclast-rocket-silo")

    -- Autoplace-control entries give these geysers sliders in the map generation UI.
    -- The noise expressions (pyroclast-generator.lua) read control:NAME:size/frequency/richness.
    data:extend({
        {
            type = "autoplace-control",
            name = "pyroclast_iron_geyser",
            localised_name = {"", "[entity=molten-iron-geyser] ", {"entity-name.molten-iron-geyser"}},
            richness = true,
            order = "f-a",
            category = "resource"
        },
        {
            type = "autoplace-control",
            name = "pyroclast_copper_geyser",
            localised_name = {"", "[entity=molten-copper-geyser] ", {"entity-name.molten-copper-geyser"}},
            richness = true,
            order = "f-b",
            category = "resource"
        },
    })

    local tech = data.raw.technology["space-platform-thruster"]
    table.insert(tech.effects, { type = "unlock-recipe", recipe = "burner-mining-drill" })
    table.insert(tech.effects, { type = "unlock-recipe", recipe = "electric-mining-drill" })
    table.insert(tech.effects, { type = "unlock-recipe", recipe = "pumpjack" })
    data.raw["fluid"]["lava"].auto_barrel = true
end