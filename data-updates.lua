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
    -- Helper: replace a science pack ingredient in a technology's unit
    local function replace_tech_ingredient(tech_name, old_pack, new_pack, new_count)
        local tech = data.raw.technology[tech_name]
        if not tech or not tech.unit or not tech.unit.ingredients then return end
        for i, ingredient in pairs(tech.unit.ingredients) do
            if ingredient[1] == old_pack then
                ingredient[1] = new_pack
                if new_count then ingredient[2] = new_count end
                return
            end
        end
        -- If old_pack not found, add new_pack
        table.insert(tech.unit.ingredients, { new_pack, new_count or 1 })
    end

    -- Helper: add a science pack ingredient to a technology
    local function add_tech_ingredient(tech_name, pack, count)
        local tech = data.raw.technology[tech_name]
        if not tech or not tech.unit or not tech.unit.ingredients then return end
        table.insert(tech.unit.ingredients, { pack, count })
    end

    -- Helper: replace a prerequisite in a technology
    local function replace_tech_prereq(tech_name, old_prereq, new_prereq)
        local tech = data.raw.technology[tech_name]
        if not tech or not tech.prerequisites then return end
        for i, prereq in pairs(tech.prerequisites) do
            if prereq == old_prereq then
                tech.prerequisites[i] = new_prereq
                return
            end
        end
    end

    -- Helper: add a prerequisite to a technology
    local function add_tech_prereq(tech_name, prereq)
        local tech = data.raw.technology[tech_name]
        if not tech or not tech.prerequisites then return end
        table.insert(tech.prerequisites, prereq)
    end

    -- planet-discovery-pyroclast: metallurgic-science-pack(1) → lava-science-pack(3)
    replace_tech_ingredient("planet-discovery-pyroclast", "metallurgic-science-pack", "lava-science-pack", 3)

    -- pyroclast-science-pack: metallurgic-science-pack(3) → lava-science-pack(5) + enchanted-science-pack(3)
    -- prereqs: military-science-pack → military-science-pack-2, add enchanted-science-pack
    replace_tech_ingredient("pyroclast-science-pack", "metallurgic-science-pack", "lava-science-pack", 5)
    add_tech_ingredient("pyroclast-science-pack", "enchanted-science-pack", 3)
    replace_tech_prereq("pyroclast-science-pack", "military-science-pack", "military-science-pack-2")
    add_tech_prereq("pyroclast-science-pack", "enchanted-science-pack")

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
