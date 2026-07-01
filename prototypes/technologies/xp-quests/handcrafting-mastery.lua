-- Handcrafting Mastery Quest Technologies
-- Rewards the player directly: faster character (hand) crafting speed.
-- Fed by XP Science Packs, which are themselves earned by hand-crafting.

local handcrafting_mastery = {}

-- Quest progression: increasing XP cost, flat crafting-speed bonus per level
local quests = {
    { level = 1, count = 10,  bonus = 0.3 },
    { level = 2, count = 20,  bonus = 0.3 },
    { level = 3, count = 40,  bonus = 0.3 },
    { level = 4, count = 80,  bonus = 0.3 },
    { level = 5, count = 160, bonus = 0.3 },
}

for i, quest in ipairs(quests) do
    handcrafting_mastery[i] = {
        type = "technology",
        name = "handcrafting-mastery-" .. quest.level,
        icon = "__base__/graphics/icons/repair-pack.png",
        icon_size = 64,
        effects = {
            {
                type = "character-crafting-speed",
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
            or { "handcrafting-mastery-" .. (quest.level - 1) },
        upgrade = true,
        order = "e-p-b-h-" .. quest.level,
    }
end

data:extend(handcrafting_mastery)
