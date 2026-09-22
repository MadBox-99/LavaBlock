local crushers = require("prototypes.entity.crusher")

data:extend({
    require("prototypes.entity.air-cooler"),
    require("prototypes.entity.geo-thermal-turbine"),
    require("prototypes.entity.air-compressor"),
    require("prototypes.entity.industrialised-chemical-plant"),
    require("prototypes.entity.lava-centrifuge"),
    require("prototypes.entity.arboretum"),
    require("prototypes.entity.bio-garden"),
    require("prototypes.entity.algae-tank"),
    crushers[1],
    crushers[2],
    crushers[3],
    require("prototypes.entity.crystallizer"),
    require("prototypes.entity.water-condenser"),
    require("prototypes.entity.xp-lab"),
})