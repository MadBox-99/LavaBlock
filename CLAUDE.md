# Claude Code Guidelines for Factorio Modding

## Factorio 2.0 API Notes

### Runtime vs Prototype Objects

When working with technology objects in runtime (control.lua), remember:

- `LuaTechnology` (runtime) does NOT have `.effects` directly
- Must use `technology.prototype.effects` to access effects
- Check object type with `technology.object_name == "LuaTechnology"`

```lua
-- Helper function to handle both runtime and prototype objects
local function get_tech_effects(technology)
    if technology.object_name == "LuaTechnology" then
        return technology.prototype.effects
    end
    return technology.effects
end
```

### Production Statistics (Factorio 2.0)

The API changed from 1.x to 2.0:
- **Old (1.x):** `force.item_production_statistics`
- **New (2.0):** `force.get_item_production_statistics(surface)` - requires surface parameter

```lua
for _, surface in pairs(game.surfaces) do
    local stats = force.get_item_production_statistics(surface)
    local count = stats.get_input_count("item-name")
end
```

### Storage vs Global

In Factorio 2.0, use `storage` instead of `global` for persistent data.

```lua
-- Old (1.x)
global.my_data = {}

-- New (2.0)
storage.my_data = {}
```

## Best Practices for Technology Effects

### Don't hardcode technology names in control.lua

Instead of checking `event.research.name == "my-technology"`, use the "nothing" effect type with custom effect_description:

**In prototype (data stage):**
```lua
effects = {
    {
        type = "nothing",
        effect_description = {
            "technology-effect.my-custom-effect",  -- locale key
            "some-parameter",                       -- parameter 1
            {"some-locale.key"}                     -- parameter 2 (localized)
        }
    }
}
```

**In control.lua (runtime):**
```lua
script.on_event(defines.events.on_research_finished, function(event)
    local effects = get_tech_effects(event.research)
    if not effects then return end
    for _, effect in pairs(effects) do
        if effect.type == "nothing" and effect.effect_description then
            local desc = effect.effect_description
            if desc[1] == "technology-effect.my-custom-effect" then
                local param = desc[2]
                -- Do something with param
            end
        end
    end
end)
```

**In locale:**
```ini
[technology-effect]
my-custom-effect=Does something with __2__ [__1__]
```

This pattern is:
- Reusable across multiple technologies
- Data-driven (parameters defined in prototype, not hardcoded)
- Properly localized
- Follows community best practices

**WARNING: Fallback locale syntax breaks this pattern!**

If you use the `{"?", ...}` fallback syntax:
```lua
-- DON'T DO THIS for custom effects:
effect_description = {"?", "technology-effect.my-effect", "technology-effect.fallback"}
```

Then `desc[1]` will be `"?"`, not `"technology-effect.my-effect"`, and the check will fail.

**Only use simple locale keys (not fallback syntax) for effect_description when you need to parse it in control.lua.**

### Example: Disable Recipe Effect

**Prototype:**
```lua
effects = {
    {
        type = "nothing",
        effect_description = {
            "technology-effect.disable-recipe",
            "recipe-internal-name",
            {"recipe-name.recipe-internal-name"}
        }
    }
}
```

**Control.lua:**
```lua
local function disable_recipe_for_force(force, recipe_name)
    if force.recipes[recipe_name] then
        force.recipes[recipe_name].enabled = false
    end
end

script.on_event(defines.events.on_research_finished, function(event)
    local effects = get_tech_effects(event.research)
    if not effects then return end
    for _, effect in pairs(effects) do
        if effect.type == "nothing" and effect.effect_description then
            local desc = effect.effect_description
            if desc[1] == "technology-effect.disable-recipe" then
                disable_recipe_for_force(event.research.force, desc[2])
            end
        end
    end
end)
```

**Locale:**
```ini
[technology-effect]
disable-recipe=Disables __2__ [__1__]
```

### Example: Custom Numeric Modifier (Pennyisms pattern)

**Helper functions:**
```lua
-- Data stage helper
function custom_modifier(name, param, hidden)
    return {
        type = "nothing",
        effect_description = {"modifier."..name, tostring(param)},
        hidden = hidden,
    }
end

-- Runtime helper
function get_custom_modification(name, technology)
    if technology.object_name == "LuaTechnology" then
        technology = technology.prototype
    end
    local effects = technology.effects
    local locale_key = "modifier."..name

    local change = 0
    for _, modifier in pairs(effects) do
        if modifier.type == "nothing"
        and modifier.effect_description[1] == locale_key then
            change = change + tonumber(modifier.effect_description[2])
        end
    end
    return change
end
```

## Event Handling

### on_research_reversed

Consider handling `on_research_reversed` for editor mode compatibility:

```lua
script.on_event(defines.events.on_research_reversed, function(event)
    -- Undo effects when research is reversed (editor mode)
end)
```

### on_configuration_changed

Re-apply effects when mod configuration changes:

```lua
script.on_configuration_changed(function(data)
    for _, force in pairs(game.forces) do
        for _, tech in pairs(force.technologies) do
            if tech.researched then
                local effects = get_tech_effects(tech)
                -- Re-apply relevant effects
            end
        end
    end
end)
```

## Noise Expressions (Map Generation)

Noise expressions are string-based mathematical expressions evaluated per tile for map generation.
See: https://lua-api.factorio.com/latest/auxiliary/noise-expressions.html

### Calling Conventions

**Named arguments `{}`** — most built-in functions (basis_noise, multioctave_noise, spot_noise, voronoi_*):
```lua
basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 0, input_scale = 1/3, output_scale = 3}
multioctave_noise{x = x, y = y, seed0 = map_seed, seed1 = 0, octaves = 4, persistence = 0.6, input_scale = 1/300, output_scale = 1}
```

**Positional arguments `()`** — only `max`, `min`, `expression_in_range`:
```lua
max(a, b, c)  -- up to 255 args
min(a, b)
```

**Simple functions** — single/few params, positional OK:
```lua
abs(value)
clamp(value, min, max)
ceil(value)
floor(value)
sqrt(value)
cos(value)
sin(value)
log2(value)
```

**User-defined noise-functions** — positional `()` matching `parameters` order:
```lua
-- Definition
local_functions = {
    my_func = {
        type = "noise-function",
        parameters = { "scale", "seed" },
        expression = "basis_noise{x = x, y = y, seed0 = map_seed, seed1 = seed, input_scale = scale, output_scale = 1}"
    }
}
-- Call
"my_func(1/100, 42)"
```

### Identifier Names and `var()`

Identifiers with `-` or special characters must use `var()`:
```lua
-- "my-expression" would parse as my minus expression
var('my-noise-expression')

-- Autoplace controls with hyphens
var('control:enemy-base:frequency')
```

Underscored names parse fine without `var()`:
```lua
control:pyroclast_iron_geyser:frequency  -- OK, no hyphens
```

### Seed Conventions

- `seed0` = always `map_seed` (so terrain differs per game)
- `seed1` = sequential integer or string `NoiseLayerID` (constant)
- Use different `seed1` values for different noise layers, NOT `map_seed + offset`

