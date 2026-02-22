-- Sulfuric acid lake tile for Pyroclast.
-- Deepcopied from the base water tile so it inherits water collision mask,
-- shore transitions, and offshore-pump compatibility out of the box.
-- fluid = "sulfuric-acid" tells the offshore pump what to extract.

local acid_tint = { r = 0.55, g = 0.60, b = 0.05, a = 0.9 }

-- Recursively apply tint to all sprite/picture tables in a tree.
local function tint_sprites(obj, tint)
    if type(obj) ~= "table" then return end
    if obj.filename or obj.filenames then
        obj.tint = tint
    else
        for _, v in pairs(obj) do
            tint_sprites(v, tint)
        end
    end
end

local acid_lake = table.deepcopy(data.raw.tile["water"])

acid_lake.name                  = "sulfuric-acid-lake"
acid_lake.fluid                 = "sulfuric-acid"
acid_lake.map_color             = { r = 0.58, g = 0.55, b = 0.04 }  -- yellow on minimap
acid_lake.effect_color          = { r = 0.50, g = 0.55, b = 0.04, a = 0.9 }
acid_lake.default_cover_tile    = "landfill"

-- Autoplace: scattered acid pools driven by pyroclast-specific noise.
-- Only active on surfaces that list this tile in their autoplace_settings.
-- Max probability 200 → beats lava (~100) in peak spots.
acid_lake.autoplace = {
    probability_expression = "200 * clamp("
        .. "multioctave_noise{"
        ..     "x = x, y = y,"
        ..     "seed0 = map_seed, seed1 = 63000,"
        ..     "octaves = 3, persistence = 0.5,"
        ..     "input_scale = 1/60, output_scale = 1"
        .. "} - 0.30,"
        .. "0, 1)",
    richness_expression = "1",
    order = "b[sulfuric-acid-lake]"
}

-- Apply yellow-green tint to all inherited water graphics.
if acid_lake.variants   then tint_sprites(acid_lake.variants,   acid_tint) end
if acid_lake.transitions then tint_sprites(acid_lake.transitions, acid_tint) end
if acid_lake.transitions_between_transitions then
    tint_sprites(acid_lake.transitions_between_transitions, acid_tint)
end

return acid_lake
