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

-- Slag, the crystals grown from it and the crusher's way out for the surplus
local lava_slag_skimming = require("prototypes.recipes.slag.lava-slag-skimming")
local crystal_growing = require("prototypes.recipes.crystallizer.crystal-growing")
local magnetite_growing = require("prototypes.recipes.crystallizer.magnetite-growing")
local cassiterite_growing = require("prototypes.recipes.crystallizer.cassiterite-growing")
local diamond_depositing = require("prototypes.recipes.crystallizer.diamond-depositing")
local pyrite_crushing = require("prototypes.recipes.crusher.crystal-crushing.pyrite-crushing")
local olivine_crushing = require("prototypes.recipes.crusher.crystal-crushing.olivine-crushing")
local ruby_crushing = require("prototypes.recipes.crusher.crystal-crushing.ruby-crushing")
local sapphire_crushing = require("prototypes.recipes.crusher.crystal-crushing.sapphire-crushing")
local diamond_crushing = require("prototypes.recipes.crusher.crystal-crushing.diamond-crushing")
local crystal_circuit_board = require("prototypes.recipes.parts.crystal-circuit-board")

-- The laser line: quartz lenses, the cutter, and what it cuts
local quartz_melting = require("prototypes.recipes.laser.quartz-melting")
local quartz_lens = require("prototypes.recipes.laser.quartz-lens")
local laser_cutter = require("prototypes.recipes.laser-cutter")
local silicon_wafer_cutting = require("prototypes.recipes.laser.silicon-wafer-cutting")
local sapphire_substrate_cutting = require("prototypes.recipes.laser.sapphire-substrate-cutting")
local solar_panel_from_wafers = require("prototypes.recipes.laser.solar-panel-from-wafers")
local sapphire_processing_unit = require("prototypes.recipes.laser.sapphire-processing-unit")

-- The chip line: tin, the lithography machine, its laser source and its chips
local tin_plate = require("prototypes.recipes.smelting.tin-plate")
local laser_source = require("prototypes.recipes.lithography.laser-source")
local lithography_machine = require("prototypes.recipes.lithography.lithography-machine")
local microchip = require("prototypes.recipes.lithography.microchip")
local microchip_processing_unit = require("prototypes.recipes.lithography.microchip-processing-unit")

-- Gas lasers: neon out of air, and a laser source that lases in it
local neon_extraction = require("prototypes.recipes.gas-lasers.neon-extraction")
local laser_source_neon = require("prototypes.recipes.gas-lasers.laser-source-neon")

-- The magnetics line: the coil winder, coils, magnets, ferrofluid and the
-- transformer
local coil_winder = require("prototypes.recipes.coil-winder")
local magnetic_coil = require("prototypes.recipes.magnetics.magnetic-coil")
local ferrite_magnet = require("prototypes.recipes.magnetics.ferrite-magnet")
local ferrofluid = require("prototypes.recipes.magnetics.ferrofluid")
local transformer = require("prototypes.recipes.magnetics.transformer")

-- The magma power line: the fuel, the salt loop and the two machines
local magma_cell = require("prototypes.recipes.magma.magma-cell")
local salt_melting = require("prototypes.recipes.magma.salt-melting")
local molten_salt_cooling = require("prototypes.recipes.magma.molten-salt-cooling")
local magma_reactor = require("prototypes.recipes.magma.magma-reactor")
local magma_turbine = require("prototypes.recipes.magma.magma-turbine")

-- The lime line, slag to concrete
local lava_slag_leaching = require("prototypes.recipes.lime.lava-slag-leaching")
local coal_combustion = require("prototypes.recipes.lime.coal-combustion")
local limestone_carbonation = require("prototypes.recipes.lime.limestone-carbonation")
local limestone_calcination = require("prototypes.recipes.lime.limestone-calcination")
local lime_slaking = require("prototypes.recipes.lime.lime-slaking")
local lime_mortar = require("prototypes.recipes.lime.lime-mortar")
local lime_concrete = require("prototypes.recipes.lime.lime-concrete")

