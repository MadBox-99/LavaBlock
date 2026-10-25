-- Leaching bacteria: the acid-loving strains that live in mine drainage
-- and eat sulfur and iron for a living, oxidising a sulfide ore round the
-- metal locked in it until the metal goes into solution. The bioleaching
-- reactor runs on them.
--
-- Twenty minutes before a culture dies off to spoilage, against Space
-- Age's one minute for its iron and copper bacteria. Those turn into ore
-- and are meant to be used where they grow; these are meant to travel - a
-- rocket from Gleba to the island's slag makes it in time, a warehouse of
-- them does not.
--
-- Next to Space Age's own bacteria in the agriculture row.
local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")

local GFX = "__LavaBlock-graphics__/graphics/icons/items/"

return {
    type = "item",
    name = "leaching-bacteria",
    icon = GFX .. "leaching-bacteria.png",
    icon_size = 64,
    pictures = {
        { size = 64, filename = GFX .. "leaching-bacteria.png",   scale = 0.5, mipmap_count = 4 },
        { size = 64, filename = GFX .. "leaching-bacteria-1.png", scale = 0.5, mipmap_count = 4 },
        { size = 64, filename = GFX .. "leaching-bacteria-2.png", scale = 0.5, mipmap_count = 4 },
        { size = 64, filename = GFX .. "leaching-bacteria-3.png", scale = 0.5, mipmap_count = 4 },
    },
    subgroup = "agriculture-processes",
    order = "b[agriculture]-d[bacteria]-c[leaching-bacteria]",
    inventory_move_sound = space_age_item_sounds.agriculture_inventory_move,
    pick_sound = space_age_item_sounds.agriculture_inventory_pickup,
    drop_sound = space_age_item_sounds.agriculture_inventory_move,
    stack_size = 50,
    weight = 1 * kg,
    spoil_ticks = 20 * minute,
    spoil_result = "spoilage",
}
