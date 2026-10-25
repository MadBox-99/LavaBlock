-- Shredded circuit boards: what is left of the scrap once the eddy current
-- separator has thrown the loose metal out of it. Glass fibre and resin
-- with copper tracks, solder joints and gold-plated contacts all through
-- it - poorer in copper than the metal fraction and far richer in silver,
-- gold and platinum than any ore.
--
-- Beside scrap in the Fulgora row, because it is a cut of the scrap.
return {
    type = "item",
    name = "e-waste",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/e-waste.png",
    icon_size = 64,
    subgroup = "fulgora-processes",
    order = "a[scrap]-b[e-waste]",
    stack_size = 50,
    weight = 2 * kg,
}