```lua
-- CORRECT: different seed1 for different layers
basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 0, ...}
basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 1, ...}
basis_noise{x = x, y = y, seed0 = map_seed, seed1 = "my-named-noise", ...}

-- WRONG: modifying seed0
basis_noise{x = x, y = y, seed0 = map_seed + 1000, seed1 = 0, ...}

-- WRONG: non-constant seed1 (must be constant)
basis_noise{x = x, y = y, seed0 = map_seed, seed1 = seed1 + seed2, ...}
```

### Performance: input_scale, output_scale, offset_x, offset_y

Use built-in scale/offset parameters instead of multiplying x/y or the result.
The trivial case `x = x, y = y` is ~5x faster than custom x/y expressions.

```lua
-- CORRECT: use built-in parameters
basis_noise{x = x, y = y, input_scale = 2, output_scale = 3, seed0 = map_seed, seed1 = 0}
basis_noise{x = x, y = y, offset_x = 100, offset_y = -50, seed0 = map_seed, seed1 = 0}

-- WRONG: manual multiply (loses x=x,y=y optimization)
basis_noise{x = x * 2, y = y * 2, seed0 = map_seed, seed1 = 0}
2 * basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 0}

-- WRONG: manual offset (loses x=x,y=y optimization)
basis_noise{x = x + 100, y = y - 50, seed0 = map_seed, seed1 = 0}
```

For asymmetrical scaling (different x/y scales), minimize unique operations:
```lua
-- OK: one axis needs different scale, use input_scale for common factor
basis_noise{x = x, y = y * 1.5, input_scale = 2, output_scale = 1, seed0 = map_seed, seed1 = 0}
```

### Performance: Constant Folding

Place constants first in expressions so the compiler can fold them:
```lua
-- GOOD: 1 + 2 folds to 3
1 + 2 + x   -->  3 + x

-- BAD: no folding possible
x + 1 + 2   -->  (x + 1) + 2
```

MapGenSettings values (`map_seed`, `map_width`, `map_height`) are compile-time constants:
```lua
2 * map_width * map_height * x  -->  <constant> * x  -- folded
```

Arithmetic identity optimizations (automatic):
- `x + 0 → x`, `x * 1 → x`, `x * 0 → 0`
- `x ^ 0.5 → sqrt(x)`, `x ^ 2 → x * x`
- `x * (-1) → -x`, `0 - x → -x`

### Performance: Compile-time Deduplication

Identical AST nodes are deduplicated. Help the compiler by reusing sub-expressions:
```lua
-- 8 operations (good): shared sub-expressions
10 * x + 10 * y       -- "10", "10*x", "10*y", "10*x+10*y"
10 * x - 10 * y       -- reuses "10*x", "10*y"
10 * y - 10 * x       -- reuses "10*y", "10*x"
20 - (10 * x + 10 * y)  -- reuses "10*x+10*y"

-- 12 operations (bad): no shared sub-expressions
10 * (x + y)
10 * (x - y)
10 * (-x + y)
20 + 10 * (-x - y)
```

Note: `x + y` and `y + x` ARE the same (commutativity recognized), but `x + y + z` and `y + z + x` are NOT (different AST structure).

### Built-in Variables

```
x, y                                    -- current tile position
map_seed, map_seed_small                -- map seed values
map_seed_normalized                     -- 0-1 normalized seed
starting_positions                      -- MapPositionList
starting_lake_positions                 -- MapPositionList
starting_area_radius                    -- Number
peaceful_mode, no_enemies_mode          -- Boolean (number: >0 true, <=0 false)
control:NAME:frequency/size/richness    -- autoplace control settings
control:moisture:frequency/bias         -- moisture settings
control:aux:frequency/bias              -- aux settings
control:temperature:frequency/bias      -- temperature settings
```

Entity/tile/decorative autoplace access:
```
entity:my-entity:probability
entity:my-entity:richness
tile:my-tile:probability
decorative:my-decorative:probability
```

### Key Functions Quick Reference

| Function | Args | Notes |
|----------|------|-------|
| `basis_noise{...}` | x,y,seed0,seed1,input_scale,output_scale,offset_x,offset_y | Single octave; returns 0 for integer x,y,input_scale |
| `multioctave_noise{...}` | + persistence, octaves | Preferred multi-octave implementation |
| `spot_noise{...}` | density/quantity/radius/favorability expressions, seeds, region_size, skip_span/offset | Random conical spots; output = max height of any spot |
| `voronoi_cell_id{...}` | x,y,seed0,seed1,grid_size,distance_type,jitter | 0-1 per cell; distance_type: chebyshev/manhattan/euclidean/minkowski3 |
| `voronoi_facet_noise{...}` | same as cell_id | 0 at boundary, increases inward |
| `voronoi_spot_noise{...}` | same as cell_id | 0 at point, increases outward (cone) |
| `distance_from_nearest_point{...}` | x,y,points,maximum_distance | Euclidean distance to nearest point in list |
| `random_penalty{...}` | x,y,source,seed,amplitude | Subtracts random [0,amplitude) from source if source>0 |
| `ridge(value, min, max)` | | Folds value back across limits |
| `terrace{value,strength,offset,width}` | | Terrace effect |
| `if(condition, true_branch, false_branch)` | | No short-circuit; both branches evaluated |
| `quick_multioctave_noise{...}` | + octave_input/output_scale_multiplier | Alternative impl; prefer regular multioctave_noise |

## Changelog Categories

Standard Factorio changelog categories (avoid non-standard names):
- `Features`
- `Changes`
- `Bugfixes`
- `Scripting`
- `Modding`
- `Gui`
- `Control`
- `Graphics`
- `Sounds`
- `Optimizations`
- `Balancing`
- `Info`

**Invalid categories:** `Details`, `Recipes`, `Notes`, etc.

## Locale String Formatting

```ini
__1__, __2__              -- positional parameters
{"recipe-name.my-recipe"} -- reference to another locale key
[color=red]...[/color]    -- color formatting
[img=warning]             -- inline images
[img=item/iron-plate]     -- item icons
```

## Recipe Category Names

Custom recipe categories should use mod prefix to avoid warnings:
- Good: `my-mod-enchanting`
- Warning: `enchanting` (non-standard category name)

```lua
data:extend({
    {
        type = "recipe-category",
        name = "my-mod-custom-crafting"  -- use mod prefix
    }
})
```

## Entity Prototype Cloning

Use `table.deepcopy` to clone existing entities and modify them:

```lua
local my_machine = table.deepcopy(data.raw["assembling-machine"]["centrifuge"])
my_machine.name = "my-custom-machine"
my_machine.minable.result = "my-custom-machine"
my_machine.crafting_categories = { "my-mod-crafting" }
my_machine.crafting_speed = 1
my_machine.energy_usage = "500kW"
my_machine.module_slots = 4

data:extend({ my_machine })
```

## Fluid Boxes

Configure input/output fluid connections for assembling machines:

```lua
fluid_boxes = {
    {
        production_type = "input",
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } }
        },
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        volume = 1000,
    },
    {
        production_type = "output",
        pipe_connections = {
            { flow_direction = "output", direction = defines.direction.south, position = { 0, 1 } }
        },
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        volume = 1000,
    },
}
```

