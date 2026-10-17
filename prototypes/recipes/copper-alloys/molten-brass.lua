-- Molten copper with zinc plate dropped into it, seven to three. Zinc
-- boils away below copper's melting point, so brass has always been made
-- by putting solid zinc into molten copper, not by running two melts
-- together.
--
-- The copper is the island's own molten copper from lava smelting, so a
-- brass line stands next to the copper smelters rather than next to the
-- furnaces.
return {
    type = "recipe",
    name = "molten-brass",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "zinc-plate",    amount = 3 },
        { type = "fluid", name = "molten-copper", amount = 70 },
    },
    results = {
        { type = "fluid", name = "molten-brass", amount = 100, fluidbox_index = 1 },
    },
    allow_productivity = true,
    subgroup = "fluid-recipes",
    order = "n[alloy]-d[molten-brass]",
}
