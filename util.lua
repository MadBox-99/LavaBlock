local util = {}

util.mod_table = {}

if script == nil then
    util.mod_table = mods
else
    util.mod_table = script.active_mods
end

util.mod_prefix = "lava-block-"

--- Add an input to a lab (data stage only)
---@param lab_name string
---@param input_name string
function util.add_lab_input(lab_name, input_name)
    local lab = data.raw["lab"][lab_name]
    if lab and lab.inputs then
        table.insert(lab.inputs, input_name)
    end
end

--- Research a technology for all forces (runtime only)
---@param tech_name string
function util.research_technology_for_all_forces(tech_name)
    for _, force in pairs(game.forces) do
        if force.technologies[tech_name] then
            force.technologies[tech_name].researched = true
        end
    end
end

return util
