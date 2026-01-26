-- Crafting Mastery Quest Technologies
-- Provides productivity bonus to iron-gear-wheel crafting

local crafting_mastery = {}

-- Quest progression: increasing craft requirements
local quests = {
    { level = 1, count = 100, bonus = 0.05 },
    { level = 2, count = 500, bonus = 0.05 },
    { level = 3, count = 2000, bonus = 0.05 },
    { level = 4, count = 5000, bonus = 0.05 },
    { level = 5, count = 10000, bonus = 0.05 },
}

for i, quest in ipairs(quests) do
    crafting_mastery[i] = {
        type = "technology",
        name = "crafting-mastery-" .. quest.level,
        icon = "__base__/graphics/icons/iron-gear-wheel.png",
        icon_size = 64,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-gear-wheel",
                change = quest.bonus
            },
        },
        unit = {
            count = 10 * quest.level,
            ingredients = {
                { "xp-science-pack", 1 }
            },
            time = 30
        },
        prerequisites = quest.level == 1
            and { "xp-lab" }
            or { "crafting-mastery-" .. (quest.level - 1) },
        upgrade = true,
        order = "e-p-b-c-" .. quest.level,
    }
end

data:extend(crafting_mastery)
