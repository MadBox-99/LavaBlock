function substitute_prerequisite(prerequisite_name, new_prerequisites)
    for _, tech in pairs(data.raw["technology"]) do
        local prerequisites = tech.prerequisites or {}
        for prerequisite_index, name in ipairs(prerequisites) do
            if name == prerequisite_name then
                table.remove(prerequisites, prerequisite_index)
                for new_prerequisites_index, new_prerequisite in ipairs(new_prerequisites) do
                    table.insert(prerequisites, prerequisite_index + new_prerequisites_index - 1, new_prerequisite)
                end

                break
            end
        end
    end
end

function remove_technology(technologyName)
    if not data.raw["technology"][technologyName] then return end
    local prerequisites = data.raw["technology"][technologyName].prerequisites
    data.raw["technology"][technologyName] = nil
    substitute_prerequisite(technologyName, prerequisites)
end

-- Helper: replace a science pack ingredient in a technology's unit
function replace_tech_ingredient(tech_name, old_pack, new_pack, new_count)
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
function add_tech_ingredient(tech_name, pack, count)
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.unit or not tech.unit.ingredients then return end
    table.insert(tech.unit.ingredients, { pack, count })
end

-- Helper: replace a prerequisite in a technology
function replace_tech_prereq(tech_name, old_prereq, new_prereq)
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
function add_tech_prereq(tech_name, prereq)
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.prerequisites then return end
    table.insert(tech.prerequisites, prereq)
end
