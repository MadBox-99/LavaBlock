local utils = require("lib.utils")

local industrialised_chemical_plant = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
industrialised_chemical_plant.name = "industrialised-chemical-plant"
industrialised_chemical_plant.minable.result = "industrialised-chemical-plant"
-- "chemical" is used by exactly zero recipes in this mod (and in vanilla); the
-- mod's 14 chemical recipes are all "chemistry". With the old value the machine
-- was buildable but permanently empty.
industrialised_chemical_plant.crafting_categories = { "chemistry" }
industrialised_chemical_plant.crafting_speed = 2.0

-- Same icon as the item, so alt-mode and Factoriopedia match the model.
industrialised_chemical_plant.icon =
    "__LavaBlock-graphics__/graphics/icons/items/industrialised-chemical-plant.png"
industrialised_chemical_plant.icon_size = 64
industrialised_chemical_plant.icons = nil

-- Custom model, built and rendered in Blender (see docs/blender-renders.md).
--
-- What was here before was four unrelated buildings, one per facing, drawn at
-- a camera angle of their own and in a much lighter palette than the rest of
-- the mod - so rotating the machine rebuilt it, and it never sat next to the
-- other lava machines. This is one building seen from four sides, and a
-- deliberately crowded one: five hooped vessels, a spherical accumulator, a
-- reactor drum across the front, a pipe rack, galleries, ladders and a big
-- elbow. The old sprite was a dense picture, and a tidy three-vessel model
-- read as a step backwards however correct it was.
local GFX = "__LavaBlock-graphics__/graphics/entity/industrialised-chemical-plant/"

local function layer(kind, dir, extra)
    local name = "industrialised-chemical-plant-" .. kind .. "-" .. dir
    local sheet = require(
        "__LavaBlock-graphics__/graphics/entity/industrialised-chemical-plant/" .. name)
    local l = {
        filename = GFX .. name .. ".png",
        priority = "high",
        width = sheet.width,
        height = sheet.height,
        frame_count = sheet.sprite_count,
        line_length = sheet.line_length,
        -- Brisk: this is a driven machine, not a growing one.
        animation_speed = 0.35,
        scale = sheet.scale,
        shift = sheet.shift,
    }
    for k, v in pairs(extra or {}) do
        l[k] = v
    end
    return l
end

local function plant_layers(dir)
    return {
        layer("entity", dir),
        layer("shadow", dir, { draw_as_shadow = true }),
    }
end

-- The liquid in the sight glasses is its own sheet, tinted by the recipe, the
-- way the vanilla chemical plant does it. Being a working visualisation it is
-- only drawn while the machine runs, so an idle plant shows dark windows.
industrialised_chemical_plant.graphics_set = {
    animation = {
        north = { layers = plant_layers("north") },
        east = { layers = plant_layers("east") },
        south = { layers = plant_layers("south") },
        west = { layers = plant_layers("west") },
    },
    working_visualisations = {
        {
            apply_recipe_tint = "primary",
            north_animation = layer("tint", "north"),
            east_animation = layer("tint", "east"),
            south_animation = layer("tint", "south"),
            west_animation = layer("tint", "west"),
        },
    },
}

-- Smoke off the tallest column. The positions are the topmost opaque pixel
-- of each facing's own sheet, measured rather than calculated; the column is
-- well off centre, so the stack swings right across the sprite as the plant
-- is turned.
for _, v in pairs(utils.stack_smoke({
    north = { -0.59, -2.70 },
    east = { 0.61, -2.67 },
    south = { 0.02, -2.02 },
    west = { -0.36, -2.36 },
})) do
    table.insert(industrialised_chemical_plant.graphics_set.working_visualisations, v)
end

-- The model carries its own port stubs; a one-tile cover sprite cannot meet a
-- stub that reaches past that tile. See docs/blender-renders.md.
utils.remove_pipe_covers(industrialised_chemical_plant)

return industrialised_chemical_plant
