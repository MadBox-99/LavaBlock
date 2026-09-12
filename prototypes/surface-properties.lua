-- Custom surface properties for LavaBlock.
--
-- `lava-block-lava-ocean` marks the LavaBlock version of Nauvis (the lava-ocean
-- skyblock world). Every other surface -- including planets added by other mods,
-- present and future, and space platforms -- gets the default value 0, because
-- that is what `default_value` means for a surface property.
--
-- This lets recipes be restricted to "the LavaBlock world" or "everywhere else"
-- with a single condition, instead of fingerprinting each planet by its exact
-- pressure/gravity pair (which silently excludes every planet not on the list).

data:extend({
    {
        type = "surface-property",
        name = "lava-block-lava-ocean",
        default_value = 0,
        -- Internal marker, not a property players need to reason about.
        hidden = true,
        localised_name = { "lava-block.surface-property-lava-ocean" }
    }
})
