-- Two rows in the intermediate tab for the slag lines, straight after the
-- raw materials they are made from.
--
-- Their own rows because both are chains: six crystals with their crushing
-- recipes, and lime from slag to concrete in seven steps. Poured into
-- raw-resource beside basalt they would be a dozen unrelated icons; in rows
-- of their own the crafting menu reads in the order the factory is built.
data:extend({
    {
        type = "item-subgroup",
        name = "lava-block-crystals",
        group = "intermediate-products",
        order = "c-b"
    },
    {
        type = "item-subgroup",
        name = "lava-block-lime",
        group = "intermediate-products",
        order = "c-c"
    },
})
