local util = {}

util.mod_table = {}

if script == nil then
	util.mod_table = mods
else
	util.mod_table = script.active_mods
end

util.mod_prefix = "lava-block-"

return util
