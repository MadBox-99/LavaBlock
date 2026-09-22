-- The three roll crushers, as items. Same order prefix so they sit together
-- in the crafting menu and Factoriopedia, in the order you unlock them.
local utils = require("lib.utils")

local ITEMS = {
    { "burner-roll-crusher", "f[roll-crusher]-a" },
    { "roll-crusher", "f[roll-crusher]-b" },
    { "industrial-roll-crusher", "f[roll-crusher]-c" },
}

local items = {}
for _, it in ipairs(ITEMS) do
    items[#items + 1] = {
        type = "item",
        name = it[1],
        icons = utils.badged_icon(it[1]),
        subgroup = "production-machine",
        order = it[2],
        place_result = it[1],
        stack_size = 20,
    }
end
return items