**Required imports:**
```lua
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.assemblerpipes")
```

## Research Triggers

Available trigger types for technologies (no science packs needed):

```lua
-- Craft item trigger
research_trigger = {
    type = "craft-item",
    item = "iron-plate",
    count = 100
}

-- Craft fluid trigger
research_trigger = {
    type = "craft-fluid",
    fluid = "crude-oil",
    amount = 1000
}

-- Build entity trigger
research_trigger = {
    type = "build-entity",
    entity = "assembling-machine-1",
    count = 1
}

-- Mine entity trigger
research_trigger = {
    type = "mine-entity",
    entity = "iron-ore",
    count = 50
}

-- Capture spawner trigger
research_trigger = {
    type = "capture-spawner"
}

-- Send item to orbit trigger (Space Age)
research_trigger = {
    type = "send-item-to-orbit",
    item = "satellite"
}
```

## Hidden Recipes and Technologies

```lua
-- Hidden recipe (not shown in crafting menu, only available via technology)
{
    type = "recipe",
    name = "my-hidden-recipe",
    hidden = true,
    -- ...
}

-- Hidden technology (researches automatically, not shown in tech tree)
{
    type = "technology",
    name = "my-hidden-tech",
    hidden = true,
    -- ...
}

-- Recipe hidden from player signals
{
    type = "recipe",
    name = "my-recipe",
    hidden_in_factoriopedia = true,
    -- ...
}
```

## Module Slots and Allowed Effects

```lua
{
    type = "assembling-machine",
    name = "my-machine",
    module_slots = 4,
    allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" },
    -- Or restrict modules:
    -- allowed_effects = { "speed" },  -- only speed modules allowed
    -- allowed_effects = nil,          -- no modules allowed
}
```

## Surface Conditions (Space Age)

Restrict recipes to specific planets:

```lua
{
    type = "recipe",
    name = "my-nauvis-only-recipe",
    surface_conditions = {
        {
            property = "surface-name",
            comparator = "=",
            value = "nauvis"
        }
    },
    -- ...
}

-- Or by gravity, pressure, etc.
surface_conditions = {
    {
        property = "gravity",
        comparator = ">=",
        value = 1
    }
}
```

## Icon Layering

Combine multiple icons:

```lua
icons = {
    {
        icon = "__base__/graphics/icons/iron-plate.png",
        icon_size = 64,
    },
    {
        icon = "__base__/graphics/icons/coal.png",
        icon_size = 64,
        scale = 0.25,
        shift = { -8, -8 },
    },
},
```

Or with tinting:

```lua
icons = {
    {
        icon = "__base__/graphics/icons/centrifuge.png",
        icon_size = 64,
        tint = { r = 1, g = 0.5, b = 0.5, a = 1 },  -- reddish tint
    },
},
```

## Technology Prerequisites and Upgrades

```lua
-- Tiered technologies with upgrade flag
{
    type = "technology",
    name = "my-tech-1",
    prerequisites = { "automation" },
    upgrade = true,  -- shows as upgrade in tech tree
}

{
    type = "technology",
    name = "my-tech-2",
    prerequisites = { "my-tech-1" },
    upgrade = true,
}

-- Loop for multiple tiers
for level = 1, 10 do
    data:extend({
        {
            type = "technology",
            name = "my-tech-" .. level,
            prerequisites = level == 1 and { "automation" } or { "my-tech-" .. (level - 1) },
            upgrade = true,
            -- ...
        }
    })
end
```

## Remote Interfaces

Communicate with other mods:

```lua
-- Check if interface exists
if remote.interfaces["freeplay"] then
    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)
end

-- Register your own interface
remote.add_interface("my-mod", {
    get_value = function() return storage.my_value end,
    set_value = function(val) storage.my_value = val end,
})
```

## Tile Manipulation (Runtime)

Create or modify tiles:

```lua
local surface = game.get_surface("nauvis")
local tiles = {}

for x = -10, 10 do
    for y = -10, 10 do
        table.insert(tiles, { name = "landfill", position = { x, y } })
    end
end

surface.set_tiles(tiles)

-- Check tile at position
local tile = surface.get_tile(0, 0)
if tile.name == "water" then
    -- ...
end
```

## Modifying Base Game Prototypes

```lua
-- Modify existing technology
data.raw.technology["oil-processing"].prerequisites = { "my-custom-tech" }
data.raw.technology["oil-processing"].unit.count = 500

-- Add effect to existing technology
table.insert(data.raw.technology["steel-processing"].effects, {
    type = "unlock-recipe",
    recipe = "my-steel-recipe"
})

-- Modify existing recipe
data.raw.recipe["iron-plate"].energy_required = 5

-- Hide base game recipe
data.raw.recipe["some-recipe"].hidden = true
```

## Player Inventory and Equipment

```lua
-- Give items to player
player.insert({ name = "iron-plate", count = 100 })

-- Check armor
local armor_inventory = player.get_inventory(defines.inventory.character_armor)
if armor_inventory and not armor_inventory.is_empty() then
    local armor = armor_inventory[1]
    if armor and armor.valid and armor.name == "power-armor" then
        -- player is wearing power armor
    end
end

-- Modify player stats
player.character_running_speed_modifier = -0.5  -- 50% slower
player.character_mining_speed_modifier = 1.0    -- 100% faster mining
```

## Useful Defines

```lua
-- Inventory types
defines.inventory.character_main
defines.inventory.character_armor
defines.inventory.character_guns
defines.inventory.character_ammo
defines.inventory.chest
defines.inventory.furnace_source
defines.inventory.furnace_result

-- Directions
defines.direction.north  -- 0
defines.direction.east   -- 4
defines.direction.south  -- 8
defines.direction.west   -- 12

-- Events
defines.events.on_tick
defines.events.on_player_created
defines.events.on_research_finished
defines.events.on_built_entity
defines.events.on_player_mined_entity
```

---

# Factorio 2.0 Prototype API Reference (v2.0.75, API v6)

Detailed type reference: `docs/prototype-types-reference.md`

## Inherited Base Properties (all prototypes)

From **PrototypeBase**:
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `type` | string | **yes** | - |
| `name` | string | **yes** | - |

From **Prototype** (extends PrototypeBase):
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `order` | Order | no | `""` |
| `localised_name` | LocalisedString | no | auto |
| `localised_description` | LocalisedString | no | auto |
| `hidden` | boolean | no | `false` |
| `hidden_in_factoriopedia` | boolean | no | `false` |
| `factoriopedia_description` | LocalisedString | no | - |
| `subgroup` | ItemSubGroupID | no | - |

## RecipePrototype (typename: `"recipe"`)

