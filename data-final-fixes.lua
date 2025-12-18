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

-- Add lava-science-pack to labs
util.add_lab_input("lab", "lava-science-pack")
util.add_lab_input("biolab", "lava-science-pack")

-- Demolisher noise expressions for Nauvis
if mods["space-age"] then
  data:extend({
    {
      type = "noise-expression",
      name = "nauvis_demolisher_territory_radius",
      expression = "384"  -- Terület mérete tile-okban
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
      units = {"small-demolisher", "medium-demolisher", "big-demolisher"},
      territory_index_expression = "nauvis_demolisher_territory_expression",
      territory_variation_expression = "nauvis_demolisher_variation_expression",
      minimum_territory_size = 10
    }
  end
end
