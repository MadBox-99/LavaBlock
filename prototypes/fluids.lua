data:extend({
    require("prototypes.fluids.liquid-nitrogen"),
    require("prototypes.fluids.gases.argon"),
    require("prototypes.fluids.gases.air"),
    require("prototypes.fluids.gases.compressed-air"),
    require("prototypes.fluids.gases.oxygen"),
    require("prototypes.fluids.gases.chlorine"),
    require("prototypes.fluids.gases.shielding-gas"),
    require("prototypes.fluids.purified-lava"),
    require("prototypes.fluids.fermented-wash"),
    require("prototypes.fluids.ethanol"),
    require("prototypes.fluids.calcium-solution"),
    require("prototypes.fluids.gases.carbon-dioxide"),
    require("prototypes.fluids.molten-quartz"),
    -- The magma power loop
    require("prototypes.fluids.magma-plasma"),
    require("prototypes.fluids.molten-salt-cold"),
    require("prototypes.fluids.molten-salt-hot"),
    -- The magnetics line
    require("prototypes.fluids.ferrofluid"),
    -- The volcanic gas line
    require("prototypes.fluids.gases.volcanic-gas"),
    require("prototypes.fluids.gases.sulfur-dioxide"),
    require("prototypes.fluids.gases.hydrogen-sulfide"),
    require("prototypes.fluids.molten-sulfur"),
    -- The chlor-alkali line
    require("prototypes.fluids.brine"),
    require("prototypes.fluids.gases.hydrogen"),
    require("prototypes.fluids.sodium-hydroxide"),
    require("prototypes.fluids.hydrochloric-acid"),
    require("prototypes.fluids.ferric-chloride"),
    -- The glass line
    require("prototypes.fluids.molten-glass"),
    require("prototypes.fluids.molten-tin"),
    -- Oxygen steelmaking
    require("prototypes.fluids.molten-steel"),
    -- Silicon refining
    require("prototypes.fluids.molten-silicon"),
    -- Biogas
    require("prototypes.fluids.gases.methane"),
    require("prototypes.fluids.gases.carbon-monoxide"),
    -- Nitric acid
    require("prototypes.fluids.gases.nitrogen"),
    require("prototypes.fluids.nitric-acid"),
    -- Bio-plastics
    require("prototypes.fluids.gases.ethylene"),
    -- Gas lasers
    require("prototypes.fluids.gases.neon"),
    -- Uranium hexafluoride
    require("prototypes.fluids.hydrofluoric-acid"),
    require("prototypes.fluids.gases.uranium-hexafluoride"),
    -- The arc furnace's melts: metals as they come off the tap, and the
    -- alloys made of them
    require("prototypes.fluids.molten-lead"),
    require("prototypes.fluids.molten-zinc"),
    require("prototypes.fluids.molten-nickel"),
    require("prototypes.fluids.molten-chromium"),
    require("prototypes.fluids.molten-manganese"),
    require("prototypes.fluids.molten-stainless-steel"),
    require("prototypes.fluids.molten-manganese-steel"),
    require("prototypes.fluids.molten-nichrome"),
    require("prototypes.fluids.molten-brass"),
    require("prototypes.fluids.molten-bronze"),
    require("prototypes.fluids.molten-solder"),
    require("prototypes.fluids.molten-aluminium"),
    require("prototypes.fluids.molten-magnesium"),
    require("prototypes.fluids.molten-duralumin"),
    require("prototypes.fluids.titanium-tetrachloride"),
    require("prototypes.fluids.molten-sodium"),
    require("prototypes.fluids.molten-titanium"),
    require("prototypes.fluids.molten-vanadium"),
    require("prototypes.fluids.molten-titanium-alloy"),
    require("prototypes.fluids.molten-superalloy"),
    -- The gases of the arc furnace era
    require("prototypes.fluids.gases.nitrous-oxide"),
    require("prototypes.fluids.gases.krypton"),
    require("prototypes.fluids.gases.xenon"),
    require("prototypes.fluids.gases.radon"),
    require("prototypes.fluids.gases.helium"),
    require("prototypes.fluids.gases.helium-neon"),
})

-- Space Age only fluids
if mods["space-age"] then
    data:extend({
        require("prototypes.fluids.liquid-tungsten"),
    })
end