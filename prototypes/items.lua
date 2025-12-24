local lava_mech_armor = require("prototypes.items.lava-mech-armor")

data:extend({
    require("prototypes.items.foundation-platform"),
    require("prototypes.items.slug"),
    require("prototypes.items.air-cooler"),
    require("prototypes.items.generators.geo-thermal-turbine"),
    require("prototypes.items.air-compressor"),
    require("prototypes.items.industrialised-chemical-plan"),
    require("prototypes.items.enchanter"),
    require("prototypes.items.base-magma-ball"),
    lava_mech_armor,
})

-- Items that modify data.raw directly
require("prototypes.items.trains.fluid-wagon")
require("prototypes.items.trains.cargo-wagon")
require("prototypes.items.trains.locomotive")
require("prototypes.items.storage-tank")
require("prototypes.items.landfill")