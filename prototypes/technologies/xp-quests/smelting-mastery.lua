-- Smelting Mastery Quest Technologies
-- Provides productivity bonus to iron and copper smelting

local smelting_mastery = {}

-- Quest progression: increasing craft requirements
local quests = {
    { level = 1, count = 500, bonus = 0.05 },
    { level = 2, count = 2000, bonus = 0.05 },
    { level = 3, count = 5000, bonus = 0.05 },
    { level = 4, count = 10000, bonus = 0.05 },
    { level = 5, count = 20000, bonus = 0.05 },
}

for i, quest in ipairs(quests) do
    smelting_mastery[i] = {
        type = "technology",
        name = "smelting-mastery-" .. quest.level,
        icon = "__base__/graphics/icons/iron-plate.png",
        icon_size = 64,
        effects = {
            {
                type = "change-recipe-productivity",
                recipe = "iron-plate",
                change = quest.bonus
            },
            {
                type = "change-recipe-productivity",
                recipe = "copper-plate",
                change = quest.bonus
            },
        },
        unit = {
            count = 15 * quest.level,
            ingredients = {
                { "xp-science-pack", 1 }
            },
            time = 30
        },
        prerequisites = quest.level == 1
            and { "xp-lab" }
            or { "smelting-mastery-" .. (quest.level - 1) },
        upgrade = true,
        order = "e-p-b-s-" .. quest.level,
    }
end

data:extend(smelting_mastery)
