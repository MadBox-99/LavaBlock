-- Cemented carbide: grains of tungsten carbide held in a cobalt binder,
-- sintered and pressed until no pore is left. Pure tungsten carbide is hard
-- and brittle and shatters under a blow; the cobalt is what lets a drill
-- bit take one. Every real tool edge called "carbide" is this.
--
-- Next to tungsten carbide in the Vulcanus row, because it is made from it.
return {
    type = "item",
    name = "cemented-carbide",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/cemented-carbide.png",
    icon_size = 64,
    subgroup = "vulcanus-processes",
    order = "c[tungsten]-c[cemented-carbide]",
    stack_size = 50,
    weight = 2 * kg,
}
