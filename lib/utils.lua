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

return utils
