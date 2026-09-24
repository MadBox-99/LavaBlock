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

-- Sulfur: on the LavaBlock world it comes from lava (sulfur-lava), everywhere
-- else the vanilla recipe stays exactly as it is.
--
-- Rather than hiding the vanilla recipe and cloning it once per known planet
-- (which silently leaves out every planet added by another mod), the vanilla
-- recipe simply gets the complement of sulfur-lava's condition. Because
-- `lava-block-lava-ocean` defaults to 0 on every other surface, this covers all
-- present and future planets, keeps the recipe name `sulfur` intact for other
-- mods that reference it, and leaves the sulfur-processing technology's effects
-- untouched.
if data.raw.recipe["sulfur"] then
  local sulfur = data.raw.recipe["sulfur"]
  sulfur.surface_conditions = sulfur.surface_conditions or {}
  table.insert(sulfur.surface_conditions,
    { property = "lava-block-lava-ocean", min = 0, max = 0 })
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

-- ---------------------------------------------------------------------------
-- Quench Pit: one void recipe per fluid
-- ---------------------------------------------------------------------------
-- Generated, and generated here in final-fixes, because "it deletes any
-- fluid" has to survive contact with other mods. A hand-written list covers
-- this mod's nine fluids and goes stale the moment someone loads a mod that
-- adds a tenth; walking data.raw.fluid at the last data stage covers every
-- fluid that will exist in the game, whoever added it.
--
-- Why a recipe at all, when a fluid energy source would take any fluid with
-- no recipe needed: it would not meter. `destroy_non_fuel_fluid` empties the
-- machine's tank rather than draining it at a rate, so throughput would be
-- whatever the pipes happen to deliver and the number would be unstatable.
-- A recipe makes it exact, it shows the player what the machine is drinking,
-- and it means a misplumbed pipe cannot quietly swallow something valuable.
--
-- 1200 per second is one pump. That is the unit a Factorio player already
-- thinks in, so "one pump feeds one pit" needs no arithmetic - and against
-- this mod's own flows (iron smelting eats 1667 lava/s) it is a real
-- constraint rather than an infinite drain.
local QUENCH_AMOUNT = 1200      -- fluid per craft
local QUENCH_TIME = 1           -- seconds per craft

local function fluid_icon_layers(fluid)
    if fluid.icons then
        return table.deepcopy(fluid.icons)
    end
    if fluid.icon then
        return { { icon = fluid.icon, icon_size = fluid.icon_size or 64 } }
    end
    return nil
end

local quench_recipes = {}
for name, fluid in pairs(data.raw.fluid) do
    -- `parameter` fluids are blueprint stand-ins and hidden ones are
    -- scaffolding; neither is something a player can put in a pipe. A fluid
    -- with no icon at all cannot be given a legible recipe icon either.
    local layers = fluid_icon_layers(fluid)
    if not fluid.hidden and not fluid.parameter and layers then
        -- The bin marks it as a recipe that consumes and returns nothing.
        -- Without it every void recipe is just the fluid's own icon and the
        -- subgroup reads as a second copy of the fluid list.
        table.insert(layers, {
            icon = "__core__/graphics/icons/mip/trash-white.png",
            icon_size = 32,
            scale = 0.5,
            shift = { 8, 8 },
        })
        table.insert(quench_recipes, {
            type = "recipe",
            name = "quench-" .. name,
            localised_name = { "recipe-name.quench-fluid",
                fluid.localised_name or { "fluid-name." .. name } },
            localised_description = { "recipe-description.quench-fluid" },
            category = "fluid-quenching",
            subgroup = "fluid-quenching",
            order = fluid.order or name,
            -- Enabled from the start: the technology gates the machine, and
            -- gating both would put twenty-odd unlock effects on one
            -- technology's tooltip for no gain.
            enabled = true,
            energy_required = QUENCH_TIME,
            ingredients = { { type = "fluid", name = name, amount = QUENCH_AMOUNT } },
            results = {},
            icons = layers,
            -- Nothing comes out, so productivity has nothing to multiply and
            -- the recipe must never be treated as a way of making anything:
            -- left decomposable it would appear in "total raw" as a source
            -- of nothing and confuse every ratio the player looks up.
            allow_productivity = false,
            allow_decomposition = false,
            allow_as_intermediate = false,
            hide_from_player_crafting = true,
            always_show_made_in = true,
        })
    end
end
data:extend(quench_recipes)
log("[LavaBlock] Quench Pit: " .. #quench_recipes .. " void recipes generated")
