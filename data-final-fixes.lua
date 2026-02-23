local util = require("util")

-- Register lava-mech-armor to use mech-armor animations
if data.raw["armor"]["lava-mech-armor"] and data.raw.character.character then
  -- Find the mech-armor animation entry and add lava-mech-armor to it
  for _, anim in pairs(data.raw.character.character.animations) do
    if anim.armors then
      for _, armor_name in pairs(anim.armors) do
        if armor_name == "mech-armor" then
          table.insert(anim.armors, "lava-mech-armor")
          break
        end
      end
    end
  end

  -- Also add to corpse picture mapping
  if data.raw['character-corpse'] and data.raw['character-corpse']['character-corpse'] then
    local corpse = data.raw['character-corpse']['character-corpse']
    if corpse.armor_picture_mapping and corpse.armor_picture_mapping["mech-armor"] then
      corpse.armor_picture_mapping["lava-mech-armor"] = corpse.armor_picture_mapping["mech-armor"]
    end
  end
end

-- Add science packs to labs
util.add_lab_input("lab", "lava-science-pack")
util.add_lab_input("biolab", "lava-science-pack")
util.add_lab_input("lab", "enchanted-science-pack")
util.add_lab_input("biolab", "enchanted-science-pack")
util.add_lab_input("lab", "military-science-pack-2")
util.add_lab_input("biolab", "military-science-pack-2")
util.add_lab_input("lab", "circuit-science-pack")
util.add_lab_input("biolab", "circuit-science-pack")

-- Create planet-specific sulfur recipes and hide the original
-- Nauvis uses sulfur-lava (defined in prototypes/recipes/sulfur-lava.lua)
-- Other planets get copies of the original recipe with their specific surface_conditions
if data.raw.recipe['sulfur'] then
  local original_sulfur = data.raw.recipe['sulfur']

  -- Hide the original sulfur recipe
  original_sulfur.hidden = true

  -- Planet surface conditions (pressure + gravity values for precise matching)
  -- Nauvis: pressure=1000, gravity=10 (uses sulfur-lava instead)
  local planets = {
    { name = "gleba",      pressure = 300,  gravity = 15 },
    { name = "fulgora",    pressure = 800,  gravity = 8  },
    { name = "aquilo",     pressure = 2000, gravity = 20 },
    { name = "vulcanus",   pressure = 4000, gravity = 40 },
  }

  -- Add Pyroclast sulfur recipe only when the Pyroclast mod is installed
  if mods["Pyroclast"] then
    table.insert(planets, { name = "pyroclast", pressure = 6000, gravity = 60 })
  end

  for _, planet in pairs(planets) do
    local planet_sulfur = table.deepcopy(original_sulfur)
    planet_sulfur.name = "sulfur-" .. planet.name
    planet_sulfur.hidden = false
    planet_sulfur.localised_name = nil     -- Use locale file names instead
    planet_sulfur.surface_conditions = {
      { property = "pressure", min = planet.pressure, max = planet.pressure },
      { property = "gravity",  min = planet.gravity,  max = planet.gravity }
    }
    data:extend({ planet_sulfur })

    -- Add to sulfur-processing technology unlocks
    if data.raw.technology["sulfur-processing"] then
      table.insert(data.raw.technology["sulfur-processing"].effects, {
        type = "unlock-recipe",
        recipe = "sulfur-" .. planet.name
      })
    end
  end
end

-- Override volcanic tile autoplaces to use the standard `aux` channel.
-- This makes them work on both Pyroclast (aux = pyroclast-aux) and Vulcanus (aux = vulcanus_aux).
-- The probability values (150-250) are calibrated to beat lava (~100) in biome zones
-- while losing to mountain lava spots (~1100) so volcanic rivers are preserved.
if mods["space-age"] then
    -- Rocky ground: low aux (0 → 0.4), max probability 200
    if data.raw.tile["volcanic-smooth-stone"] then
        data.raw.tile["volcanic-smooth-stone"].autoplace = {
            probability_expression = "200 * clamp((0.40 - aux) / 0.40, 0, 1)",
            richness_expression = "1",
            order = "b[volcanic-smooth-stone]"
        }
    end
    -- Ash soil: medium aux (0.35 → 0.65), max probability 160 at center (0.5)
    if data.raw.tile["volcanic-ash-soil"] then
        data.raw.tile["volcanic-ash-soil"].autoplace = {
            probability_expression = "160 * clamp(1 - 3 * abs(aux - 0.50), 0, 1)",
            richness_expression = "1",
            order = "b[volcanic-ash-soil]"
        }
    end
    -- Dark ash: high aux (0.60 → 1.0), max probability 200
    if data.raw.tile["volcanic-ash-dark"] then
        data.raw.tile["volcanic-ash-dark"].autoplace = {
            probability_expression = "200 * clamp((aux - 0.60) / 0.40, 0, 1)",
            richness_expression = "1",
            order = "b[volcanic-ash-dark]"
        }
    end
    -- Volcanic folds: very high aux (0.78 → 1.0), max probability 250
    -- Appear as rare rugged formations on top of dark ash regions
    if data.raw.tile["volcanic-folds"] then
        data.raw.tile["volcanic-folds"].autoplace = {
            probability_expression = "250 * clamp((aux - 0.78) / 0.22, 0, 1)",
            richness_expression = "1",
            order = "c[volcanic-folds]"
        }
    end
end

-- Demolisher noise expressions for Nauvis
if mods["space-age"] then
  data:extend({
    {
      type = "noise-expression",
      name = "nauvis_demolisher_territory_radius",
      expression = "384" -- Terület mérete tile-okban
    },
    {
      type = "noise-expression",
      name = "nauvis_demolisher_territory_expression",
      expression = [[voronoi_cell_id{
        x = x + 1000 * 384,
        y = y + 1000 * 384,
        seed0 = map_seed,
        seed1 = 1,
        grid_size = 384,
        distance_type = 'manhattan',
        jitter = 1
      } - nauvis_demolisher_starting_area]]
    },
    {
      type = "noise-expression",
      name = "nauvis_demolisher_starting_area",
      -- Spawn körüli védett zóna (kb. 200 tile sugár)
      expression = "distance < 200"
    },
    {
      type = "noise-expression",
      name = "nauvis_demolisher_variation_expression",
      -- 0 = small, 1 = medium, 2 = big (távolság alapján növekszik)
      expression = "floor(clamp(distance / (18 * 32) - 0.25, 0, 2)) + (-99 * no_enemies_mode)"
    }
  })

  -- Add territory_settings to Nauvis
  local nauvis = data.raw["planet"]["nauvis"]
  if nauvis and nauvis.map_gen_settings then
    nauvis.map_gen_settings.territory_settings = {
      units = { "small-demolisher", "medium-demolisher", "big-demolisher" },
      territory_index_expression = "nauvis_demolisher_territory_expression",
      territory_variation_expression = "nauvis_demolisher_variation_expression",
      minimum_territory_size = 10
    }
  end
end
