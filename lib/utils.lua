local utils = {}

-- Remove a value from an array-style table
-- Returns a new table without the specified value(s)
-- @param tbl table - the source table
-- @param value any|table - value to remove, or table of values to remove
function utils.remove_from_array(tbl, value)
    local result = {}
    local remove_set = {}

    if type(value) == "table" then
        for _, v in pairs(value) do
            remove_set[v] = true
        end
    else
        remove_set[value] = true
    end

    for _, item in pairs(tbl or {}) do
        if not remove_set[item] then
            table.insert(result, item)
        end
    end

    return result
end

-- Create a 4-direction graphics_set from a horizontal sprite sheet
-- @param options table:
--   filename: path to sprite sheet
--   width: frame width in pixels
--   height: frame height in pixels
--   frame_count: frames per direction (default 1)
--   scale: sprite scale (default 0.5)
--   tint: optional tint color
-- Assumes sprite sheet layout: [north frames][east frames][south frames][west frames]
function utils.make_rotated_graphics_set(options)
    local util = require("util")

    local base = {
        filename = options.filename,
        width = options.width,
        height = options.height,
        frame_count = options.frame_count or 1,
        scale = options.scale or 0.5,
    }
    if options.tint then
        base.tint = options.tint
    end

    local frame_width = options.width
    local frames_per_dir = options.frame_count or 1

    return {
        animation = {
            north = { layers = { util.merge({ base, { x = 0 } }) } },
            east = { layers = { util.merge({ base, { x = frame_width * frames_per_dir } }) } },
            south = { layers = { util.merge({ base, { x = frame_width * frames_per_dir * 2 } }) } },
            west = { layers = { util.merge({ base, { x = frame_width * frames_per_dir * 3 } }) } },
        }
    }
end

-- Remove pipe covers and pipe pictures from all fluid boxes
-- @param entity table - entity prototype with fluid_boxes
function utils.remove_pipe_covers(entity)
    if entity.fluid_boxes then
        for _, fluid_box in pairs(entity.fluid_boxes) do
            if type(fluid_box) == "table" then
                fluid_box.pipe_covers = nil
                fluid_box.pipe_picture = nil
            end
        end
    end
    return entity
end

-- Chimney smoke for a crafting machine, as working visualisations.
--
-- Not the `smoke` field: that belongs to generators, boilers and reactors,
-- and an assembling machine silently ignores it - the data stage loads
-- cleanly and nothing ever appears. Not baked into the entity sheet either,
-- or it would show on an idle machine and have to share the sheet's frame
-- count. A working visualisation is drawn only while the machine crafts.
--
-- Three puffs up the same line, each larger, fainter and slower than the one
-- below it. One puff on its own just pulses in place, because a working
-- visualisation cannot move; three at increasing heights read as a plume
-- rising and thinning out. Their speeds are deliberately not multiples of
-- each other, so they drift apart instead of pulsing in unison.
--
-- @param stack table - { north = {x, y}, east = ..., south = ..., west = ... }
--                      the top of the machine in tiles from its centre.
--                      Measure it off the finished sheet rather than working
--                      it out from the camera angle: the tallest point is
--                      rarely over the entity centre, so the vertical factor
--                      differs per model.
-- @return table - working_visualisations entries, ready to append
function utils.stack_smoke(stack)
    local steps = {
        { rise = 0.00, scale = 0.42, alpha = 0.40, speed = 0.150 },
        { rise = 0.38, scale = 0.58, alpha = 0.29, speed = 0.113 },
        { rise = 0.74, scale = 0.76, alpha = 0.18, speed = 0.087 },
    }
    local out = {}
    for _, s in pairs(steps) do
        local v = {
            animation = {
                filename = "__base__/graphics/entity/smoke-fast/smoke-fast.png",
                priority = "high",
                width = 50,
                height = 50,
                frame_count = 16,
                animation_speed = s.speed,
                scale = s.scale,
                tint = { r = 0.60, g = 0.58, b = 0.56, a = s.alpha },
            },
            -- Puffs at its own rate. Without this the smoke speeds up with
            -- the machine, so a beaconed plant looks like it is on fire.
            constant_speed = true,
            fadeout = true,
            render_layer = "building-smoke",
        }
        for _, dir in pairs({ "north", "east", "south", "west" }) do
            v[dir .. "_position"] = {
                stack[dir][1],
                stack[dir][2] - s.rise,
            }
        end
        table.insert(out, v)
    end
    return out
