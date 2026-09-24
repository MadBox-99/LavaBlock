-- The three algae the bio garden grows.
--
-- They differ in exactly one thing - what they were fed - and that is the
-- whole mechanic: each strain lives off a different solution and concentrates
-- a different substance while it grows, which is then extracted from the
-- harvested mass. Green is minerals, blue is nitrogen out of the air, red is
-- carbonate.
--
-- Icons are Space Age's spoilage clump, flattened to luminance and tinted, so
-- the three read as the same material in three strains rather than as three
-- unrelated items.
local function algae(colour, order)
    return {
        type = "item",
        name = "algae-" .. colour,
        icon = "__LavaBlock-graphics__/graphics/icons/items/algae-" .. colour .. ".png",
        icon_size = 64,
        subgroup = "raw-material",
        order = "a[algae]-" .. order .. "[algae-" .. colour .. "]",
        stack_size = 200,
    }
end

return {
    algae("green", "a"),
    algae("blue", "b"),
    algae("red", "c"),
}
