-- NMC cathode: aluminium foil coated with lithium nickel manganese cobalt
-- oxide, the cathode of most lithium-ion cells made today. Nickel, manganese
-- and cobalt in equal parts - NMC 111 - and every one of them a metal the
-- island already smelts.
--
-- Beside lithium plate in the Aquilo row, because the lithium is what it
-- is for.
return {
    type = "item",
    name = "nmc-cathode",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/nmc-cathode.png",
    icon_size = 64,
    subgroup = "aquilo-processes",
    order = "c[lithium]-c[nmc-cathode]",
    stack_size = 100,
    weight = 1 * kg,
}
