local util = {}

util.mod_table = {}

-- The game changes how it references active mods depending on the stage of the data lifecycle. This snippet abstracts that.
if script == nil then
	util.mod_table = mods
else
	util.mod_table = script.active_mods
end

-- lua lacks basic library functions, so some are coded here
function util.tableContains(myTable, value)
	for i, v in pairs(myTable) do
		if target == v then
			return true
		end
	end
	return false
end

util.mod_prefix = "lava-block-"

-- The name of the consumeable science vial.
-- Each island expansion requires these packs in-order and the last pack enables infinite research.
util.science_item_list = {
	"automation-science-pack",
	"logistic-science-pack",
	"military-science-pack",
	"chemical-science-pack",
	"production-science-pack",
	"utility-science-pack",
	"space-science-pack"
}

-- The name of the prereq for the matching consumable, or nil if the science is unlocked by default. These are the same in vanilla, but not the same in some mods.
util.science_research_prereq = {
	nil,
	"logistic-science-pack",
	"military-science-pack",
	"chemical-science-pack",
	"production-science-pack",
	"utility-science-pack",
	"space-science-pack"
}

return util
