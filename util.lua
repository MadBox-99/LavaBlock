local util = {}

util.mod_table = {}

if script == nil then
    util.mod_table = mods
else
    util.mod_table = script.active_mods
end

util.mod_prefix = "lava-block-"

--- Add an input to a lab
---@param lab_name string
---@param input_name string
function util.add_lab_input(lab_name, input_name)
    local lab = data.raw["lab"][lab_name]
    if lab and lab.inputs then
        table.insert(lab.inputs, input_name)
    end
end

return util
