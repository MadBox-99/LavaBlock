data:extend({
    require("prototypes.fluids.liquid-nitrogen"),
    require("prototypes.fluids.gases.argon"),
    require("prototypes.fluids.gases.air"),
    require("prototypes.fluids.gases.compressed-air"),
    require("prototypes.fluids.gases.chlorine"),
    require("prototypes.fluids.purified-lava"),
})

-- Space Age only fluids
if mods["space-age"] then
    data:extend({
        require("prototypes.fluids.liquid-tungsten"),
    })
end