Inherits: Prototype -> RecipePrototype

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `category` | RecipeCategoryID | no | `"crafting"` | Which machines can craft this |
| `additional_categories` | RecipeCategoryID[] | no | - | Extra categories |
| `ingredients` | IngredientPrototype[] | no | - | Max amount 65535, no duplicates |
| `results` | ProductPrototype[] | no | - | Duplicates allowed |
| `main_product` | string | no | - | Controls tooltip/icon/subgroup |
| `energy_required` | double | no | `0.5` | Craft time in seconds (speed 1). Must be >0.001 |
| `emissions_multiplier` | double | no | `1` | |
| `maximum_productivity` | double | no | `3` | Must be >=0 |
| `enabled` | boolean | no | `true` | Available at game start |
| `surface_conditions` | SurfaceCondition[] | no | - | Planet restrictions (Space Age) |
| `allow_productivity` | boolean | no | `false` | |
| `allow_speed` | boolean | no | `true` | |
| `allow_consumption` | boolean | no | `true` | |
| `allow_quality` | boolean | no | `true` | |
| `allow_pollution` | boolean | no | `true` | |
| `allowed_module_categories` | ModuleCategoryID[] | no | all | |
| `hide_from_stats` | boolean | no | `false` | |
| `hide_from_player_crafting` | boolean | no | `false` | |
| `hide_from_signal_gui` | boolean | no | auto | |
| `always_show_made_in` | boolean | no | `false` | |
| `show_amount_in_title` | boolean | no | `true` | |
| `always_show_products` | boolean | no | `false` | |
| `allow_decomposition` | boolean | no | `true` | Used in "Total raw" |
| `allow_as_intermediate` | boolean | no | `true` | |
| `allow_intermediates` | boolean | no | `true` | |
| `unlock_results` | boolean | no | `true` | |
| `result_is_always_fresh` | boolean | no | `false` | |
| `auto_recycle` | boolean | no | `true` | Quality mod recycling |
| `overload_multiplier` | uint32 | no | `0` | |
| `allow_inserter_overload` | boolean | no | `true` | |
| `requester_paste_multiplier` | uint32 | no | `30` | |
| `crafting_machine_tint` | RecipeTints | no | - | |
| `icons` / `icon` / `icon_size` | IconData[] / FileName / SpriteSizeType | no | - | |
| `hidden` | boolean | no | `false` | |

### IngredientPrototype

**ItemIngredientPrototype:**
```lua
{type = "item", name = "iron-plate", amount = 12}
```
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `type` | `"item"` | **yes** | |
| `name` | ItemID | **yes** | |
| `amount` | uint16 | **yes** | Cannot be 0 |
| `ignored_by_stats` | uint16 | no | `0` |

**FluidIngredientPrototype:**
```lua
{type = "fluid", name = "water", amount = 50}
```
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `type` | `"fluid"` | **yes** | |
| `name` | FluidID | **yes** | |
| `amount` | FluidAmount | **yes** | Must be >0 |
| `temperature` | float | no | - |
| `minimum_temperature` | float | no | - |
| `maximum_temperature` | float | no | - |
| `fluidbox_index` | uint32 | no | `0` |
| `fluidbox_multiplier` | uint8 | no | `2` |

### ProductPrototype

**ItemProductPrototype:**
```lua
{type = "item", name = "iron-plate", amount = 1}
{type = "item", name = "copper-wire", amount_min = 1, amount_max = 3, probability = 0.5}
```
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `type` | `"item"` | **yes** | |
| `name` | ItemID | **yes** | |
| `amount` | uint16 | no | - |
| `amount_min` | uint16 | no | Required if no `amount` |
| `amount_max` | uint16 | no | Required if no `amount` |
| `probability` | double | no | `1` |
| `extra_count_fraction` | float | no | `0` |
| `ignored_by_stats` | uint16 | no | `0` |
| `ignored_by_productivity` | uint16 | no | `ignored_by_stats` |
| `percent_spoiled` | float | no | `0` |

**FluidProductPrototype:**
```lua
{type = "fluid", name = "petroleum-gas", amount = 45}
```
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `type` | `"fluid"` | **yes** | |
| `name` | FluidID | **yes** | |
| `amount` | FluidAmount | no | - |
| `amount_min` / `amount_max` | FluidAmount | no | - |
| `probability` | double | no | `1` |
| `temperature` | float | no | - |
| `fluidbox_index` | uint32 | no | `0` |

## TechnologyPrototype (typename: `"technology"`)

Inherits: Prototype -> TechnologyPrototype

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `unit` | TechnologyUnit | no* | - | *Required if no `research_trigger` |
| `research_trigger` | TechnologyTrigger | no* | - | *Required if no `unit` |
| `effects` | Modifier[] | no | - | Applied when researched |
| `prerequisites` | TechnologyID[] | no | - | Required techs |
| `upgrade` | boolean | no | `false` | Show as upgrade in tech tree |
| `enabled` | boolean | no | `true` | |
| `essential` | boolean | no | `false` | Show in "essential only" view |
| `visible_when_disabled` | boolean | no | `false` | |
| `max_level` | uint32 \| `"infinite"` | no | tech level | |
| `ignore_tech_cost_multiplier` | boolean | no | `false` | |
| `allows_productivity` | boolean | no | `true` | |
| `icons` / `icon` / `icon_size` | | no | - | Base game uses 256px |
| `hidden` | boolean | no | `false` | |

### TechnologyUnit
Either `count` or `count_formula`, never both.
```lua
unit = { count = 100, time = 30, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}} }
unit = { count_formula = "2^(L-6)*1000", time = 60, ingredients = {...} }
```
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `count` | uint64 | no | - |
| `count_formula` | MathExpression | no | `L` = current level |
| `time` | double | **yes** | Seconds at speed 1 |
| `ingredients` | ResearchIngredient[] | **yes** | `{"pack-name", count}` tuples |

### TechnologyTrigger types
| Type | Key fields |
|------|------------|
| `"craft-item"` | `item`, `count` (default 1) |
| `"craft-fluid"` | `fluid`, `amount` (default 0) |
| `"build-entity"` | `entity` |
| `"mine-entity"` | `entity` |
| `"capture-spawner"` | `entity` (optional) |
| `"send-item-to-orbit"` | `item` |
| `"create-space-platform"` | (no extra fields) |
| `"scripted"` | `trigger_description`, `icons` |

### Modifier types (technology effects)

**Common modifiers:**
| Type | Key fields | Parent |
|------|------------|--------|
| `"unlock-recipe"` | `recipe` | BaseModifier |
| `"nothing"` | `effect_description` | BaseModifier |
| `"give-item"` | `item`, `quality`, `count` | BaseModifier |
| `"unlock-space-location"` | `space_location` | BaseModifier |
| `"unlock-quality"` | `quality` | BaseModifier |
| `"change-recipe-productivity"` | `recipe`, `change` | BaseModifier |
| `"ammo-damage"` | `ammo_category`, `modifier` | BaseModifier |
| `"gun-speed"` | `ammo_category`, `modifier` | BaseModifier |
| `"turret-attack"` | `turret_id`, `modifier` | BaseModifier |

