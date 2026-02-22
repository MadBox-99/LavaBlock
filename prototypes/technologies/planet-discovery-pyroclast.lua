-- Unlocks Pyroclast as a travel destination on the space platform.
-- Mirrors the structure of Space Age's planet-discovery-vulcanus:
--   - effect: unlock-space-location → pyroclast
--   - essential = true so it appears in the main tech tree path
-- Prerequisite: planet-discovery-vulcanus (must visit Vulcanus first)
local planet_discovery_pyroclast = {
    type = "technology",
    name = "planet-discovery-pyroclast",
    icons = {
        {
            icon = "__space-age__/graphics/technology/vulcanus.png",
            icon_size = 256,
            tint = { r = 0.25, g = 0.08, b = 0.08, a = 1 }
        },
        {
            icon = "__core__/graphics/icons/technology/constants/constant-planet.png",
            icon_size = 128,
            scale = 0.5,
            shift = { 50, 50 },
            floating = true
        }
    },
    effects = {
        {
            type = "unlock-space-location",
            space_location = "pyroclast",
            use_icon_overlay_constant = true
        }
    },
    prerequisites = { "planet-discovery-vulcanus" },
    unit = {
        count = 1500,
        time = 60,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "production-science-pack", 1 },
            { "utility-science-pack",    1 },
            { "space-science-pack",      1 },
            { "lava-science-pack",       3 },
        }
    },
    essential = true,
    order = "d[planet-discovery-pyroclast]"
}
return planet_discovery_pyroclast