-- The volcanic gas line: sulfur and sulfuric acid without oil
local lava_degassing = require("prototypes.recipes.volcanic-gas.lava-degassing")
local volcanic_gas_fractionation = require("prototypes.recipes.volcanic-gas.volcanic-gas-fractionation")
local sulfur_recovering = require("prototypes.recipes.volcanic-gas.sulfur-recovering")
local sulfur_prilling = require("prototypes.recipes.volcanic-gas.sulfur-prilling")
local sulfuric_acid_from_sulfur_dioxide = require("prototypes.recipes.volcanic-gas.sulfuric-acid-from-sulfur-dioxide")
local sulfur_concrete = require("prototypes.recipes.volcanic-gas.sulfur-concrete")

-- The chlor-alkali line: brine, the cell, and the chlorides
local brine_leaching = require("prototypes.recipes.chlor-alkali.brine-leaching")
local brine_electrolysis = require("prototypes.recipes.chlor-alkali.brine-electrolysis")
local hydrochloric_acid = require("prototypes.recipes.chlor-alkali.hydrochloric-acid")
local ferric_chloride = require("prototypes.recipes.chlor-alkali.ferric-chloride")
local advanced_circuit_etched = require("prototypes.recipes.chlor-alkali.advanced-circuit-etched")
local magnetite_precipitation = require("prototypes.recipes.chlor-alkali.magnetite-precipitation")

-- The glass line: soda-lime glass, melted and poured
local glass_melting = require("prototypes.recipes.glass.glass-melting")
local glass_casting = require("prototypes.recipes.glass.glass-casting")
local glazed_panel_from_molten_glass = require("prototypes.recipes.glass.glazed-panel-from-molten-glass")
local cassiterite_melting = require("prototypes.recipes.glass.cassiterite-melting")
local tin_casting = require("prototypes.recipes.glass.tin-casting")
local float_glass = require("prototypes.recipes.glass.float-glass")

-- Oxygen steelmaking: steel from the melt, with no furnace
local steel_converting = require("prototypes.recipes.steel.steel-converting")
local steel_casting = require("prototypes.recipes.steel.steel-casting")

-- Silicon refining: wafers pulled from the melt
local silica_reduction = require("prototypes.recipes.silicon.silica-reduction")
local silicon_wafer_pulling = require("prototypes.recipes.silicon.silicon-wafer-pulling")

-- Nitric acid: nitrogen out of air, burnt in an arc, and what it nitrates
local nitrogen_adsorption = require("prototypes.recipes.nitric-acid.nitrogen-adsorption")
local nitric_acid = require("prototypes.recipes.nitric-acid.nitric-acid")
local explosives_nitrated = require("prototypes.recipes.nitric-acid.explosives-nitrated")

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
local grass_cultivation = require("prototypes.recipes.wood.grass-cultivation")

-- Water Condenser recipes
local water_condenser = require("prototypes.recipes.water-condenser")
local quench_pit = require("prototypes.recipes.quench-pit")
local pug_mill = require("prototypes.recipes.pug-mill")
local adobe_bricks = require("prototypes.recipes.adobe.adobe-bricks")
local adobe_bricks_reinforced = require("prototypes.recipes.adobe.adobe-bricks-reinforced")
local steam_condensing = require("prototypes.recipes.water.steam-condensing")

-- Ethanol recipes
local fermentation_tank = require("prototypes.recipes.fermentation-tank")
local distillation_column = require("prototypes.recipes.distillation-column")
local fuel_plant = require("prototypes.recipes.fuel-plant")
local island_link_pole = require("prototypes.recipes.island-link-pole")
local train_factory = require("prototypes.recipes.train-factory")
local straw_fermentation = require("prototypes.recipes.ethanol.straw-fermentation")
local wood_fermentation = require("prototypes.recipes.ethanol.wood-fermentation")
local algae_fermentation = require("prototypes.recipes.ethanol.algae-fermentation")
local wash_distillation = require("prototypes.recipes.ethanol.wash-distillation")
local ethanol_synthesis = require("prototypes.recipes.ethanol.ethanol-synthesis")
local ethanol_rocket_fuel = require("prototypes.recipes.ethanol.ethanol-rocket-fuel")

-- Biogas: methane from biomass, reformed, and built back up into light oil
local straw_digesting = require("prototypes.recipes.biogas.straw-digesting")
local algae_digesting = require("prototypes.recipes.biogas.algae-digesting")
local methane_reforming = require("prototypes.recipes.biogas.methane-reforming")
local light_oil_synthesis = require("prototypes.recipes.biogas.light-oil-synthesis")

-- Bio-plastics: ethanol to ethylene, and ethylene to PVC
local ethanol_dehydration = require("prototypes.recipes.bio-plastics.ethanol-dehydration")
local plastic_bar_from_ethylene = require("prototypes.recipes.bio-plastics.plastic-bar-from-ethylene")

