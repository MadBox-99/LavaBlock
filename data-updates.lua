data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["coal"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["stone"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["uranium-ore"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["iron-ore"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["copper-ore"] = nil
data.raw["planet"]["nauvis"]["map_gen_settings"]["autoplace_settings"]["entity"]["settings"]["crude-oil"] = nil
data.raw["fluid"]["lava"].fuel_value = "25kJ"
data.raw["assembling-machine"]["assembling-machine-3"].crafting_categories =
{
    "basic-crafting",
    "crafting",
    "advanced-crafting",
    "crafting-with-fluid",
    "electronics",
    "electronics-with-fluid",
    "pressing",
    "metallurgy-or-assembling",
    "organic-or-hand-crafting",
    "organic-or-assembling",
    "electronics-or-assembling",
    "cryogenics-or-assembling",
    "crafting-with-fluid-or-metallurgy",
    "smelting",
    "chemistry",
    "gas",
}

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
    require("helpers.functions")
    -- Remove the original asteroid-productivity technology completely
    remove_technology("asteroid-productivity")
end

-- Pyroclast integration: when Pyroclast mod is installed, swap its standalone
-- science packs with LavaBlock's custom packs for deeper integration
if mods["Pyroclast"] then
    require("helpers.functions")

    -- planet-discovery-pyroclast: metallurgic-science-pack(1) → lava-science-pack(3)
    replace_tech_ingredient("planet-discovery-pyroclast", "metallurgic-science-pack", "lava-science-pack", 3)

    -- pyroclast-science-pack: metallurgic-science-pack(3) → lava-science-pack(5)
    -- prereqs: military-science-pack → military-science-pack-2, add lava-science-pack
    -- (it took the enchanted science pack too, until that pack was removed; the
    -- lava pack came in behind it as a prerequisite and is now asked for directly)
    replace_tech_ingredient("pyroclast-science-pack", "metallurgic-science-pack", "lava-science-pack", 5)
    replace_tech_prereq("pyroclast-science-pack", "military-science-pack", "military-science-pack-2")
    add_tech_prereq("pyroclast-science-pack", "lava-science-pack")

    -- pyroclast-materials, explosives, refined: metallurgic-science-pack(1) → lava-science-pack(3)
    replace_tech_ingredient("pyroclast-materials", "metallurgic-science-pack", "lava-science-pack", 3)
    replace_tech_ingredient("pyroclast-explosives", "metallurgic-science-pack", "lava-science-pack", 3)
    replace_tech_ingredient("pyroclast-refined", "metallurgic-science-pack", "lava-science-pack", 3)

    -- pyroclast-heavy-explosives: metallurgic-science-pack(1) → lava-science-pack(3)
    replace_tech_ingredient("pyroclast-heavy-explosives", "metallurgic-science-pack", "lava-science-pack", 3)

    -- pyroclast-assembly-1/2: metallurgic-science-pack(1) → lava-science-pack(3)
    replace_tech_ingredient("pyroclast-assembly-1", "metallurgic-science-pack", "lava-science-pack", 3)
    replace_tech_ingredient("pyroclast-assembly-2", "metallurgic-science-pack", "lava-science-pack", 3)

    -- pyroclast-assembly-3/4: metallurgic-science-pack(1) → lava-science-pack(3)
    replace_tech_ingredient("pyroclast-assembly-3", "metallurgic-science-pack", "lava-science-pack", 3)
    replace_tech_ingredient("pyroclast-assembly-4", "metallurgic-science-pack", "lava-science-pack", 3)

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
