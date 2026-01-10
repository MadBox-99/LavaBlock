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