end

-- Technology and lab helpers. Every one of them does nothing when the
-- prototype it is pointed at is missing, so they are safe to call on
-- another mod's technologies whether or not that mod is loaded.

-- Remove a technology and hand its prerequisites to everything that
-- depended on it, so the tree stays connected.
-- @param tech_name string
function utils.remove_technology(tech_name)
    local removed = data.raw.technology[tech_name]
    if not removed then return end
    local inherited = removed.prerequisites or {}
    data.raw.technology[tech_name] = nil
    for _, tech in pairs(data.raw.technology) do
        local prerequisites = tech.prerequisites or {}
        for index, name in ipairs(prerequisites) do
            if name == tech_name then
                table.remove(prerequisites, index)
                for offset, prerequisite in ipairs(inherited) do
                    table.insert(prerequisites, index + offset - 1, prerequisite)
                end
                break
            end
        end
    end
end

-- Swap one science pack for another in a technology's cost. If the old pack
-- is not there, the new one is added instead.
-- @param tech_name string
-- @param old_pack string
-- @param new_pack string
-- @param new_count number|nil - keeps the old count when nil
function utils.replace_tech_ingredient(tech_name, old_pack, new_pack, new_count)
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.unit or not tech.unit.ingredients then return end
    for _, ingredient in pairs(tech.unit.ingredients) do
        if ingredient[1] == old_pack then
            ingredient[1] = new_pack
            if new_count then ingredient[2] = new_count end
            return
        end
    end
    table.insert(tech.unit.ingredients, { new_pack, new_count or 1 })
end

-- @param tech_name string
-- @param old_prereq string
-- @param new_prereq string
function utils.replace_tech_prereq(tech_name, old_prereq, new_prereq)
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.prerequisites then return end
    for index, prereq in pairs(tech.prerequisites) do
        if prereq == old_prereq then
            tech.prerequisites[index] = new_prereq
            return
        end
    end
end

-- @param tech_name string
-- @param prereq string
function utils.add_tech_prereq(tech_name, prereq)
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.prerequisites then return end
    table.insert(tech.prerequisites, prereq)
end

-- Take one recipe unlock out of a technology, leaving the rest of its
-- effects - including any another mod added - in place.
-- @param tech_name string
-- @param recipe_name string
function utils.remove_recipe_unlock(tech_name, recipe_name)
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.effects then return end
    for index, effect in ipairs(tech.effects) do
        if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
            table.remove(tech.effects, index)
            return
        end
    end
end

-- Add a science pack to a lab's inputs, once.
-- @param lab_name string
-- @param input_name string
function utils.add_lab_input(lab_name, input_name)
    local lab = data.raw.lab[lab_name]
    if not lab or not lab.inputs then return end
    for _, input in pairs(lab.inputs) do
        if input == input_name then return end
    end
    table.insert(lab.inputs, input_name)
end

--- A machine icon with its tier badge laid over it.
---
--- The badge is drawn on its own full-size canvas, already in the corner, so
--- both layers sit at the default scale with no shift. Anything else has to
--- be checked in-game; this cannot land in the wrong place.
--- @param name string - entity name; both files are named after it
function utils.badged_icon(name)
    return {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/items/" .. name .. ".png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/badges/" .. name .. ".png",
            icon_size = 64,
        },
    }
end

return utils