-- Lava Centrifuge recipes
local lava_centrifuge = require("prototypes.recipes.lava-centrifuge")
local lava_purification = require("prototypes.recipes.centrifuge.lava-purification")
local lava_purification_chlorinated = require("prototypes.recipes.centrifuge.lava-purification-chlorinated")
local rare_mineral_extraction = require("prototypes.recipes.centrifuge.rare-mineral-extraction")
local concentrated_ore_extraction = require("prototypes.recipes.centrifuge.concentrated-ore-extraction")

-- Uranium hexafluoride: fluoride from volcanic gas, and uranium enriched
-- as a gas
local fluoride_scrubbing = require("prototypes.recipes.uranium-hexafluoride.fluoride-scrubbing")
local uranium_fluorination = require("prototypes.recipes.uranium-hexafluoride.uranium-fluorination")
local uranium_hexafluoride_centrifuging = require("prototypes.recipes.uranium-hexafluoride.uranium-hexafluoride-centrifuging")

-- Module recipes
local lava_efficiency_module = require("prototypes.recipes.modules.efficiency-module")
local lava_efficiency_module_2 = require("prototypes.recipes.modules.efficiency-module-2")
local lava_efficiency_module_3 = require("prototypes.recipes.modules.efficiency-module-3")
local lava_speed_module = require("prototypes.recipes.modules.speed-module")
local lava_speed_module_2 = require("prototypes.recipes.modules.speed-module-2")
local lava_speed_module_3 = require("prototypes.recipes.modules.speed-module-3")
local microchip_speed_module = require("prototypes.recipes.modules.microchip-speed-module")
local microchip_efficiency_module = require("prototypes.recipes.modules.microchip-efficiency-module")
local microchip_productivity_module = require("prototypes.recipes.modules.microchip-productivity-module")

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
    microchip_speed_module,
    microchip_efficiency_module,
    microchip_productivity_module,
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
    -- Slag and crystal recipes
    lava_slag_skimming,
    crystal_growing,
    magnetite_growing,
    cassiterite_growing,
    diamond_depositing,
    pyrite_crushing,
    olivine_crushing,
    ruby_crushing,
    sapphire_crushing,
    diamond_crushing,
    crystal_circuit_board,
    -- Laser recipes
    quartz_melting,
    quartz_lens,
    laser_cutter,
    silicon_wafer_cutting,
    sapphire_substrate_cutting,
    solar_panel_from_wafers,
    sapphire_processing_unit,
    -- Chip recipes
    tin_plate,
    laser_source,
    lithography_machine,
    microchip,
    microchip_processing_unit,
    neon_extraction,
    laser_source_neon,
    -- Magnetics recipes
    coil_winder,
    magnetic_coil,
    ferrite_magnet,
    ferrofluid,
    transformer,
    -- Magma power recipes
    magma_cell,
    salt_melting,
    molten_salt_cooling,
    magma_reactor,
    magma_turbine,
    -- Lime recipes
    lava_slag_leaching,
    coal_combustion,
    limestone_carbonation,
    limestone_calcination,
    lime_slaking,
    lime_mortar,
    lime_concrete,
    -- Volcanic gas recipes
    lava_degassing,
    volcanic_gas_fractionation,
    sulfur_recovering,
    sulfur_prilling,
    sulfuric_acid_from_sulfur_dioxide,
    sulfur_concrete,
    -- Chlor-alkali recipes
    brine_leaching,
    brine_electrolysis,
    hydrochloric_acid,
    ferric_chloride,
    advanced_circuit_etched,
    magnetite_precipitation,
    -- Glass recipes
    glass_melting,
    glass_casting,
    glazed_panel_from_molten_glass,
    cassiterite_melting,
    tin_casting,
    float_glass,
    -- Steel recipes
    steel_converting,
    steel_casting,
    -- Silicon recipes
    silica_reduction,
    silicon_wafer_pulling,
    -- Nitric acid recipes
    nitrogen_adsorption,
    nitric_acid,
    explosives_nitrated,
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
    grass_cultivation,
    -- Water Condenser recipes
    water_condenser,
    quench_pit,
    pug_mill,
    adobe_bricks,
    adobe_bricks_reinforced,
    steam_condensing,
    -- Ethanol recipes
    fermentation_tank,
    distillation_column,
    fuel_plant,
    island_link_pole,
    train_factory,
    straw_fermentation,
    wood_fermentation,
    algae_fermentation,
    wash_distillation,
    ethanol_synthesis,
    ethanol_rocket_fuel,
    -- Biogas recipes
    straw_digesting,
    algae_digesting,
    methane_reforming,
    light_oil_synthesis,
    -- Bio-plastic recipes
    ethanol_dehydration,
    plastic_bar_from_ethylene,
    -- Lava Centrifuge recipes
    lava_centrifuge,
    lava_purification,
    lava_purification_chlorinated,
    rare_mineral_extraction[1],
    concentrated_ore_extraction,
    -- Uranium hexafluoride recipes
    fluoride_scrubbing,
    uranium_fluorination,
    uranium_hexafluoride_centrifuging,
    -- Modified base recipes (Nauvis only)
    sulfur_lava,
    -- Vulcanus-specific recipes
    explosives_from_lava,
})

