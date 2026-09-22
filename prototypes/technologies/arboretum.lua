-- The arboretum replaces the placeholder that made wood out of nothing, so
-- this technology has to hand the player everything the new loop needs:
--
--  * tree-cultivation, the growing half
--  * wood-processing, the seeding half. Space Age puts that behind
--    tree-seeding, which needs agricultural science from Gleba - unreachable
--    from a lava island, and far too late for something steam generation
--    depends on. Same reasoning as steam-condensation under calcite
--    processing.
--  * a handful of seeds. Without them, researching this would strand a player
--    who happened to be out of wood: no wood means no seeds, and no seeds
--    means no wood. Twenty seeds is eight hundred kilograms of restart.
return {
    type = "technology",
    name = "arboretum",
    icon = "__LavaBlock__/graphics/technology/arboretum.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "grow-lamp" },
        { type = "unlock-recipe", recipe = "arboretum" },
        { type = "unlock-recipe", recipe = "tree-cultivation" },
        { type = "unlock-recipe", recipe = "wood-processing" },
        { type = "give-item",     item = "tree-seed", count = 20 },
        {
            type = "nothing",
            effect_description = {
                "technology-effect.disable-recipe",
                "wood-extraction",
                { "recipe-name.wood-extraction" }
            }
        },
    },
    -- lava-crystallization is new in front of this one: the glasshouse is
    -- walled in glazed panels now, so the hearth that makes glass has to
    -- come first. It is a cheap research placed deliberately early.
    prerequisites = {
        "calcite-processing-on-lava-block",
        "logistic-science-pack",
        "lava-crystallization",
    },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-e"
}