**SimpleModifier children** (all have `modifier: double`):
`inserter-stack-size-bonus`, `bulk-inserter-capacity-bonus`, `laboratory-speed`, `laboratory-productivity`, `character-logistic-trash-slots`, `maximum-following-robots-count`, `worker-robot-speed`, `worker-robot-storage`, `worker-robot-battery`, `character-crafting-speed`, `character-mining-speed`, `character-running-speed`, `character-build-distance`, `character-item-drop-distance`, `character-reach-distance`, `character-resource-reach-distance`, `character-item-pickup-distance`, `character-loot-pickup-distance`, `character-inventory-slots-bonus`, `character-health-bonus`, `mining-drill-productivity-bonus`, `train-braking-force-bonus`, `follower-robot-lifetime`, `artillery-range`, `deconstruction-time-to-live`, `cargo-landing-pad-count`, `belt-stack-size-bonus`, `beacon-distribution`

**BoolModifier children** (all have `modifier: boolean`):
`character-logistic-requests`, `vehicle-logistics`, `unlock-space-platforms`, `unlock-circuit-network`, `cliff-deconstruction-enabled`, `mining-with-fluid`, `rail-support-on-deep-oil-ocean`, `rail-planner-allow-elevated-rails`, `create-ghost-on-entity-death`

**BaseModifier** (all modifiers inherit):
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `icons` / `icon` / `icon_size` | | no | - |
| `hidden` | boolean | no | `false` |

## PlanetPrototype (typename: `"planet"`)

Inherits: Prototype -> SpaceLocationPrototype -> PlanetPrototype

### SpaceLocationPrototype properties
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `distance` | double | **yes** | Distance from sun |
| `orientation` | RealOrientation | **yes** | Angle relative to sun |
| `magnitude` | double | no | `1` |
| `gravity_pull` | double | no | `0` |
| `solar_power_in_space` | double | no | `1` |
| `asteroid_spawn_influence` | double | no | `0.1` |
| `asteroid_spawn_definitions` | SpaceLocationAsteroidSpawnDefinition[] | no | - |
| `draw_orbit` | boolean | no | `true` |
| `fly_condition` | boolean | no | `false` |
| `auto_save_on_first_trip` | boolean | no | `true` |
| `platform_procession_set` | ProcessionSet | no | - |
| `planet_procession_set` | ProcessionSet | no | - |
| `icons` / `icon` / `icon_size` | | no | - |
| `starmap_icons` / `starmap_icon` / `starmap_icon_size` | | no | - |

### PlanetPrototype own properties
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `map_gen_settings` | PlanetPrototypeMapGenSettings | no | - |
| `surface_properties` | dict[SurfacePropertyID -> double] | no | - |
| `map_seed_offset` | uint32 | no | CRC of name |
| `entities_require_heating` | boolean | no | `false` |
| `pollutant_type` | AirbornePollutantID | no | - |
| `lightning_properties` | LightningProperties | no | - |
| `player_effects` | Trigger | no | - |
| `ticks_between_player_effects` | MapTick | no | `0` |

### MapGenSettings (base type)
| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `seed` | uint32 | no | - | Map seed |
| `width` | uint32 | no | - | Map width in tiles (max 2,000,000 = +-1M from center) |
| `height` | uint32 | no | - | Map height in tiles (max 2,000,000) |
| `starting_area` | MapGenSize | no | - | Only affects enemy placement, not resources |
| `starting_points` | MapPosition[] | no | - | Starting area positions |
| `peaceful_mode` | boolean | no | - | Enemies don't attack until attacked |
| `no_enemies_mode` | boolean | no | - | No enemy spawning |
| `default_enable_all_autoplace_controls` | boolean | no | `true` | |
| `autoplace_controls` | dict[AutoplaceControlID -> FrequencySizeRichness] | no | - | |
| `autoplace_settings` | dict["entity"\|"tile"\|"decorative" -> AutoplaceSettings] | no | - | |
| `property_expression_names` | dict[string -> string\|boolean\|double] | no | - | |
| `cliff_settings` | CliffPlacementSettings | no | - | |
| `territory_settings` | TerritorySettings | no | - | |

### PlanetPrototypeMapGenSettings (extends MapGenSettings)
Additional properties on top of MapGenSettings:
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `moisture_climate_control` | boolean | no | `false` |
| `aux_climate_control` | boolean | no | `false` |

### FrequencySizeRichness
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `frequency` | MapGenSize | no | - |
| `size` | MapGenSize | no | - |
| `richness` | MapGenSize | no | - |

### AutoplaceSettings
| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `treat_missing_as_default` | boolean | no | - | Whether missing autoplace names default to enabled |
| `settings` | dict[EntityID\|TileID\|DecorativeID -> FrequencySizeRichness] | no | - | Overrides FrequencySizeRichness for specific prototypes. Takes priority over control settings |

### AutoplaceSpecification
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `probability_expression` | NoiseExpression | **yes** | |
| `richness_expression` | NoiseExpression | no | uses probability_expression |
| `control` | AutoplaceControlID | no | - |
| `default_enabled` | boolean | no | `true` |
| `force` | string | no | `"neutral"` |
| `order` | Order | no | `""` |
| `placement_density` | uint32 | no | `1` |
| `tile_restriction` | TileIDRestriction[] | no | - |
| `local_expressions` | dict[string -> NoiseExpression] | no | - |
| `local_functions` | dict[string -> NoiseFunction] | no | - |

### CliffPlacementSettings
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `name` | EntityID | no | - |
| `control` | AutoplaceControlID | no | - |
| `cliff_elevation_0` | float | no | `10` |
| `cliff_elevation_interval` | float | no | `40` |
| `cliff_smoothing` | float | no | `1` |
| `richness` | float | no | - |

### TerritorySettings
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `units` | EntityID[] | no | - |
| `territory_index_expression` | string | no | Required if units not empty |
| `territory_variation_expression` | string | no | `"0"` |
| `minimum_territory_size` | uint32 | no | `0` |

## SpaceConnectionPrototype (typename: `"space-connection"`)

| Property | Type | Required | Default |
|----------|------|----------|---------|
| `from` | SpaceLocationID | **yes** | |
| `to` | SpaceLocationID | **yes** | |
| `length` | uint32 | no | `600` |
| `asteroid_spawn_definitions` | SpaceConnectionAsteroidSpawnDefinition[] | no | - |
| `icons` / `icon` / `icon_size` | | no | - |

## Asteroid Spawn Definitions

