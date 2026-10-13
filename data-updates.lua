local utils = require("lib.utils")

data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["coal"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["stone"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["uranium-ore"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["iron-ore"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["copper-ore"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["crude-oil"] = nil
data.raw["fluid"]["lava"].fuel_value = "25kJ"
-- Assembling machine 3 also runs smelting, chemistry and gas recipes.
-- Appended rather than assigned, so categories another mod gave it survive.
local assembler_3_categories = data.raw["assembling-machine"]["assembling-machine-3"].crafting_categories
for _, category in pairs({ "smelting", "chemistry", "gas" }) do
    local present = false
    for _, existing in pairs(assembler_3_categories) do
        if existing == category then present = true end
    end
    if not present then
        table.insert(assembler_3_categories, category)
    end
end

table.insert(data.raw["technology"]["bacteria-cultivation"].effects, {
    type = "unlock-recipe",
    recipe = "uranium-bacteria-cultivation"
})

table.insert(data.raw["technology"]["jellynut"].effects, {
    type = "unlock-recipe",
    recipe = "uranium-bacteria"
})

-- Space Age: Replace asteroid-productivity with separate simple and advanced versions
if mods["space-age"] then
    -- Remove the original asteroid-productivity technology completely
    utils.remove_technology("asteroid-productivity")
end

-- Pyroclast integration: when Pyroclast mod is installed, swap its standalone
-- science packs with LavaBlock's custom packs for deeper integration
if mods["Pyroclast"] then
    -- planet-discovery-pyroclast: metallurgic-science-pack(1) → lava-science-pack(3)
    utils.replace_tech_ingredient("planet-discovery-pyroclast", "metallurgic-science-pack", "lava-science-pack", 3)

    -- pyroclast-science-pack: metallurgic-science-pack(3) → lava-science-pack(5)
    -- prereqs: military-science-pack → military-science-pack-2, add lava-science-pack
    -- (it took the enchanted science pack too, until that pack was removed; the
    -- lava pack came in behind it as a prerequisite and is now asked for directly)
    utils.replace_tech_ingredient("pyroclast-science-pack", "metallurgic-science-pack", "lava-science-pack", 5)
    utils.replace_tech_prereq("pyroclast-science-pack", "military-science-pack", "military-science-pack-2")
    utils.add_tech_prereq("pyroclast-science-pack", "lava-science-pack")

    -- pyroclast-materials, explosives, refined: metallurgic-science-pack(1) → lava-science-pack(3)
    utils.replace_tech_ingredient("pyroclast-materials", "metallurgic-science-pack", "lava-science-pack", 3)
    utils.replace_tech_ingredient("pyroclast-explosives", "metallurgic-science-pack", "lava-science-pack", 3)
    utils.replace_tech_ingredient("pyroclast-refined", "metallurgic-science-pack", "lava-science-pack", 3)

    -- pyroclast-heavy-explosives: metallurgic-science-pack(1) → lava-science-pack(3)
    utils.replace_tech_ingredient("pyroclast-heavy-explosives", "metallurgic-science-pack", "lava-science-pack", 3)

    -- pyroclast-assembly-1/2: metallurgic-science-pack(1) → lava-science-pack(3)
    utils.replace_tech_ingredient("pyroclast-assembly-1", "metallurgic-science-pack", "lava-science-pack", 3)
    utils.replace_tech_ingredient("pyroclast-assembly-2", "metallurgic-science-pack", "lava-science-pack", 3)

    -- pyroclast-assembly-3/4: metallurgic-science-pack(1) → lava-science-pack(3)
    utils.replace_tech_ingredient("pyroclast-assembly-3", "metallurgic-science-pack", "lava-science-pack", 3)
    utils.replace_tech_ingredient("pyroclast-assembly-4", "metallurgic-science-pack", "lava-science-pack", 3)

    -- pyroclast-science-pack recipe: metallurgic-science-pack → lava-science-pack ingredient
    if data.raw.recipe["pyroclast-science-pack"] then
        for i, ingredient in pairs(data.raw.recipe["pyroclast-science-pack"].ingredients) do
            if ingredient.name == "metallurgic-science-pack" then
                ingredient.name = "lava-science-pack"
                break
            end
        end
    end
end
