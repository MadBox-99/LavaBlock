-- The magma reactor, the island's fusion reactor: it burns magma cells,
-- takes cold molten salt and power, and drives the salt up into plasma for
-- the magma turbines standing against it.
--
-- A fusion reactor underneath, with its footprint, its connections and its
-- neighbour bonus: reactors built side by side run their plasma hotter. It
-- makes 40 plasma a second at 25 MJ, 1000 MW, which is four turbines - one
-- on each of its four plasma nozzles. It draws 100 MW to hold the melt, a
-- tenth of what it gives, as the fusion reactor draws 10 MW of its 100.
local reactor = table.deepcopy(data.raw["fusion-reactor"]["fusion-reactor"])
reactor.name = "magma-reactor"
reactor.localised_name = nil
reactor.factoriopedia_description = nil
reactor.minable = { mining_time = 1, result = "magma-reactor" }
reactor.max_health = 3000
reactor.corpse = "big-remnants"
reactor.fast_replaceable_group = "magma-reactor"
reactor.icon = "__LavaBlock-graphics__/graphics/icons/items/magma-reactor.png"
reactor.icon_size = 64
reactor.icons = nil

reactor.power_input = "100MW"
reactor.max_fluid_usage = 40 / 60
reactor.burner.fuel_categories = { "magma" }
-- The glow of a working reactor is the plasma's, violet-pink.
reactor.burner.light_flicker = {
    color = { 1, 0.45, 0.85 },
    minimum_intensity = 0.0,
    maximum_intensity = 0.1,
}

reactor.input_fluid_box.filter = "molten-salt-cold"
reactor.output_fluid_box.filter = "magma-plasma"
for _, c in pairs(reactor.output_fluid_box.pipe_connections) do
    c.connection_category = { "magma-plasma" }
end

-- Its own neighbour categories, so a magma reactor never counts a fusion
-- reactor next to it as a neighbour, or the other way round.
local CATEGORY = {
    ["fusion-reactor-plasma"] = "magma-reactor-plasma",
    ["fusion-reactor-coolant"] = "magma-reactor-coolant",
}
for _, c in pairs(reactor.neighbour_connectable.connections) do
    c.category = CATEGORY[c.category]
    local neighbours = {}
    for _, n in pairs(c.neighbour_category) do
        table.insert(neighbours, CATEGORY[n])
    end
    c.neighbour_category = neighbours
end

-- Custom model, built and rendered in Blender (see
-- tools/blender/magma_reactor.py): a domed containment vessel ringed with
-- magnetite coils on an olivine-lined plinth, a nozzle at each of its eight
-- connections.
--
-- ONE PICTURE for both facings. The eight nozzles look alike, so the
-- reactor is the same seen north or east, and the fusion reactor is drawn
-- the same way; which of them carry plasma and which salt is what alt-mode
-- shows. A reactor has no moving parts to animate - the graphics set takes
-- a sprite, not an animation - so what changes when it runs is the glow of
-- its sight glasses, drawn as its own layer.
local GFX = "__LavaBlock-graphics__/graphics/entity/magma-reactor/"

local function layer(kind, extra)
    local name = "magma-reactor-" .. kind .. "-north"
    local sheet = require("__LavaBlock-graphics__/graphics/entity/magma-reactor/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

reactor.graphics_set = {
    structure = {
        layers = {
            layer("entity"),
            layer("shadow", { draw_as_shadow = true }),
        },
    },
    working_light_pictures = {
        layers = {
            layer("tint", { blend_mode = "additive", draw_as_glow = true }),
        },
    },
    plasma_category = "magma-reactor-plasma",
}

return reactor