-- The arc furnace lines. Required inline rather than through locals: a Lua
-- chunk holds at most 200 locals, and this file had reached it.
data:extend({
    -- The arc furnace, and steel melted in it
    require("prototypes.recipes.arc-furnace"),
    require("prototypes.recipes.arc-smelting.steel-arc-smelting"),
    -- Sulfide ores: lead and zinc grown on the crystal hearth, smelted to melt
    -- and cast
    require("prototypes.recipes.sulfide-ores.galena-growing"),
    require("prototypes.recipes.sulfide-ores.sphalerite-growing"),
    require("prototypes.recipes.sulfide-ores.galena-smelting"),
    require("prototypes.recipes.sulfide-ores.sphalerite-smelting"),
    require("prototypes.recipes.sulfide-ores.lead-casting"),
    require("prototypes.recipes.sulfide-ores.zinc-casting"),
    -- Alloy steels: nickel, chromium and manganese, and the steels made with them
    require("prototypes.recipes.alloy-steels.pentlandite-growing"),
    require("prototypes.recipes.alloy-steels.pentlandite-smelting"),
    require("prototypes.recipes.alloy-steels.chromite-growing"),
    require("prototypes.recipes.alloy-steels.chromite-smelting"),
    require("prototypes.recipes.alloy-steels.manganese-smelting"),
    require("prototypes.recipes.alloy-steels.manganese-casting"),
    require("prototypes.recipes.alloy-steels.molten-stainless-steel"),
    require("prototypes.recipes.alloy-steels.stainless-steel-casting"),
    require("prototypes.recipes.alloy-steels.molten-manganese-steel"),
    require("prototypes.recipes.alloy-steels.manganese-steel-casting"),
    require("prototypes.recipes.alloy-steels.molten-nichrome"),
    require("prototypes.recipes.alloy-steels.nichrome-wire"),
    -- Copper alloys: brass, bronze, and solder of tin and lead
    require("prototypes.recipes.copper-alloys.molten-brass"),
    require("prototypes.recipes.copper-alloys.brass-casting"),
    require("prototypes.recipes.copper-alloys.molten-bronze"),
    require("prototypes.recipes.copper-alloys.bronze-casting"),
    require("prototypes.recipes.copper-alloys.molten-solder"),
    require("prototypes.recipes.copper-alloys.solder"),
    -- Light metals: aluminium and magnesium won by electricity, and duralumin
    require("prototypes.recipes.light-metals.alumina-leaching"),
    require("prototypes.recipes.light-metals.aluminium-smelting"),
    require("prototypes.recipes.light-metals.magnesium-electrolysis"),
    require("prototypes.recipes.light-metals.magnesium-casting"),
    require("prototypes.recipes.light-metals.molten-duralumin"),
    require("prototypes.recipes.light-metals.duralumin-casting"),
    -- Boron: borax out of brine, and boron out of borax with magnesium
    require("prototypes.recipes.boron.borax-crystallizing"),
    require("prototypes.recipes.boron.boron-reduction"),
    -- Titanium: ilmenite chlorinated, reduced with sodium, and alloyed
    require("prototypes.recipes.titanium.ilmenite-growing"),
    require("prototypes.recipes.titanium.ilmenite-chlorination"),
    require("prototypes.recipes.titanium.sodium-electrolysis"),
    require("prototypes.recipes.titanium.titanium-reduction"),
    require("prototypes.recipes.titanium.aluminium-casting"),
    require("prototypes.recipes.titanium.vanadium-smelting"),
    require("prototypes.recipes.titanium.vanadium-casting"),
    require("prototypes.recipes.titanium.molten-titanium-alloy"),
    require("prototypes.recipes.titanium.titanium-alloy-casting"),
    -- Rare earths: monazite out of purified lava, cracked in acid, and magnets
    require("prototypes.recipes.rare-earths.monazite-separating"),
    require("prototypes.recipes.rare-earths.monazite-cracking"),
    require("prototypes.recipes.alloy-steels.nickel-casting"),
    require("prototypes.recipes.rare-earths.neodymium-magnet"),
    -- Superalloys: cobalt out of pentlandite, and the nickel superalloy
    require("prototypes.recipes.superalloys.pentlandite-leaching"),
    require("prototypes.recipes.superalloys.molten-superalloy"),
    require("prototypes.recipes.superalloys.superalloy-casting"),
    -- Precious metals: copper refined, and its slime parted with acids
    require("prototypes.recipes.precious-metals.copper-electrorefining"),
    require("prototypes.recipes.precious-metals.anode-slime-refining"),
    -- Ammonia: Haber-Bosch, Ostwald, and nitrous oxide
    require("prototypes.recipes.ammonia.ammonia-synthesis"),
    require("prototypes.recipes.ammonia.nitric-acid-from-ammonia"),
    require("prototypes.recipes.ammonia.nitrous-oxide"),
    -- Fertiliser: potash out of brine, NPK, and what it grows
    require("prototypes.recipes.fertilizer.potash-crystallizing"),
    require("prototypes.recipes.fertilizer.fertilizer"),
    require("prototypes.recipes.fertilizer.tree-cultivation-fertilized"),
    require("prototypes.recipes.fertilizer.algae-green-fertilized"),
    -- Noble gases: krypton and xenon out of liquid air
    require("prototypes.recipes.noble-gases.rare-gas-fractionation"),
    -- Gas lasers: radon off uranium ore, helium out of the radon, and the laser's fill
    require("prototypes.recipes.gas-lasers.radon-emanation"),
    require("prototypes.recipes.gas-lasers.radon-decaying"),
    require("prototypes.recipes.gas-lasers.helium-neon"),
    -- Excimer lasers: fluorine out of hydrofluoric acid, and krypton fluoride
    require("prototypes.recipes.excimer-lasers.fluorine-electrolysis"),
    require("prototypes.recipes.excimer-lasers.excimer-gas"),
    require("prototypes.recipes.excimer-lasers.laser-source-excimer"),
    -- Ozone: oxygen through a silent discharge
    require("prototypes.recipes.ozone.oxygen-ozonizing"),
    -- Gas fractionation: propane and ethane out of petroleum gas, and ethane cracked
    require("prototypes.recipes.gas-fractionation.petroleum-gas-fractionation"),
    require("prototypes.recipes.gas-fractionation.ethane-cracking"),
    -- Calcium carbide: fused in the arc furnace, acetylene from it, and PVC
    require("prototypes.recipes.calcium-carbide.calcium-carbide"),
    require("prototypes.recipes.calcium-carbide.acetylene-generation"),
    require("prototypes.recipes.calcium-carbide.plastic-bar-from-acetylene"),
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

-- Modified base recipe: the solar panel needs the crystallizer line.
require("prototypes.recipes.solar-panel")

-- Modified base recipes: motors, substations and generators are built from
-- magnets, coils and transformers.
require("prototypes.recipes.electric-engine-unit")
require("prototypes.recipes.substation")
require("prototypes.recipes.steam-turbine")

-- Modified base recipes: metals and alloys from the arc furnace lines.
require("prototypes.recipes.battery")
require("prototypes.recipes.heat-exchanger")
require("prototypes.recipes.nuclear-reactor")
require("prototypes.recipes.electric-furnace")
require("prototypes.recipes.tank")
require("prototypes.recipes.processing-unit")
require("prototypes.recipes.cannon-shell")
require("prototypes.recipes.express-transport-belt")
require("prototypes.recipes.low-density-structure")
require("prototypes.recipes.exoskeleton-equipment")
require("prototypes.recipes.power-armor-mk2")
require("prototypes.recipes.thruster")
require("prototypes.recipes.rocket-fuel")
require("prototypes.recipes.lubricant")
