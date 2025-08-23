local util = {}

util.mod_table = {}

-- The game changes how it references active mods depending on the stage of the data lifecycle. This snippet abstracts that.
if script == nil then
	util.mod_table = mods
else
	util.mod_table = script.active_mods
end

-- When using this method with inserts always pass a target of the variable you want to come immediately before 'target' in your table.
function util.indexOfStringInTable(myTable, target)
	for i, v in pairs(myTable) do
		if target == v then
			return i
		end
	end
	error("Factories-in-tight-spaces.util.lua could not find index of string '" ..
		target .. "'. Double check the target is in the given table!")
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

--Lots of mods have 32px icons, which crash the game when updated with the 64px infinity symbol. So this helper keeps those update sections readable.
function util.create_32px_ore_icon(resource_name, base_item_icon_name)
	local small_infinity_icon_modifier = {
		icon = "__core__/graphics/icons/mip/infinity.png",
		icon_size = 24,
		icon_mipmaps = 3,
		scale = 0.75,
		shift = { 12, -12 }
	}

	local updated_icons = {
		{
			icon = data.raw["item"][base_item_icon_name].icon,
			icon_size = 32,
			icon_mipmaps = 4
		},
		small_infinity_icon_modifier
	}
	data.raw["item"]["lava-block-placeable-" .. resource_name .. "-resource"].icons = updated_icons
end

--Sometimes only the resource has an image icon, so this 'duplicate' method addresses that
function util.create_32px_ore_icon_from_resource(resource_name, base_resource_icon_name)
	local small_infinity_icon_modifier = {
		icon = "__core__/graphics/icons/mip/infinity.png",
		icon_size = 24,
		icon_mipmaps = 3,
		scale = 0.75,
		shift = { 12, -12 }
	}

	local updated_icons = {
		{
			icon = data.raw["resource"][base_resource_icon_name].icon,
			icon_size = 32,
			icon_mipmaps = 4
		},
		small_infinity_icon_modifier
	}
	data.raw["item"]["lava-block-placeable-" .. resource_name .. "-resource"].icons = updated_icons
end

util.mod_prefix = "lava-block-"



-- Creates an ordered list of placable infinite resource patch items.
util.resources_to_clone = {
	"iron-ore",
	"copper-ore",
	"stone",
	"coal",
	"crude-oil",
	"uranium-ore"
}

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



local debug_string = ""
for _, resource in pairs(util.resources_to_clone) do
	debug_string = debug_string .. resource .. ", "
end
-- The below line is strictly for debugging. Only activate it if you believe there's an issue with the util setup.
--error("Current resources to clone: " .. debug_string)



return util
