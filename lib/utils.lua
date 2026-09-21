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
    require("util")

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

return utils
