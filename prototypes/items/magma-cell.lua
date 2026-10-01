-- The magma reactor's fuel, as the fusion power cell is the fusion
-- reactor's: a magnetite coil to hold the melt, an olivine lining to take
-- the heat, pyrite to light it, and molten iron cast round the lot.
--
-- 40 GJ, a fusion power cell's worth. A reactor runs at 1000 MW, so it
-- burns one every 40 seconds, 90 an hour. That is the price of the power:
-- two olivine and a pyrite a cell is four crystal-growing crafts, forty
-- seconds on a crystal hearth - so every reactor keeps one hearth busy on
-- its own. At 10 GJ it was four and a half hearths a reactor, which is a
-- crystal industry to fuel one building; at 100 it would be half of one,
-- and the cell would stop costing anything worth noticing.
return {
    type = "item",
    name = "magma-cell",
    icon = "__LavaBlock-graphics__/graphics/icons/parts/magma-cell.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "z[lavablock]-k[magma-cell]",
    fuel_category = "magma",
    fuel_value = "40GJ",
    stack_size = 50,
}
