-- The vanilla processing unit, soldered. Vanilla builds it from circuits
-- and acid alone; the chips on a real board are held on by solder, and a
-- processing unit is twenty circuits and two advanced circuits joined into
-- one.
--
-- One reel of solder a unit, three fifths of a tin plate and two fifths of
-- a lead. The two alternative recipes, which make their processing units
-- two at a time out of fewer parts, take one reel for the pair: half the
-- joints, half the solder.
local utils = require("lib.utils")

local SOLDER = { type = "item", name = "solder", amount = 1 }

for _, name in pairs({ "processing-unit", "microchip-processing-unit", "sapphire-processing-unit" }) do
    local recipe = data.raw.recipe[name]
    if recipe then
        table.insert(recipe.ingredients, table.deepcopy(SOLDER))
    end
end

-- Solder comes from Brass, bronze and solder.
utils.add_tech_prereq("processing-unit", "copper-alloys")

-- The vanilla unit's boards are washed in ozone where vanilla washes them
-- in sulfuric acid: ozone in water strips the last organic film off a
-- wafer and leaves nothing behind but oxygen, which is how chip fabs have
-- cleaned since the 1990s. Five ozone for the five acid. The two
-- alternative recipes keep their acid - the microchip and the sapphire
-- substrate are cleaned before they reach the assembler.
for _, ingredient in pairs(data.raw.recipe["processing-unit"].ingredients) do
    if ingredient.name == "sulfuric-acid" then
        ingredient.name = "ozone"
    end
end

-- Ozone comes from Ozone generation.
utils.add_tech_prereq("processing-unit", "ozone-generation")
