-- Molten-iron and molten-copper geysers for Pyroclast.
-- Deepcopied from sulfuric-acid-geyser; tints and fluid overridden for each type.
-- Extracted by offshore pump (resource category = "basic-fluid").
-- Autoplace probability is 0 by default; Pyroclast planet overrides it via
-- property_expression_names in map_gen_settings.

local function tint_all_animations(node, tint)
    if type(node) ~= "table" then return end
    if node.filename or node.filenames then
        node.tint = tint
    else
        for _, v in pairs(node) do
            tint_all_animations(v, tint)
        end
    end
end

local base = data.raw.resource["sulfuric-acid-geyser"]

-- Molten iron: grey-orange glow matching the fluid's flow_color {0.2, 0.68, 0.93}
-- (uses a warm orange tint so the smoke reads as superheated metal vapour)
local iron_smoke_tint   = { r = 0.85, g = 0.55, b = 0.20, a = 0.6 }

-- Molten copper: copper-orange matching flow_color {0.93, 0.68, 0.2}
local copper_smoke_tint = { r = 0.90, g = 0.45, b = 0.10, a = 0.6 }

local molten_iron_geyser = table.deepcopy(base)
molten_iron_geyser.name      = "molten-iron-geyser"
molten_iron_geyser.icon      = "__space-age__/graphics/icons/fluid/molten-iron.png"
molten_iron_geyser.icon_size = 64
molten_iron_geyser.order     = "e"
molten_iron_geyser.map_color = { r = 0.55, g = 0.60, b = 0.70 }  -- blue-grey on minimap
molten_iron_geyser.minable   = {
    mining_time = 1,
    results = {
        { type = "fluid", name = "molten-iron", amount_min = 10, amount_max = 10, probability = 1 }
    }
}
molten_iron_geyser.autoplace = { order = "c", probability_expression = 0 }
if molten_iron_geyser.stateless_visualisation then
    tint_all_animations(molten_iron_geyser.stateless_visualisation, iron_smoke_tint)
end

local molten_copper_geyser = table.deepcopy(base)
molten_copper_geyser.name      = "molten-copper-geyser"
molten_copper_geyser.icon      = "__space-age__/graphics/icons/fluid/molten-copper.png"
molten_copper_geyser.icon_size = 64
molten_copper_geyser.order     = "f"
molten_copper_geyser.map_color = { r = 0.85, g = 0.45, b = 0.10 }  -- copper-orange on minimap
molten_copper_geyser.minable   = {
    mining_time = 1,
    results = {
        { type = "fluid", name = "molten-copper", amount_min = 10, amount_max = 10, probability = 1 }
    }
}
molten_copper_geyser.autoplace = { order = "c", probability_expression = 0 }
if molten_copper_geyser.stateless_visualisation then
    tint_all_animations(molten_copper_geyser.stateless_visualisation, copper_smoke_tint)
end

return { molten_iron_geyser, molten_copper_geyser }
