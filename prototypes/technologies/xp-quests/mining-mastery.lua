-- Mining Mastery Quest Technologies
-- Rewards the player directly: faster character mining speed, making it easier
-- to tear down and rearrange the factory in the restricted early game.
-- Fed by XP Science Packs, which are themselves earned by hand-crafting.

local mining_mastery = {}

-- Quest progression: increasing XP cost, flat mining-speed bonus per level
local quests = {
    { level = 1, count = 10,  bonus = 0.2 },
    { level = 2, count = 20,  bonus = 0.2 },
    { level = 3, count = 40,  bonus = 0.2 },
    { level = 4, count = 80,  bonus = 0.2 },
    { level = 5, count = 160, bonus = 0.2 },
}

for i, quest in ipairs(quests) do
    mining_mastery[i] = {
        type = "technology",
        name = "mining-mastery-" .. quest.level,
        icon = "__base__/graphics/icons/electric-mining-drill.png",
        icon_size = 64,
        effects = {
            {
                type = "character-mining-speed",
                modifier = quest.bonus
            },
        },
        unit = {
            count = quest.count,
            ingredients = {
                { "xp-science-pack", 1 }
            },
            time = 30
        },
        prerequisites = quest.level == 1
            and { "xp-lab" }
            or { "mining-mastery-" .. (quest.level - 1) },
        upgrade = true,
        order = "e-p-b-m-" .. quest.level,
    }
end

data:extend(mining_mastery)