### SpaceLocationAsteroidSpawnDefinition (for planets)
| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"entity"` \| `"asteroid-chunk"` | no | `"entity"` | |
| `asteroid` | EntityID \| AsteroidChunkID | **yes** | - | Type depends on `type` |
| `probability` | double | **yes** | - | Must be >= 0 |
| `speed` | double | **yes** | - | Must be > 0 |
| `angle_when_stopped` | float | no | `1` | Facing north. Must be [0, 1] |

### SpaceConnectionAsteroidSpawnDefinition (for space connections)
Can be written as struct or tuple `{EntityID, SpaceConnectionAsteroidSpawnPoint[]}`.
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `type` | `"entity"` \| `"asteroid-chunk"` | no | `"entity"` |
| `asteroid` | EntityID \| AsteroidChunkID | **yes** | - |
| `spawn_points` | SpaceConnectionAsteroidSpawnPoint[] | **yes** | - |

### SpaceConnectionAsteroidSpawnPoint
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `distance` | double | **yes** | - |
| `probability` | double | **yes** | - |
| `speed` | double | **yes** | - |
| `angle_when_stopped` | float | no | `1` |

## CraftingMachinePrototype (abstract parent of assembling-machine, furnace)

Inherits: EntityPrototype -> EntityWithHealthPrototype -> EntityWithOwnerPrototype -> CraftingMachinePrototype

| Property | Type | Required | Default |
|----------|------|----------|---------|
| `crafting_categories` | RecipeCategoryID[] | **yes** | |
| `crafting_speed` | double | **yes** | Must be positive |
| `energy_usage` | Energy | **yes** | e.g. `"90kW"` |
| `energy_source` | EnergySource | **yes** | |
| `module_slots` | ItemStackIndex | no | `0` |
| `allowed_effects` | EffectTypeLimitation | no | none |
| `allowed_module_categories` | ModuleCategoryID[] | no | all |
| `fluid_boxes` | FluidBox[] | no | - |
| `effect_receiver` | EffectReceiver | no | - |
| `show_recipe_icon` | boolean | no | `true` |
| `match_animation_speed_to_activity` | boolean | no | `true` |
| `return_ingredients_on_change` | boolean | no | `true` |
| `quality_affects_energy_usage` | boolean | no | `false` |
| `quality_affects_module_slots` | boolean | no | `false` |

### AssemblingMachinePrototype (typename: `"assembling-machine"`)
Additional properties on top of CraftingMachinePrototype:
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `fixed_recipe` | RecipeID | no | `""` |
| `ingredient_count` | uint16 | no | `65535` |
| `fluid_boxes_off_when_no_fluid_recipe` | boolean | no | `false` |
| `disabled_when_recipe_not_researched` | boolean | no | true if no fixed_recipe |
| `circuit_connector` | tuple(4x) | no | - |
| `circuit_wire_max_distance` | double | no | `0` |

### FurnacePrototype (typename: `"furnace"`)
Additional properties:
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `result_inventory_size` | ItemStackIndex | **yes** | |
| `source_inventory_size` | ItemStackIndex | **yes** | Max 1 |
| `cant_insert_at_source_message_key` | string | no | `"inventory-restriction.cant-be-smelted"` |

## EntityPrototype (abstract base of all entities)

Key properties (not exhaustive):
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `icons` / `icon` / `icon_size` | | no | Mandatory for placeable |
| `collision_box` | BoundingBox | no | `{{0,0},{0,0}}` |
| `selection_box` | BoundingBox | no | `{{0,0},{0,0}}` |
| `flags` | EntityPrototypeFlags | no | - |
| `minable` | MinableProperties | no | not minable |
| `surface_conditions` | SurfaceCondition[] | no | - |
| `map_color` | Color | no | - |
| `fast_replaceable_group` | string | no | `""` |
| `next_upgrade` | EntityID | no | - |
| `autoplace` | AutoplaceSpecification | no | - |
| `build_grid_size` | uint8 | no | `1` |
| `placeable_by` | ItemToPlace \| ItemToPlace[] | no | - |
| `emissions_per_second` | dict[AirbornePollutantID -> double] | no | - |
| `max_health` | float | no | - | (from EntityWithHealthPrototype) |
| `corpse` | EntityID \| EntityID[] | no | - | (from EntityWithHealthPrototype) |

### MinableProperties
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `mining_time` | double | **yes** | Seconds at speed 1 |
| `results` | ProductPrototype[] | no | - |
| `result` | ItemID | no | Only if no `results` |
| `count` | uint16 | no | `1` |
| `fluid_amount` | FluidAmount | no | `0` |
| `required_fluid` | FluidID | no | - |
| `mining_particle` | ParticleID | no | - |

## ItemPrototype (typename: `"item"`)

| Property | Type | Required | Default |
|----------|------|----------|---------|
| `stack_size` | ItemCountType | **yes** | |
| `icons` / `icon` / `icon_size` | | no | - |
| `place_result` | EntityID | no | `""` |
| `fuel_category` | FuelCategoryID | no | `""` |
| `fuel_value` | Energy | no | `"0J"` |
| `burnt_result` | ItemID | no | `""` |
| `spoil_result` | ItemID | no | - |
| `spoil_ticks` | uint32 | no | `0` |
| `plant_result` | EntityID | no | - |
| `weight` | Weight | no | auto |
| `default_import_location` | SpaceLocationID | no | `"nauvis"` |
| `rocket_launch_products` | ItemProductPrototype[] | no | - |
| `send_to_orbit_mode` | SendToOrbitMode | no | `"not-sendable"` |
| `flags` | ItemPrototypeFlags | no | - |
| `pictures` | SpriteVariations | no | - |
| `place_as_tile` | PlaceAsTile | no | - |
| `place_as_equipment_result` | EquipmentID | no | `""` |
| `auto_recycle` | boolean | no | `true` |
| `has_random_tint` | boolean | no | `true` |

## FluidPrototype (typename: `"fluid"`)

| Property | Type | Required | Default |
|----------|------|----------|---------|
| `default_temperature` | float | **yes** | Also minimum temperature |
| `base_color` | Color | **yes** | |
| `flow_color` | Color | **yes** | |
| `max_temperature` | float | no | default_temperature |
| `heat_capacity` | Energy | no | `"1kJ"` |
| `fuel_value` | Energy | no | `"0J"` |
| `emissions_multiplier` | double | no | `1` |
| `gas_temperature` | float | no | max float |
| `auto_barrel` | boolean | no | `true` |
| `icons` / `icon` / `icon_size` | | no | - |

## TilePrototype (typename: `"tile"`)

| Property | Type | Required | Default |
|----------|------|----------|---------|
| `collision_mask` | CollisionMaskConnector | **yes** | |
| `layer` | uint8 | **yes** | 0-255 |
| `map_color` | Color | **yes** | |
| `autoplace` | AutoplaceSpecification | no | - |
| `layer_group` | TileRenderLayer | no | - |
| `is_foundation` | boolean | no | `false` |
| `walking_speed_modifier` | double | no | `1` |
| `vehicle_friction_modifier` | double | no | `1` |
| `decorative_removal_probability` | float | no | `0` |
| `allows_being_covered` | boolean | no | `true` |
| `absorptions_per_second` | dict[AirbornePollutantID -> double] | no | - |
| `effect` | TileEffectDefinitionID | no | - |
| `frozen_variant` | TileID | no | - |
| `thawed_variant` | TileID | no | - |
| `placeable_by` | ItemToPlace \| ItemToPlace[] | no | - |

## AutoplaceControl (typename: `"autoplace-control"`)

| Property | Type | Required | Default |
|----------|------|----------|---------|
| `category` | `"resource"` \| `"terrain"` \| `"cliff"` \| `"enemy"` | **yes** | |
| `richness` | boolean | no | `false` |
| `can_be_disabled` | boolean | no | `true` |

## ResourceEntityPrototype (typename: `"resource"`)

| Property | Type | Required | Default |
|----------|------|----------|---------|
| `stage_counts` | uint32[] | **yes** | |
| `stages` | AnimationVariations | no | - |
| `infinite` | boolean | no | `false` |
| `minimum` | uint32 | no | `0` |
| `normal` | uint32 | no | `1` |
| `infinite_depletion_amount` | uint32 | no | `1` |
| `category` | ResourceCategoryID | no | `"basic-solid"` |
| `highlight` | boolean | no | `false` |
| `resource_patch_search_radius` | uint32 | no | `3` |
| `tree_removal_probability` | double | no | `0` |
| `cliff_removal_probability` | double | no | `1` |

## NoiseExpression / NoiseFunction Prototypes

### noise-expression (typename: `"noise-expression"`)
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `expression` | NoiseExpression | **yes** | string, boolean, or double |
| `intended_property` | string | no | - |
| `local_expressions` | dict[string -> NoiseExpression] | no | - |
| `local_functions` | dict[string -> NoiseFunction] | no | - |

### noise-function (typename: `"noise-function"`)
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `parameters` | string[] | **yes** | Max 255, order matters |
| `expression` | NoiseExpression | **yes** | |
| `local_expressions` | dict[string -> NoiseExpression] | no | - |
| `local_functions` | dict[string -> NoiseFunction] | no | - |

### NoiseExpression type
`string | boolean | double` — a math expression string, a boolean, or a numeric literal.

**Operator precedence** (high to low):
1. `x^y` — exponentiation (right-to-left)
2. `+x`, `-x`, `~x` — unary (right-to-left)
3. `x*y`, `x/y`, `x%y`, `x%%y` — multiplication, division, modulo
4. `x+y`, `x-y` — addition, subtraction
5. `x<y`, `x<=y`, `x>y`, `x>=y` — comparison (returns 0 or 1)
6. `x==y`, `x~=y`, `x!=y` — equality
7. `x&y` — bitwise and
8. `x~y` — bitwise xor
9. `x|y` — bitwise or

**Number formats:** `123`, `1.5`, `.5`, `0xFF`, `1e-3`

## EnergySource types

All energy sources inherit: `emissions_per_minute` (dict), `render_no_power_icon` (default true), `render_no_network_icon` (default true)

### ElectricEnergySource
| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"electric"` | **yes** | - | |
| `usage_priority` | ElectricUsagePriority | **yes** | - | |
| `buffer_capacity` | Energy | no | - | e.g. `"5MJ"` |
| `input_flow_limit` | Energy | no | max | Rate energy can be taken. `0` = no transfer |
| `output_flow_limit` | Energy | no | max | Rate energy can be provided |
| `drain` | Energy | no | - | Constant draw even when inactive. Shown as "Min. Consumption" |

