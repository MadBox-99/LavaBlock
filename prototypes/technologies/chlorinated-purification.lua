-- The chlorine line: a gas the mod has carried since the beginning without
-- a single recipe able to make it, and the use that finally justifies it.
--
-- Sits behind the centrifuge, because there is nothing to chlorinate until
-- you are purifying lava, and behind sulfur processing, because scrubbing
-- a volcanic vent for one of its acid gases is the same trade you already
-- learned making sulfur out of lava.
return {
    type = "technology",
    name = "chlorinated-purification",
    -- Layered rather than rendered, the way Oxygen Processing and Nitrogen
    -- Fixation are: this technology hands over two recipes and no machine,
    -- and a product shot of a building it does not unlock would be a lie.
    icons = {
        {
            icon = "__base__/graphics/technology/uranium-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock__/graphics/icons/gas/chlorine.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "volcanic-gas-scrubbing" },
        { type = "unlock-recipe", recipe = "lava-purification-chlorinated" },
    },
    prerequisites = { "lava-centrifuge", "sulfur-processing" },
    unit = {
        count = 400,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       2 },
        },
        time = 30
    },
    order = "e-p-b-c-a"
}
