-- Cut grass, dried. It exists for one recipe - the straw in straw adobe -
-- which until now took a whole log of wood, as if the brickmaker chopped a
-- tree into the mud. Grass is what real adobe is made with, and growing it
-- is a different job from growing timber, so it is its own item.
return {
    type = "item",
    name = "straw",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/straw.png",
    icon_size = 64,
    subgroup = "raw-resource",
    order = "a[wood]-b[straw]",
    stack_size = 100,
    weight = 1 * kg,
}
