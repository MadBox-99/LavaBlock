-- A lithium-ion cell: NMC cathode and graphite anode wound with a
-- separator into a jelly roll, sealed in a can with electrolyte and charged
-- once. The battery a robot or a suit of armour should have had all along;
-- the island's own battery is lead and acid.
--
-- Next to the cathode it is made from.
return {
    type = "item",
    name = "lithium-ion-cell",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/lithium-ion-cell.png",
    icon_size = 64,
    subgroup = "aquilo-processes",
    order = "c[lithium]-d[lithium-ion-cell]",
    stack_size = 100,
    weight = 2 * kg,
}
