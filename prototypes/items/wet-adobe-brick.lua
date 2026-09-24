-- A brick that has been formed but not dried. It is not a spoiling food and
-- the timer is not decay - it is the drying yard, done with the one mechanic
-- Factorio has for "this becomes that after a while wherever it is standing".
-- The mod already uses it for uranium bacteria, so the tooltip ("Spoils into
-- Stone brick") is a form the player has met here before.
--
-- Two minutes is chosen against the Pug Mill's own rate rather than picked
-- for feel. The mill turns out a batch every four seconds, so at steady
-- state thirty batches are drying at any moment; that will not fit in the
-- machine's output slot, which is the point. The player has to build
-- somewhere to put them, and that buffer is the whole price of skipping the
-- furnace. A shorter timer and the buffer disappears, along with the cost.
local wet_adobe_brick = {
    type = "item",
    name = "wet-adobe-brick",
    -- Clay brown over the vanilla brick, so it is plainly the same object in
    -- a different state and plainly not the finished one. A tint multiplies
    -- the whole layer, which is fine here: there is no metal collar to
    -- preserve, only stone that should read as wet earth.
    icons = {
        {
            icon = "__base__/graphics/icons/stone-brick.png",
            icon_size = 64,
            tint = { r = 0.78, g = 0.53, b = 0.33 },
        },
    },
    subgroup = "raw-resource",
    order = "a[basalt]-f[wet-adobe-brick]",
    stack_size = 100,
    weight = 2 * kg,
    spoil_ticks = 2 * minute,
    spoil_result = "stone-brick",
}

return wet_adobe_brick