**ElectricUsagePriority:** `"primary-input"` (lasers), `"primary-output"`, `"secondary-input"` (machines), `"secondary-output"` (steam), `"tertiary"` (accumulators), `"solar"`, `"lamp"`

### BurnerEnergySource
| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"burner"` | **yes** | - | |
| `fuel_inventory_size` | ItemStackIndex | **yes** | - | |
| `fuel_categories` | FuelCategoryID[] | no | `{"chemical"}` | |
| `effectivity` | double | no | `1` | Must be > 0 |
| `burnt_inventory_size` | ItemStackIndex | no | `0` | |
| `burner_usage` | BurnerUsageID | no | `"fuel"` | |
| `initial_fuel` | ItemID | no | `""` | |
| `initial_fuel_percent` | double | no | `0.25` | |

### HeatEnergySource
| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"heat"` | **yes** | - | |
| `max_temperature` | double | **yes** | - | Must be >= default_temperature |
| `specific_heat` | Energy | **yes** | - | |
| `max_transfer` | Energy | **yes** | - | |
| `default_temperature` | double | no | `15` | |
| `min_working_temperature` | double | no | `15` | Must be >= default, <= max |
| `connections` | HeatConnection[] | no | - | Max 32 connections |

### FluidEnergySource
| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"fluid"` | **yes** | - | |
| `fluid_box` | FluidBox | **yes** | - | Must be "input" or "input-output" |
| `effectivity` | double | no | `1` | Must be > 0 |
| `burns_fluid` | boolean | no | `false` | If true, uses FluidPrototype::fuel_value |
| `scale_fluid_usage` | boolean | no | `false` | If true, consume only what's needed |
| `fluid_usage_per_tick` | FluidAmount | no | `0` | Max if scale_fluid_usage is true |
| `maximum_temperature` | float | no | `0` | 0 = unlimited. Only if burns_fluid=false |
| `destroy_non_fuel_fluid` | boolean | no | `true` | Destroy zero-value fluid |

### VoidEnergySource
`energy_source = {type = "void"}` — unlimited free energy, no extra fields

## FluidBox

| Property | Type | Required | Default |
|----------|------|----------|---------|
| `volume` | FluidAmount | **yes** | Must be >0 |
| `pipe_connections` | PipeConnectionDefinition[] | **yes** | Max 255 |
| `production_type` | `"none"` \| `"input"` \| `"input-output"` \| `"output"` | no | `"none"` |
| `filter` | FluidID | no | - |
| `pipe_covers` | Sprite4Way | no | - |
| `pipe_picture` | Sprite4Way | no | - |
| `minimum_temperature` | float | no | Only with filter |
| `maximum_temperature` | float | no | Only with filter |
| `hide_connection_info` | boolean | no | `false` |
| `draw_only_when_connected` | boolean | no | `false` |
| `secondary_draw_order` | int8 | no | `1` |

### PipeConnectionDefinition
| Property | Type | Required | Default |
|----------|------|----------|---------|
| `flow_direction` | `"input"` \| `"output"` \| `"input-output"` | no | `"input-output"` |
| `direction` | defines.direction | no | - |
| `position` | MapPosition | no | - |
| `positions` | tuple(4x MapPosition) | no | For 4 entity directions |
| `connection_type` | `"normal"` \| `"underground"` \| `"linked"` | no | `"normal"` |
| `connection_category` | string \| string[] | no | `"default"` |

## SurfaceCondition

| Property | Type | Required | Default |
|----------|------|----------|---------|
| `property` | SurfacePropertyID | **yes** | |
| `min` | double | no | -inf |
| `max` | double | no | +inf |

Common properties: `"gravity"`, `"pressure"`, `"solar-power"`, `"magnetic-field"`, `"day-night-cycle"`, `"surface-name"`

## IconData

| Property | Type | Required | Default |
|----------|------|----------|---------|
| `icon` | FileName | **yes** | |
| `icon_size` | SpriteSizeType | no | `64` |
| `tint` | Color | no | `{1,1,1,1}` |
| `shift` | Vector | no | `{0,0}` |
| `scale` | double | no | `(expected_icon_size/2)/icon_size` |
| `draw_background` | boolean | no | true for first layer |
| `floating` | boolean | no | `false` |

Expected icon sizes: 512 (starmap), 256 (technology), 128 (achievement/ItemGroup), 64 (default), 32 (shortcut)

## MapGenSize values

| String | Numeric |
|--------|---------|
| `"none"` | 0 |
| `"very-low"` / `"very-small"` / `"very-poor"` | 0.5 |
| `"low"` / `"small"` / `"poor"` | 1/sqrt(2) ≈ 0.707 |
| `"normal"` / `"medium"` / `"regular"` | 1 |
| `"high"` / `"big"` / `"good"` | sqrt(2) ≈ 1.414 |
| `"very-high"` / `"very-big"` / `"very-good"` | 2 |

Supported range: 0 and 1/6 to 6.

## Type Aliases

| Alias | Underlying | Description |
|-------|-----------|-------------|
| Energy | string | e.g. `"5MJ"`, `"300kW"`, `"1W"`, `"0J"` |
| FluidAmount | double | |
| ItemCountType | uint32 | |
| ItemStackIndex | uint16 | |
| Order | string | Sorting string |
| FileName | string | Path like `"__mod__/graphics/file.png"` |
| MathExpression | string | `L` = level variable |
| LocalisedString | string \| array | Locale key or `{"key", params...}` |
| NoiseExpression | string \| boolean \| double | |
| EntityID / ItemID / FluidID / RecipeID / TechnologyID / TileID | string | Prototype name |
| SpaceLocationID / QualityID / AutoplaceControlID | string | Prototype name |
| RecipeCategoryID / FuelCategoryID / ResourceCategoryID | string | Prototype name |
| SurfacePropertyID / AirbornePollutantID | string | Prototype name |

## All 259 Prototype Typenames

`accumulator`, `achievement`, `active-defense-equipment`, `agricultural-tower`, `airborne-pollutant`, `ambient-sound`, `ammo`, `ammo-category`, `ammo-turret`, `animation`, `arithmetic-combinator`, `armor`, `arrow`, `artillery-flare`, `artillery-projectile`, `artillery-turret`, `artillery-wagon`, `assembling-machine`, `asteroid`, `asteroid-chunk`, `asteroid-collector`, `autoplace-control`, `battery-equipment`, `beacon`, `beam`, `belt-immunity-equipment`, `blueprint`, `blueprint-book`, `boiler`, `build-entity-achievement`, `burner-generator`, `burner-usage`, `capsule`, `capture-robot`, `car`, `cargo-bay`, `cargo-landing-pad`, `cargo-pod`, `cargo-wagon`, `chain-active-trigger`, `change-surface-achievement`, `character`, `character-corpse`, `cliff`, `collision-layer`, `combat-robot`, `combat-robot-count-achievement`, `complete-objective-achievement`, `constant-combinator`, `construct-with-robots-achievement`, `construction-robot`, `container`, `copy-paste-tool`, `corpse`, `create-platform-achievement`, `curved-rail-a`, `curved-rail-b`, `custom-event`, `custom-input`, `damage-type`, `decider-combinator`, `deconstruct-with-robots-achievement`, `deconstructible-tile-proxy`, `deconstruction-item`, `delayed-active-trigger`, `deliver-by-robots-achievement`, `deliver-category`, `deliver-impact-combination`, `deplete-resource-achievement`, `destroy-cliff-achievement`, `display-panel`, `dont-build-entity-achievement`, `dont-craft-manually-achievement`, `dont-kill-manually-achievement`, `dont-research-before-researching-achievement`, `dont-use-entity-in-energy-production-achievement`, `editor-controller`, `electric-energy-interface`, `electric-pole`, `electric-turret`, `elevated-curved-rail-a`, `elevated-curved-rail-b`, `elevated-half-diagonal-rail`, `elevated-straight-rail`, `energy-shield-equipment`, `entity-ghost`, `equip-armor-achievement`, `equipment-category`, `equipment-ghost`, `equipment-grid`, `explosion`, `fire`, `fish`, `fluid`, `fluid-turret`, `fluid-wagon`, `font`, `fuel-category`, `furnace`, `fusion-generator`, `fusion-reactor`, `gate`, `generator`, `generator-equipment`, `god-controller`, `group-attack-achievement`, `gui-style`, `gun`, `half-diagonal-rail`, `heat-interface`, `heat-pipe`, `highlight-box`, `impact-category`, `infinity-cargo-wagon`, `infinity-container`, `infinity-pipe`, `inserter`, `inventory-bonus-equipment`, `item`, `item-entity`, `item-group`, `item-request-proxy`, `item-subgroup`, `item-with-entity-data`, `item-with-inventory`, `item-with-label`, `item-with-tags`, `kill-achievement`, `lab`, `lamp`, `land-mine`, `lane-splitter`, `legacy-curved-rail`, `legacy-straight-rail`, `lightning`, `lightning-attractor`, `linked-belt`, `linked-container`, `loader`, `loader-1x1`, `locomotive`, `logistic-container`, `logistic-robot`, `map-gen-presets`, `map-settings`, `market`, `mining-drill`, `mod-data`, `module`, `module-category`, `module-transfer-achievement`, `mouse-cursor`, `movement-bonus-equipment`, `night-vision-equipment`, `noise-expression`, `noise-function`, `offshore-pump`, `optimized-decorative`, `optimized-particle`, `particle-source`, `pipe`, `pipe-to-ground`, `place-equipment-achievement`, `planet`, `plant`, `player-damaged-achievement`, `player-port`, `power-switch`, `procession`, `procession-layer-inheritance-group`, `produce-achievement`, `produce-per-hour-achievement`, `programmable-speaker`, `projectile`, `proxy-container`, `pump`, `quality`, `radar`, `rail-chain-signal`, `rail-planner`, `rail-ramp`, `rail-remnants`, `rail-signal`, `rail-support`, `reactor`, `recipe`, `recipe-category`, `resource`, `resource-category`, `roboport`, `roboport-equipment`, `rocket-silo`, `rocket-silo-rocket`, `rocket-silo-rocket-shadow`, `segment`, `segmented-unit`, `selection-tool`, `selector-combinator`, `shoot-achievement`, `shortcut`, `simple-entity`, `simple-entity-with-force`, `simple-entity-with-owner`, `smoke-with-trigger`, `solar-panel`, `solar-panel-equipment`, `sound`, `space-connection`, `space-connection-distance-traveled-achievement`, `space-location`, `space-platform-hub`, `space-platform-starter-pack`, `spectator-controller`, `speech-bubble`, `spider-leg`, `spider-unit`, `spider-vehicle`, `spidertron-remote`, `splitter`, `sprite`, `sticker`, `storage-tank`, `straight-rail`, `stream`, `surface`, `surface-property`, `technology`, `temporary-container`, `thruster`, `tile`, `tile-effect`, `tile-ghost`, `tips-and-tricks-item`, `tips-and-tricks-item-category`, `tool`, `train-path-achievement`, `train-stop`, `transport-belt`, `tree`, `trigger-target-type`, `trivial-smoke`, `turret`, `tutorial`, `underground-belt`, `unit`, `unit-spawner`, `upgrade-item`, `use-entity-in-energy-production-achievement`, `use-item-achievement`, `utility-constants`, `utility-sounds`, `utility-sprites`, `valve`, `virtual-signal`, `wall`
