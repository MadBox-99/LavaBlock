-- The isostatic press, the cemented carbide it sinters, and the studded
-- crusher rolls the carbide is set in. Vulcanus's machine.
--
-- A research trigger, as the foundry is: fifty tungsten carbide made, which
-- is a player on Vulcanus with the carbide line running. It has to be a
-- trigger, because the big mining drill is now built of cemented carbide
-- and metallurgic science waits on the big drill; a press that needed
-- metallurgic science would close the loop.
--
-- After Tungsten carbide for the carbide, Superalloys for the cobalt and
-- for the furnace inside the vessel, Shielded crystallization for the argon
-- and Lubricated rock crushing for the industrial crusher the studded rolls
-- go into. All three of those are the island's, researched before the
-- player ever leaves it.
return {
    type = "technology",
    name = "hot-isostatic-pressing",
    icon = "__LavaBlock-graphics__/graphics/technology/hot-isostatic-pressing.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "isostatic-press" },
        { type = "unlock-recipe", recipe = "cemented-carbide" },
        { type = "unlock-recipe", recipe = "gravel-grinding-studded" },
    },
    prerequisites = {
        "tungsten-carbide", "superalloys", "shielded-crystallization",
        "lubricated-rock-crushing",
    },
    research_trigger = {
        type = "craft-item",
        item = "tungsten-carbide",
        count = 50,
    },
    order = "a-v-a",
}
