local crusher_items = require("prototypes.items.crusher")
local lava_mech_armor = require("prototypes.items.lava-mech-armor")
local algae = require("prototypes.items.algae")

data:extend({
    require("prototypes.items.foundation-catalyst"),
    require("prototypes.items.foundation-platform"),
    require("prototypes.items.air-cooler"),
    require("prototypes.items.generators.geo-thermal-turbine"),
    require("prototypes.items.generators.magma-reactor"),
    require("prototypes.items.generators.magma-turbine"),
    require("prototypes.items.air-compressor"),
    require("prototypes.items.industrialised-chemical-plan"),
    require("prototypes.items.lava-centrifuge"),
    require("prototypes.items.arboretum"),
    require("prototypes.items.bio-garden"),
    require("prototypes.items.algae-tank"),
    crusher_items[1],
    crusher_items[2],
    crusher_items[3],
    require("prototypes.items.basalt"),
    require("prototypes.items.basalt-gravel"),
    -- Crystallizer line
    require("prototypes.items.crystallizer"),
    require("prototypes.items.gas-combiner"),
    require("prototypes.items.air-filter"),
    require("prototypes.items.silica-crystal"),
    require("prototypes.items.glass"),
    require("prototypes.items.glazed-panel"),
    -- Slag, and the two lines that start from it
    require("prototypes.items.lava-slag"),
    require("prototypes.items.crystals.pyrite"),
    require("prototypes.items.crystals.magnetite"),
    require("prototypes.items.crystals.olivine"),
    require("prototypes.items.crystals.ruby"),
    require("prototypes.items.crystals.sapphire"),
    require("prototypes.items.crystals.diamond"),
    require("prototypes.items.crystal-circuit-board"),
    -- The laser line
    require("prototypes.items.laser-cutter"),
    require("prototypes.items.quartz-lens"),
    require("prototypes.items.silicon-wafer"),
    require("prototypes.items.sapphire-substrate"),
    require("prototypes.items.magma-cell"),
    -- The chip line: tin, the lithography machine and what it prints
    require("prototypes.items.crystals.cassiterite"),
    require("prototypes.items.tin-plate"),
    require("prototypes.items.laser-source"),
    require("prototypes.items.lithography-machine"),
    require("prototypes.items.microchip"),
    require("prototypes.items.train-factory"),
    require("prototypes.items.lime.limestone"),
    require("prototypes.items.lime.quicklime"),
    require("prototypes.items.lime.slaked-lime"),
    require("prototypes.items.lime.lime-mortar"),
    -- The mod's own machine parts
    require("prototypes.items.crusher-roll"),
    require("prototypes.items.culture-column"),
    require("prototypes.items.grow-lamp"),
    require("prototypes.items.condenser-coil"),
    require("prototypes.items.water-condenser"),
    require("prototypes.items.quench-pit"),
    require("prototypes.items.pug-mill"),
    require("prototypes.items.wet-adobe-brick"),
    require("prototypes.items.straw"),
    require("prototypes.items.fermentation-tank"),
    require("prototypes.items.distillation-column"),
    require("prototypes.items.fuel-plant"),
    require("prototypes.items.island-link-pole"),
    require("prototypes.items.xp-lab"),
    lava_mech_armor,
    -- Bio garden harvest
    algae[1],
    algae[2],
    algae[3],
})

-- Space Age only items
if mods["space-age"] then
    data:extend({
        require("prototypes.items.hot-tungsten-ore"),
    })
end

-- Items that modify data.raw directly
require("prototypes.items.trains.fluid-wagon")
require("prototypes.items.trains.cargo-wagon")
require("prototypes.items.trains.locomotive")
require("prototypes.items.trains.artillery-wagon")
require("prototypes.items.storage-tank")
require("prototypes.items.landfill")
require("prototypes.items.fulgora.bacteria.uranium")
