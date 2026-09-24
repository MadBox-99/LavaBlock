-- The pressing half. Growing and pressing are different jobs done by
-- different buildings, so they are now different technologies too: this one
-- used to hand over both machines and six recipes at once, which is more
-- than any single research in the mod gives and left the player with a tank
-- and a garden and no idea which came first.
--
-- [algae-cultivation] raises the culture; this presses it for what it grew
-- on. It is researched second because there is nothing to press until the
-- tank is running.
return {
    type = "technology",
    name = "bio-garden",
    icon = "__LavaBlock-graphics__/graphics/technology/bio-garden.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "bio-garden" },
        { type = "unlock-recipe", recipe = "algae-fibre-pressing" },
        { type = "unlock-recipe", recipe = "calcite-precipitation" },
    },
    prerequisites = { "algae-cultivation" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-f"
}
