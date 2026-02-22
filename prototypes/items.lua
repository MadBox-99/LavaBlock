local lava_mech_armor = require("prototypes.items.lava-mech-armor")

data:extend({
    require("prototypes.items.foundation-catalyst"),
    require("prototypes.items.foundation-platform"),
    require("prototypes.items.slug"),
    require("prototypes.items.air-cooler"),
    require("prototypes.items.generators.geo-thermal-turbine"),
    require("prototypes.items.air-compressor"),
    require("prototypes.items.industrialised-chemical-plan"),
    require("prototypes.items.lava-centrifuge"),
    require("prototypes.items.xp-lab"),
    lava_mech_armor,
})

-- Space Age only items
if mods["space-age"] then
    local pyroclast_items = require("prototypes.items.pyroclast-items")
    local pyroclast_materials = require("prototypes.items.pyroclast-materials")
    data:extend({
        require("prototypes.items.hot-tungsten-ore"),
        pyroclast_items[1], -- obsidian
        pyroclast_materials[1], -- bmat
        pyroclast_materials[2], -- cmat
    })
end

-- Items that modify data.raw directly
require("prototypes.items.trains.fluid-wagon")
require("prototypes.items.trains.cargo-wagon")
require("prototypes.items.trains.locomotive")
require("prototypes.items.storage-tank")
require("prototypes.items.landfill")
require("prototypes.items.fulgora.bacteria.uranium")