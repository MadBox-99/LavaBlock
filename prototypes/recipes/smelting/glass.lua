-- Crystal back into melt, and this time not allowed to grow again.
--
-- Physically the whole point: glass is quartz that was cooled too fast to
-- crystallise. The hearth next door spends eight seconds making sure it
-- does crystallise, and a furnace undoes that in three - which is why these
-- are two machines and not one recipe with a switch.
--
-- Plain "smelting", so a stone furnace can do it. Nothing about melting
-- sand wants a dedicated building, and the player already has a smelting
-- column by the time glass matters.
return {
    type = "recipe",
    name = "glass",
    categories = { "smelting" },
    subgroup = "intermediate-product",
    order = "c[glass]",
    enabled = false,
    energy_required = 3.2,
    ingredients = {
        { type = "item", name = "silica-crystal", amount = 2 },
    },
    results = {
        { type = "item", name = "glass", amount = 1 }
    },
    allow_productivity = true,
    -- Glass recycles into glass, as a plate does. Recycled back into a
    -- quarter of the two crystals it took, glass from the melt - a crystal
    -- each, and less again on the tin bath - made more crystal than went
    -- in once legendary productivity modules were in the refinery and the
    -- caster.
    auto_recycle = false,
}
