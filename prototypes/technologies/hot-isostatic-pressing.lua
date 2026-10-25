-- The isostatic press and the cemented carbide it sinters. Vulcanus's
-- machine; the carbide goes into the big mining drill's bits.
--
-- A research trigger, as the foundry is: fifty tungsten carbide made, which
-- is a player on Vulcanus with the carbide line running. It has to be a
-- trigger, because the big mining drill is now built of cemented carbide
-- and metallurgic science waits on the big drill; a press that needed
-- metallurgic science would close the loop.
--
-- After Tungsten carbide for the carbide, Superalloys for the cobalt and
-- for the furnace inside the vessel, and Shielded crystallization for the
-- argon. Both of those are the island's, researched before the player
-- ever leaves it.
--
-- Not studded crusher rolls as well. Carbide studs in the industrial
-- crusher's rolls would grind 8 stone out of 3 gravel instead of 6, but
-- that is carbide shipped back from Vulcanus and looped through a crusher
-- for two stone, the cheapest thing on the island.
return {
    type = "technology",
    name = "hot-isostatic-pressing",
    icon = "__LavaBlock-graphics__/graphics/technology/hot-isostatic-pressing.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "isostatic-press" },
        { type = "unlock-recipe", recipe = "cemented-carbide" },
    },
    prerequisites = {
        "tungsten-carbide", "superalloys", "shielded-crystallization",
    },
    research_trigger = {
        type = "craft-item",
        item = "tungsten-carbide",
        count = 50,
    },
    order = "a-v-a",
}
