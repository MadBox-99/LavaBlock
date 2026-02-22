# Factorio 2.0 Prototype API Types Reference
# Extracted from prototype-api.json (Factorio 2.0.75, API version 6)

---

## Table of Contents
1. [AutoplaceSpecification](#autoplacespecification)
2. [MapGenSettings](#mapgensettings)
3. [NoiseExpression / NoiseFunction](#noiseexpression--noisefunction)
4. [TechnologyUnit](#technologyunit)
5. [TechnologyTrigger (ResearchTrigger types)](#technologytrigger)
6. [Modifier Types](#modifier-types)
7. [IngredientPrototype](#ingredientprototype)
8. [ItemProductPrototype / FluidProductPrototype](#product-prototypes)
9. [SurfaceCondition](#surfacecondition)
10. [IconData](#icondata)
11. [EnergySource Types](#energysource-types)
12. [FluidBox](#fluidbox)
13. [Asteroid Types](#asteroid-types)
14. [TerritorySettings](#territorysettings)
15. [ProcessionSet](#processionset)
16. [CliffPlacementSettings](#cliffplacementsettings)
17. [SurfacePropertyPrototype / SurfacePropertyID](#surfacepropertyprototype)
18. [FrequencySizeRichness / AutoplaceSettings / MapGenSize](#supporting-map-gen-types)

---

## AutoplaceSpecification

Autoplace specification is used to determine which entities are placed when generating map. Currently it is used for enemy bases, tiles, resources and other entities (trees, fishes, etc.). Defines probability of placement on any given tile and richness.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `control` | AutoplaceControlID | yes | - | Name of the AutoplaceControl (row in the map generator GUI) that applies to this entity. |
| `default_enabled` | boolean | yes | `true` | Indicates whether the thing should be placed even if MapGenSettings do not provide frequency/size/richness for it. If true, normal frequency/size/richness (value=1) are used. Otherwise treated as 'none'. |
| `force` | `"enemy"` \| `"player"` \| `"neutral"` \| string | yes | `"neutral"` | Force of the placed entity. Only relevant for EntityWithOwnerPrototype. |
| `order` | Order | yes | `""` | Order for placing the entity. Entities whose order compares less are placed earlier; from entities with equal order only one with the highest probability is placed. |
| `placement_density` | uint32 | yes | `1` | For entities and decoratives, how many times to attempt to place on each tile. Probability and collisions are taken into account each attempt. |
| `probability_expression` | NoiseExpression | **no** | - | Noise expression evaluated at every point on the map to determine probability. |
| `richness_expression` | NoiseExpression | yes | - | Noise expression for richness. If not specified, `probability_expression` is used instead. |
| `tile_restriction` | TileIDRestriction[] | yes | - | Restricts tiles or tile transitions the entity can appear on. |
| `local_expressions` | dict[string -> NoiseExpression] | yes | - | Map of expression name to expression. Used by probability_expression and richness_expression. Local expressions can access other local definitions and function parameters but not recursive. |
| `local_functions` | dict[string -> NoiseFunction] | yes | - | Map of function name to function. Local functions aren't visible outside of the specific prototype. |

---

## MapGenSettings

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `default_enable_all_autoplace_controls` | boolean | yes | `true` | Whether undefined autoplace_controls should fall back to the default controls. |
| `autoplace_controls` | dict[AutoplaceControlID -> FrequencySizeRichness] | yes | - | |
| `autoplace_settings` | dict[`"entity"` \| `"tile"` \| `"decorative"` -> AutoplaceSettings] | yes | - | Each setting maps the string type to the settings for that type. |
| `property_expression_names` | dict[string -> string \| boolean \| double] | yes | - | Map of property name ("elevation", etc) to name of noise expression that will provide it. |
| `starting_points` | MapPosition[] | yes | - | Array of the positions of the starting areas. |
| `seed` | uint32 | yes | - | Read by the game, but not used or set in the GUI. |
| `width` | uint32 | yes | - | Width of the map in tiles. Silently limited to 2,000,000 (+-1M tiles from center). |
| `height` | uint32 | yes | - | Height of the map in tiles. Silently limited to 2,000,000. |
| `starting_area` | MapGenSize | yes | - | Size of the starting area. Only effects enemy placement, no effect on resources. |
| `peaceful_mode` | boolean | yes | - | If true, enemy creatures will not attack unless the player first attacks them. |
| `no_enemies_mode` | boolean | yes | - | If true, enemy creatures will not naturally spawn from spawners, map gen, or trigger effects. |
| `cliff_settings` | CliffPlacementSettings | yes | - | |
| `territory_settings` | TerritorySettings | yes | - | |

---

## NoiseExpression / NoiseFunction

### NoiseExpression

A boolean or double as simple values or a string that represents a math expression.

**Type:** `string | boolean | double`

The expression parser recognizes these token types:
- **Whitespace:** `[ \n\r\t]*`
- **Identifier:** `[a-zA-Z_][a-zA-Z0-9_:]*`
- **Number:** `(0x[0-9a-f]+|([0-9]+\.?[0-9]*|\.[0-9]+)(e-?[0-9]+)?)` - supports hex and scientific notation
- **String:** `("[^"]*"|'[^']*')`
- **Operators** (by precedence):
  - `x^y` - Exponentiation (right-to-left)
  - `+x`, `-x`, `~x` - Unary plus, minus, bitwise not (right-to-left)
  - `x*y`, `x/y`, `x%y`, `x%%y` - Multiplication, division, modulo, remainder
  - `x+y`, `x-y` - Addition, subtraction
  - `x<y`, `x<=y`, `x>y`, `x>=y` - Comparison (return 0 or 1)
  - `x==y`, `x~=y`, `x!=y` - Equality
  - `x&y` - Bitwise and
  - `x~y` - Bitwise xor
  - `x|y` - Bitwise or

Functions accept both positional `clamp(x, -1, 1)` and named `clamp{min = -1, max = 1, value = x}` arguments. Max 255 parameters.

Examples:
```lua
"distance_from_nearest_point{x = x, y = y, points = starting_positions}"
"clamp(x, -1, 1)"
```

### NoiseFunction

The advantage of noise functions over noise expressions is that they have parameters.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `parameters` | string[] | **no** | - | Order of parameters matters (positional args). Max 255 parameters. |
| `expression` | NoiseExpression | **no** | - | |
| `local_expressions` | dict[string -> NoiseExpression] | yes | - | Local expressions for reuse within this function. |
| `local_functions` | dict[string -> NoiseFunction] | yes | - | Local functions for reuse. |

---

## TechnologyUnit

Either `count` or `count_formula` must be defined, never both.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `count` | uint64 | yes | - | How many units are needed. Must be > 0. |
| `count_formula` | MathExpression | yes | - | Formula for units per level. `l` and `L` are the current level. If prototype name ends with `-<number>`, that number is the level (default 1). For infinite techs, level begins at suffix and gains 1 per research. |
| `time` | double | **no** | - | How much time one unit takes to research. In a lab with speed 1, equals seconds. |
| `ingredients` | ResearchIngredient[] | **no** | - | List of ingredients needed for one unit. Items must all be ToolPrototypes. |

Example:
```lua
unit = {
  count_formula = "2^(L-6)*1000",
  ingredients = {
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"production-science-pack", 1},
    {"utility-science-pack", 1},
    {"space-science-pack", 1}
  },
  time = 60
}
```

---

## TechnologyTrigger

Union type loaded based on the value of the `type` key. These are used instead of TechnologyUnit when a technology uses `research_trigger` instead of `unit`.

**Members:**
| Type Value | Class | Description |
|------------|-------|-------------|
| `"mine-entity"` | MineEntityTechnologyTrigger | |
| `"craft-item"` | CraftItemTechnologyTrigger | |
| `"craft-fluid"` | CraftFluidTechnologyTrigger | |
| `"send-item-to-orbit"` | SendItemToOrbitTechnologyTrigger | |
| `"capture-spawner"` | CaptureSpawnerTechnologyTrigger | |
| `"build-entity"` | BuildEntityTechnologyTrigger | |
| `"create-space-platform"` | CreateSpacePlatformTechnologyTrigger | |
| `"scripted"` | ScriptedTechnologyTrigger | |

### BuildEntityTechnologyTrigger

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"build-entity"` | **no** | - | |
| `entity` | EntityIDFilter | **no** | - | |

### CaptureSpawnerTechnologyTrigger

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"capture-spawner"` | **no** | - | |
| `entity` | EntityID | yes | - | |

### CraftFluidTechnologyTrigger

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"craft-fluid"` | **no** | - | |
| `fluid` | FluidID | **no** | - | |
| `amount` | double | yes | `0` | |

### CraftItemTechnologyTrigger

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"craft-item"` | **no** | - | |
| `item` | ItemIDFilter | **no** | - | |
| `count` | ItemCountType | yes | `1` | |

### MineEntityTechnologyTrigger

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"mine-entity"` | **no** | - | |
| `entity` | EntityID | **no** | - | |

### SendItemToOrbitTechnologyTrigger

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"send-item-to-orbit"` | **no** | - | |
| `item` | ItemIDFilter | **no** | - | |

### CreateSpacePlatformTechnologyTrigger

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"create-space-platform"` | **no** | - | |

### ScriptedTechnologyTrigger

Triggered only by calling `LuaForce::script_trigger_research`. Can show custom scripted triggers in the technology GUI.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"scripted"` | **no** | - | |
| `trigger_description` | LocalisedString | yes | - | |
| `icons` | IconData[] | yes | - | Can't be an empty array. |
| `icon` | FileName | yes | - | Only loaded if `icons` is not defined. |
| `icon_size` | SpriteSizeType | yes | `64` | Only loaded if `icons` is not defined. |

---

## Modifier Types

### Modifier (Union)

The effect applied when a TechnologyPrototype is researched. Loaded as one of the BaseModifier extensions based on the `type` key.

**All possible type values:**
| Type Value | Class | Parent |
|------------|-------|--------|
| `"inserter-stack-size-bonus"` | InserterStackSizeBonusModifier | SimpleModifier |
| `"bulk-inserter-capacity-bonus"` | BulkInserterCapacityBonusModifier | SimpleModifier |
| `"laboratory-speed"` | LaboratorySpeedModifier | SimpleModifier |
| `"character-logistic-trash-slots"` | CharacterLogisticTrashSlotsModifier | SimpleModifier |
| `"maximum-following-robots-count"` | MaximumFollowingRobotsCountModifier | SimpleModifier |
| `"worker-robot-speed"` | WorkerRobotSpeedModifier | SimpleModifier |
| `"worker-robot-storage"` | WorkerRobotStorageModifier | SimpleModifier |
| `"turret-attack"` | TurretAttackModifier | BaseModifier |
| `"ammo-damage"` | AmmoDamageModifier | BaseModifier |
| `"give-item"` | GiveItemModifier | BaseModifier |
| `"gun-speed"` | GunSpeedModifier | BaseModifier |
| `"unlock-recipe"` | UnlockRecipeModifier | BaseModifier |
| `"character-crafting-speed"` | CharacterCraftingSpeedModifier | SimpleModifier |
| `"character-mining-speed"` | CharacterMiningSpeedModifier | SimpleModifier |
| `"character-running-speed"` | CharacterRunningSpeedModifier | SimpleModifier |
| `"character-build-distance"` | CharacterBuildDistanceModifier | SimpleModifier |
| `"character-item-drop-distance"` | CharacterItemDropDistanceModifier | SimpleModifier |
| `"character-reach-distance"` | CharacterReachDistanceModifier | SimpleModifier |
| `"character-resource-reach-distance"` | CharacterResourceReachDistanceModifier | SimpleModifier |
| `"character-item-pickup-distance"` | CharacterItemPickupDistanceModifier | SimpleModifier |
| `"character-loot-pickup-distance"` | CharacterLootPickupDistanceModifier | SimpleModifier |
| `"character-inventory-slots-bonus"` | CharacterInventorySlotsBonusModifier | SimpleModifier |
| `"deconstruction-time-to-live"` | DeconstructionTimeToLiveModifier | SimpleModifier |
| `"max-failed-attempts-per-tick-per-construction-queue"` | MaxFailedAttemptsPerTickPerConstructionQueueModifier | SimpleModifier |
| `"max-successful-attempts-per-tick-per-construction-queue"` | MaxSuccessfulAttemptsPerTickPerConstructionQueueModifier | SimpleModifier |
| `"character-health-bonus"` | CharacterHealthBonusModifier | SimpleModifier |
| `"mining-drill-productivity-bonus"` | MiningDrillProductivityBonusModifier | SimpleModifier |
| `"train-braking-force-bonus"` | TrainBrakingForceBonusModifier | SimpleModifier |
| `"worker-robot-battery"` | WorkerRobotBatteryModifier | SimpleModifier |
| `"laboratory-productivity"` | LaboratoryProductivityModifier | SimpleModifier |
| `"follower-robot-lifetime"` | FollowerRobotLifetimeModifier | SimpleModifier |
| `"artillery-range"` | ArtilleryRangeModifier | SimpleModifier |
| `"nothing"` | NothingModifier | BaseModifier |
| `"character-logistic-requests"` | CharacterLogisticRequestsModifier | BoolModifier |
| `"vehicle-logistics"` | VehicleLogisticsModifier | BoolModifier |
| `"unlock-space-location"` | UnlockSpaceLocationModifier | BaseModifier |
| `"unlock-quality"` | UnlockQualityModifier | BaseModifier |
| `"unlock-space-platforms"` | SpacePlatformsModifier | BoolModifier |
| `"unlock-circuit-network"` | CircuitNetworkModifier | BoolModifier |
| `"cargo-landing-pad-count"` | CargoLandingPadLimitModifier | SimpleModifier |
| `"change-recipe-productivity"` | ChangeRecipeProductivityModifier | BaseModifier |
| `"cliff-deconstruction-enabled"` | CliffDeconstructionEnabledModifier | BoolModifier |
| `"mining-with-fluid"` | MiningWithFluidModifier | BoolModifier |
| `"rail-support-on-deep-oil-ocean"` | RailSupportOnDeepOilOceanModifier | BoolModifier |
| `"rail-planner-allow-elevated-rails"` | RailPlannerAllowElevatedRailsModifier | BoolModifier |
| `"beacon-distribution"` | BeaconDistributionModifier | SimpleModifier |
| `"create-ghost-on-entity-death"` | CreateGhostOnEntityDeathModifier | BoolModifier |
| `"belt-stack-size-bonus"` | BeltStackSizeBonusModifier | SimpleModifier |

### BaseModifier (abstract base)

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `icons` | IconData[] | yes | - | Can't be an empty array. |
| `icon` | FileName | yes | - | Only loaded if `icons` is not defined. |
| `icon_size` | SpriteSizeType | yes | `64` | Only loaded if `icons` is not defined. |
| `hidden` | boolean | yes | `false` | |

### SimpleModifier (extends BaseModifier, abstract)

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `modifier` | double | **no** | - | Modification value, which will be added to the variable it modifies. |

All SimpleModifier children (like CharacterMiningSpeedModifier, LaboratorySpeedModifier, etc.) inherit `modifier` from SimpleModifier and have:
- `type` (literal, required)
- `infer_icon` (boolean, optional, default `false`)
- `use_icon_overlay_constant` (boolean, optional, default `true`)

### BoolModifier (extends BaseModifier, abstract)

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `modifier` | boolean | **no** | - | The state this modifier will be in upon researching. |

### NothingModifier

Can be used to show custom scripted effects in the technology GUI.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"nothing"` | **no** | - | |
| `use_icon_overlay_constant` | boolean | yes | `false` | If false, do not draw the small "constant" icon over the technology effect icon. |
| `effect_description` | LocalisedString | yes | - | |

### UnlockRecipeModifier

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"unlock-recipe"` | **no** | - | |
| `use_icon_overlay_constant` | boolean | yes | `false` | |
| `recipe` | RecipeID | **no** | - | Prototype name of the RecipePrototype that is unlocked upon researching. |

### UnlockSpaceLocationModifier

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"unlock-space-location"` | **no** | - | |
| `use_icon_overlay_constant` | boolean | yes | `false` | |
| `space_location` | SpaceLocationID | **no** | - | |

### UnlockQualityModifier

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"unlock-quality"` | **no** | - | |
| `use_icon_overlay_constant` | boolean | yes | `false` | |
| `quality` | QualityID | **no** | - | |

### GiveItemModifier

Note: when any technology prototype changes, the game re-applies all researched effects, including "give-item". Players will receive the item again.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"give-item"` | **no** | - | |
| `use_icon_overlay_constant` | boolean | yes | `false` | |
| `item` | ItemID | **no** | - | |
| `quality` | QualityID | yes | `"normal"` | |
| `count` | ItemCountType | yes | `1` | Must be >= 1. |

### AmmoDamageModifier

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"ammo-damage"` | **no** | - | |
| `infer_icon` | boolean | yes | `true` | If false, use icon from UtilitySprites. |
| `use_icon_overlay_constant` | boolean | yes | `true` | |
| `ammo_category` | AmmoCategoryID | **no** | - | Name of the AmmoCategory that is affected. |
| `modifier` | double | **no** | - | Added to the current ammo damage modifier upon researching. |

### GunSpeedModifier

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"gun-speed"` | **no** | - | |
| `infer_icon` | boolean | yes | `true` | |
| `use_icon_overlay_constant` | boolean | yes | `true` | |
| `ammo_category` | AmmoCategoryID | **no** | - | |
| `modifier` | double | **no** | - | Added to the current gun speed modifier upon researching. |

### TurretAttackModifier

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"turret-attack"` | **no** | - | |
| `infer_icon` | boolean | yes | `true` | |
| `use_icon_overlay_constant` | boolean | yes | `true` | |
| `turret_id` | EntityID | **no** | - | Name of the entity affected. Works for non-turrets (tanks), but bonus won't appear in tooltips. |
| `modifier` | double | **no** | - | Added to the current turret attack modifier. |

### ChangeRecipeProductivityModifier

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"change-recipe-productivity"` | **no** | - | |
| `use_icon_overlay_constant` | boolean | yes | `true` | |
| `recipe` | RecipeID | **no** | - | |
| `change` | EffectValue | **no** | - | |

### SpacePlatformsModifier (extends BoolModifier)

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"unlock-space-platforms"` | **no** | - | |
| `use_icon_overlay_constant` | boolean | yes | `false` | |
| (inherits `modifier`: boolean from BoolModifier) | | | | |

### CircuitNetworkModifier (extends BoolModifier)

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"unlock-circuit-network"` | **no** | - | |
| `use_icon_overlay_constant` | boolean | yes | `false` | |
| (inherits `modifier`: boolean from BoolModifier) | | | | |

---

## IngredientPrototype

Union type: `ItemIngredientPrototype | FluidIngredientPrototype`, loaded based on `type` key.

### ItemIngredientPrototype

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"item"` | **no** | - | |
| `name` | ItemID | **no** | - | |
| `amount` | uint16 | **no** | - | Cannot be 0. |
| `ignored_by_stats` | uint16 | yes | `0` | Amount not included in consumption statistics. Typically matches a product's ignored_by_stats. |

Examples:
```lua
{type="item", name="steel-plate", amount=8}
{type="item", name="iron-plate", amount=12}
```

### FluidIngredientPrototype

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"fluid"` | **no** | - | |
| `name` | FluidID | **no** | - | The name of a FluidPrototype. |
| `amount` | FluidAmount | **no** | - | Can not be <= 0. |
| `temperature` | float | yes | - | Sets the expected temperature of the fluid ingredient. |
| `minimum_temperature` | float | yes | - | If temperature is not set, sets expected minimum temperature. |
| `maximum_temperature` | float | yes | - | If temperature is not set, sets expected maximum temperature. |
| `ignored_by_stats` | FluidAmount | yes | `0` | Amount not included in consumption statistics. |
| `fluidbox_index` | uint32 | yes | `0` | Which CraftingMachinePrototype::fluid_boxes this ingredient uses. 1-based, separate for input/output. |
| `fluidbox_multiplier` | uint8 | yes | `2` | Used to set crafting machine fluidbox volumes. Must be at least 1. |

Example:
```lua
{type="fluid", name="water", amount=50}
```

---

## Product Prototypes

### ItemProductPrototype

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"item"` | **no** | - | |
| `name` | ItemID | **no** | - | The name of an ItemPrototype. |
| `amount` | uint16 | yes | - | |
| `amount_min` | uint16 | yes | - | Only loaded and mandatory if `amount` is not defined. |
| `amount_max` | uint16 | yes | - | Only loaded and mandatory if `amount` is not defined. If less than amount_min, amount_min is used. |
| `probability` | double | yes | `1` | Value between 0 and 1. Expected Value = `p * (0.5 * (max + min))`. When amount_min/max not provided, EV = `p * amount`. |
| `ignored_by_stats` | uint16 | yes | `0` | Amount not included in item production statistics. |
| `ignored_by_productivity` | uint16 | yes | Value of `ignored_by_stats` | Amount deducted from productivity bonus crafts. Ignored when allow_productivity is false. |
| `show_details_in_recipe_tooltip` | boolean | yes | `true` | Shows additional item tooltip when hovering over recipe. |
| `extra_count_fraction` | float | yes | `0` | Probability that a craft will yield one additional product. Also applies to bonus crafts from productivity. |
| `percent_spoiled` | float | yes | `0` | Must be >= 0 and < 1. |

### FluidProductPrototype

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"fluid"` | **no** | - | |
| `name` | FluidID | **no** | - | The name of a FluidPrototype. |
| `amount` | FluidAmount | yes | - | Can not be < 0. |
| `amount_min` | FluidAmount | yes | - | Only loaded and mandatory if `amount` is not defined. Can not be < 0. |
| `amount_max` | FluidAmount | yes | - | Only loaded and mandatory if `amount` is not defined. If less than amount_min, amount_min is used. |
| `probability` | double | yes | `1` | Value between 0 and 1. |
| `ignored_by_stats` | FluidAmount | yes | `0` | |
| `ignored_by_productivity` | FluidAmount | yes | Value of `ignored_by_stats` | |
| `temperature` | float | yes | - | The temperature of the fluid product. |
| `fluidbox_index` | uint32 | yes | `0` | Which CraftingMachinePrototype::fluid_boxes this product uses. 1-based, separate for input/output. |
| `show_details_in_recipe_tooltip` | boolean | yes | `true` | |

---

## SurfaceCondition

Requires Space Age to use.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `property` | SurfacePropertyID | **no** | - | |
| `min` | double | yes | Lowest double | |
| `max` | double | yes | Max double | |

Examples:
```lua
-- Planet restriction by name
surface_conditions = {
  { property = "surface-name", min = 1, max = 1 }  -- not exactly how it works; see below
}
-- By gravity
surface_conditions = {
  { property = "gravity", min = 1 }
}
-- By pressure
surface_conditions = {
  { property = "pressure", min = 100, max = 500 }
}
```

### SurfacePropertyID

Type alias for `string`. The name of a SurfacePropertyPrototype.

Examples: `"solar-power"`, `"magnetic-field"`, `"gravity"`, `"pressure"`, `"surface-name"`

### SurfacePropertyPrototype (Prototype, typename: "surface-property")

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `localised_unit_key` | string | yes | `"surface-property-unit.[name]"` | Locale key of the unit. __1__ is the value. |
| `default_value` | double | **no** | - | |
| `is_time` | boolean | yes | `false` | |

---

## IconData

One layer of an icon. Rendering order follows array order (higher index = drawn on top).

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `icon` | FileName | **no** | - | Path to the icon file. |
| `icon_size` | SpriteSizeType | yes | `64` | Size of the square icon in pixels. Must be > 0. |
| `tint` | Color | yes | `{r=1, g=1, b=1, a=1}` | Tint to apply to the icon. |
| `shift` | Vector | yes | `{0, 0}` | Offset from center. Shift values are "in pixels" where overall icon is assumed to be `expected_icon_size/2` pixels. |
| `scale` | double | yes | `(expected_icon_size / 2) / icon_size` | Expected icon sizes: 512 for starmap_icon, 256 for technology, 128 for achievement/ItemGroup, 32 for shortcut icons, 64 for everything else. |
| `draw_background` | boolean | yes | `true` for first layer, `false` otherwise | Outline drawn using signed distance field. |
| `floating` | boolean | yes | `false` | When true, layer is not considered for calculating bounds of the icon. |

Examples:
```lua
-- Single icon layer
{
  icon = "__base__/graphics/icons/fluid/heavy-oil.png",
  icon_size = 64,
  scale = 0.5,
  shift = {4, -8}
}

-- Layered icons
icons = {
  {
    icon = "__base__/graphics/icons/fluid/barreling/barrel-empty.png",
    icon_size = 32
  },
  {
    icon = "__base__/graphics/icons/fluid/barreling/barrel-empty-side-mask.png",
    icon_size = 32,
    tint = { a = 0.75, b = 0, g = 0, r = 0 }
  },
  {
    icon = "__base__/graphics/icons/fluid/crude-oil.png",
    icon_size = 32,
    scale = 0.5,
    shift = {7, 8}
  }
}
```

---

## EnergySource Types

### EnergySource (Union)

Loaded as one of the BaseEnergySource extensions based on the `type` key:
- `"electric"` -> ElectricEnergySource
- `"burner"` -> BurnerEnergySource
- `"heat"` -> HeatEnergySource
- `"fluid"` -> FluidEnergySource
- `"void"` -> VoidEnergySource

### BaseEnergySource (abstract base)

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `emissions_per_minute` | dict[AirbornePollutantID -> double] | yes | - | Pollution per minute at full energy consumption. Shown in entity tooltip. |
| `render_no_power_icon` | boolean | yes | `true` | Whether to render the "no power"/"no fuel" icon when low on power. |
| `render_no_network_icon` | boolean | yes | `true` | Whether to render the "no network" icon when not connected to electric network. |

### ElectricEnergySource

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"electric"` | **no** | - | |
| `buffer_capacity` | Energy | yes | - | How much energy this entity can hold. E.g. `"5MJ"` |
| `usage_priority` | ElectricUsagePriority | **no** | - | See below. |
| `input_flow_limit` | Energy | yes | Max double | Rate at which energy can be taken from the network. `0` = no transfer. E.g. `"300kW"` |
| `output_flow_limit` | Energy | yes | Max double | Rate at which energy can be provided to the network. `0` = no transfer. |
| `drain` | Energy | yes | - | Energy per second continuously removed from buffer. Shown as "Min. Consumption". Applied even when entity is inactive. E.g. `"1kW"` |

**ElectricUsagePriority values:**
| Value | Description |
|-------|-------------|
| `"primary-input"` | Most important machines (e.g. laser turrets) |
| `"primary-output"` | |
| `"secondary-input"` | All other machines |
| `"secondary-output"` | Steam generators |
| `"tertiary"` | Accumulators (input/output for overproduction/underproduction) |
| `"solar"` | Only for SolarPanelPrototype |
| `"lamp"` | Only for LampPrototype |

Examples:
```lua
energy_source = { type = "electric", emissions_per_minute = { pollution = 10 }, usage_priority = "secondary-input" }
energy_source = { type = "electric", buffer_capacity = "5MJ", usage_priority = "tertiary", input_flow_limit = "300kW", output_flow_limit = "300kW" }
energy_source = { type = "electric", usage_priority = "secondary-output" }
```

### BurnerEnergySource

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"burner"` | **no** | - | |
| `fuel_inventory_size` | ItemStackIndex | **no** | - | |
| `burnt_inventory_size` | ItemStackIndex | yes | `0` | |
| `smoke` | SmokeSource[] | yes | - | |
| `light_flicker` | LightFlickeringDefinition | yes | - | |
| `effectivity` | double | yes | `1` | 1 = 100%. Must be > 0. Multiplier of the energy output. |
| `burner_usage` | BurnerUsageID | yes | `"fuel"` | |
| `fuel_categories` | FuelCategoryID[] | yes | `{"chemical"}` | Fuel categories the energy source can use. |
| `initial_fuel` | ItemID | yes | `""` | |
| `initial_fuel_percent` | double | yes | `0.25` | |

### HeatEnergySource

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"heat"` | **no** | - | |
| `max_temperature` | double | **no** | - | Must be >= default_temperature. |
| `specific_heat` | Energy | **no** | - | |
| `max_transfer` | Energy | **no** | - | |
| `default_temperature` | double | yes | `15` | |
| `min_temperature_gradient` | double | yes | `1` | |
| `min_working_temperature` | double | yes | `15` | Must be >= default_temperature and <= max_temperature. |
| `minimum_glow_temperature` | float | yes | `1` | |
| `pipe_covers` | Sprite4Way | yes | - | |
| `heat_pipe_covers` | Sprite4Way | yes | - | |
| `heat_picture` | Sprite4Way | yes | - | |
| `heat_glow` | Sprite4Way | yes | - | |
| `connections` | HeatConnection[] | yes | - | May contain up to 32 connections. |
| `emissions_per_minute` | dict[AirbornePollutantID -> double] | yes | - | (Override from base) |

### FluidEnergySource

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"fluid"` | **no** | - | |
| `fluid_box` | FluidBox | **no** | - | Type must be "input" or "input-output". Must set scale_fluid_usage=true, fluid_usage_per_tick, or a filter. |
| `smoke` | SmokeSource[] | yes | - | |
| `light_flicker` | LightFlickeringDefinition | yes | - | |
| `effectivity` | double | yes | `1` | 1 = 100%. Must be > 0. |
| `burns_fluid` | boolean | yes | `false` | If true, power based on FluidPrototype::fuel_value. Otherwise based on temperature and heat_capacity. |
| `scale_fluid_usage` | boolean | yes | `false` | If true, consume as much fluid as required for desired power. Otherwise consume as much as allowed, wasting excess. |
| `destroy_non_fuel_fluid` | boolean | yes | `true` | When burns_fluid is true and fuel_value is 0, or when burns_fluid is false and fluid is at default_temperature: whether fluid should be destroyed. |
| `fluid_usage_per_tick` | FluidAmount | yes | `0` | If used with scale_fluid_usage, specifies the maximum. |
| `maximum_temperature` | float | yes | `0` | 0 = unlimited. Only loaded if burns_fluid is false. |

### VoidEnergySource

Provides unlimited free energy.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"void"` | **no** | - | |

Example:
```lua
energy_source = {type = "void"}
```

---

## FluidBox

Used to set the fluid amount an entity can hold and connection points for pipes.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `volume` | FluidAmount | **no** | - | Must be > 0. |
| `pipe_connections` | PipeConnectionDefinition[] | **no** | - | Connection points. Blue arrows in alt mode. Can't have more than 255 connections. |
| `filter` | FluidID | yes | - | Restrict which fluid is allowed. |
| `render_layer` | RenderLayer | yes | `"object"` | |
| `draw_only_when_connected` | boolean | yes | `false` | |
| `hide_connection_info` | boolean | yes | `false` | Hides the blue input/output arrows and icons at each connection point. |
| `volume_reservation_fraction` | float | yes | `0` | Fraction of volume "reserved" and cannot be removed by flow. Ignored if fluidbox is part of a fluid segment. |
| `pipe_covers` | Sprite4Way | yes | - | Pictures when no fluid box is connected. |
| `pipe_covers_frozen` | Sprite4Way | yes | - | |
| `pipe_picture` | Sprite4Way | yes | - | |
| `pipe_picture_frozen` | Sprite4Way | yes | - | |
| `mirrored_pipe_picture` | Sprite4Way | yes | - | Used when owner machine is flipped. Falls back to pipe_picture. |
| `mirrored_pipe_picture_frozen` | Sprite4Way | yes | - | Falls back to pipe_picture_frozen. |
| `minimum_temperature` | float | yes | - | Only applied if a filter is specified. |
| `maximum_temperature` | float | yes | - | Only applied if a filter is specified. |
| `max_pipeline_extent` | uint32 | yes | `UtilityConstants::default_pipeline_extent` | Max extent a pipeline with this fluidbox can span. |
| `production_type` | ProductionType | yes | `"none"` | One of: `"none"`, `"input"`, `"input-output"`, `"output"` |
| `secondary_draw_order` | int8 | yes | `1` | For all orientations. Higher = drawn on top. |
| `secondary_draw_orders` | FluidBoxSecondaryDrawOrders | yes | - | Per-orientation draw orders (north, east, south, west). Defaults to `secondary_draw_order`. |
| `always_draw_covers` | boolean | yes | `true` if pipe_picture not defined, `false` otherwise | |
| `enable_working_visualisations` | string[] | yes | - | Names of WorkingVisualisations to enable when this fluidbox is present. |

Example:
```lua
fluid_box = {
  volume = 200,
  pipe_covers = pipecoverspictures(),
  pipe_connections = {
    {flow_direction = "input-output", direction = defines.direction.west, position = {-1, 0.5}},
    {flow_direction = "input-output", direction = defines.direction.east, position = {1, 0.5}}
  },
  production_type = "input-output",
  filter = "water"
}
```

---

## Asteroid Types

### AsteroidSettings

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `spawning_rate` | double | **no** | - | |
| `max_ray_portals_expanded_per_tick` | uint32 | **no** | - | |

### AsteroidSpawnPoint (abstract base)

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `probability` | double | **no** | - | Must be >= 0. |
| `speed` | double | **no** | - | Must be > 0. |
| `angle_when_stopped` | float | yes | `1` | Facing north. Must be in [0, 1] range. |

### SpaceLocationAsteroidSpawnDefinition (extends AsteroidSpawnPoint)

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"entity"` \| `"asteroid-chunk"` | yes | `"entity"` | |
| `asteroid` | EntityID \| AsteroidChunkID | **no** | - | Type depends on `type`. |
| (inherits probability, speed, angle_when_stopped from AsteroidSpawnPoint) | | | | |

### SpaceConnectionAsteroidSpawnDefinition

Can be written as struct or tuple `{EntityID, SpaceConnectionAsteroidSpawnPoint[]}`.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `type` | `"entity"` \| `"asteroid-chunk"` | yes | `"entity"` | |
| `asteroid` | EntityID \| AsteroidChunkID | **no** | - | Type depends on `type`. |
| `spawn_points` | SpaceConnectionAsteroidSpawnPoint[] | **no** | - | |

### SpaceConnectionAsteroidSpawnPoint (extends AsteroidSpawnPoint)

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `distance` | double | **no** | - | |
| (inherits probability, speed, angle_when_stopped from AsteroidSpawnPoint) | | | | |

---

## TerritorySettings

Used for demolisher territory (segmented units like big worms on Vulcanus).

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `units` | EntityID[] | yes | - | Names of the SegmentedUnitPrototype. |
| `territory_index_expression` | string | yes | - | Mandatory if `units` is not empty. |
| `territory_variation_expression` | string | yes | `"0"` | Result converted to integer, clamped, used as index for `units` array. Negative = empty spawn location. |
| `minimum_territory_size` | uint32 | yes | `0` | Minimum number of chunks a territory must have. Below this, territory is deleted. |

---

## ProcessionSet

Lists arrivals and departures available for travel to a given surface.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `arrival` | ProcessionID[] | **no** | - | |
| `departure` | ProcessionID[] | **no** | - | |

---

## CliffPlacementSettings

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `name` | EntityID | yes | - | Name of the CliffPrototype. |
| `control` | AutoplaceControlID | yes | - | Name of the AutoplaceControl. |
| `cliff_elevation_0` | float | yes | `10` | Elevation at which the first row of cliffs is placed. Not settable from GUI. |
| `cliff_elevation_interval` | float | yes | `40` | Elevation difference between successive rows. Inversely proportional to 'frequency' in GUI: `40 / frequency`. |
| `cliff_smoothing` | float | yes | `1` | 0 = no smoothing, 1 = full smoothing. Straighter cliffs on rough elevation but less accurate placement. |
| `richness` | float | yes | - | Corresponds to 'continuity' in GUI. Larger values = longer unbroken walls; smaller values (0..1) = larger gaps. Used by 'cliffiness' noise expression which drives cliff placement when cliffiness > 0.5. |

---

## SurfacePropertyPrototype

(See SurfaceCondition section above for the type and its prototype.)

### PlanetPrototype.surface_properties

On `PlanetPrototype` (which extends `SpaceLocationPrototype`), the `surface_properties` field is:

```
surface_properties: dict[SurfacePropertyID -> double] (optional)
```

This maps surface property names to their values for that planet.

Example:
```lua
surface_properties = {
  ["day-night-cycle"] = 0,
  gravity = 40,
  pressure = 4000,
  ["solar-power"] = 400,
  ["magnetic-field"] = 99
}
```

---

## Supporting Map Gen Types

### MapGenSize

A floating point number specifying an amount. Can also be a string for backwards compatibility.

| String Value | Numeric Equivalent |
|-------------|-------------------|
| `"none"` | 0 |
| `"very-low"` / `"very-small"` / `"very-poor"` | 1/2 |
| `"low"` / `"small"` / `"poor"` | 1/sqrt(2) |
| `"normal"` / `"medium"` / `"regular"` | 1 |
| `"high"` / `"big"` / `"good"` | sqrt(2) |
| `"very-high"` / `"very-big"` / `"very-good"` | 2 |

The map generation algorithm supports 0 and values from 1/6 to 6.

### FrequencySizeRichness

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `frequency` | MapGenSize | yes | - | |
| `size` | MapGenSize | yes | - | |
| `richness` | MapGenSize | yes | - | |

### AutoplaceSettings

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `treat_missing_as_default` | boolean | yes | - | Whether missing autoplace names for this type should be default enabled. |
| `settings` | dict[(EntityID \| TileID \| DecorativeID) -> FrequencySizeRichness] | yes | - | Overrides the FrequencySizeRichness provided to the AutoplaceSpecification. Takes priority over control settings. |

---

## PlanetPrototype

Extends SpaceLocationPrototype.

| Property | Type | Optional | Default | Description |
|----------|------|----------|---------|-------------|
| `map_seed_offset` | uint32 | yes | CRC of name | |
| `entities_require_heating` | boolean | yes | `false` | (Space Age) |
| `pollutant_type` | AirbornePollutantID | yes | - | |
| `persistent_ambient_sounds` | PersistentWorldAmbientSoundsDefinition | yes | - | |
| `surface_render_parameters` | SurfaceRenderParameters | yes | - | |
| `player_effects` | Trigger | yes | - | |
| `ticks_between_player_effects` | MapTick | yes | `0` | |
| `map_gen_settings` | PlanetPrototypeMapGenSettings | yes | - | |
| `surface_properties` | dict[SurfacePropertyID -> double] | yes | - | |
| `lightning_properties` | LightningProperties | yes | - | |

### SpaceLocationPrototype (parent of PlanetPrototype)

Has additional relevant properties:
- `asteroid_spawn_definitions` - array of SpaceLocationAsteroidSpawnDefinition
- `asteroid_spawn_influence` - double
- `planet_procession_set` - ProcessionSet
- `solar_power_in_space` - double

### SpaceConnectionPrototype

Has:
- `asteroid_spawn_definitions` - array of SpaceConnectionAsteroidSpawnDefinition

---

## Additional Asteroid Type

### AsteroidChunkID

Type alias for `string`. The name of an AsteroidChunkPrototype.

### AsteroidGraphicsSet / AsteroidVariation

AsteroidVariation:
| Property | Type | Optional | Default |
|----------|------|----------|---------|
| `color_texture` | Sprite | **no** | - |
| `normal_map` | Sprite | **no** | - |
| `roughness_map` | Sprite | **no** | - |

---

## Key Type Aliases

| Type Alias | Underlying Type | Description |
|-----------|----------------|-------------|
| AutoplaceControlID | string | Name of an AutoplaceControl |
| EntityID | string | Name of an EntityPrototype |
| EntityIDFilter | string \| struct | Entity filter |
| ItemID | string | Name of an ItemPrototype |
| ItemIDFilter | string \| struct | Item filter |
| FluidID | string | Name of a FluidPrototype |
| RecipeID | string | Name of a RecipePrototype |
| QualityID | string | Name of a QualityPrototype |
| SpaceLocationID | string | Name of a SpaceLocationPrototype |
| AmmoCategoryID | string | Name of an AmmoCategory |
| FuelCategoryID | string | Name of a FuelCategory |
| SurfacePropertyID | string | Name of a SurfacePropertyPrototype |
| AsteroidChunkID | string | Name of an AsteroidChunkPrototype |
| TileID | string | Name of a TilePrototype |
| ProcessionID | string | Name of a ProcessionPrototype |
| BurnerUsageID | string | Name of a BurnerUsagePrototype |
| Energy | string | Energy amount like "5MJ", "300kW", "1W" |
| FluidAmount | double | Amount of fluid |
| ItemCountType | uint32 | Count of items |
| ItemStackIndex | uint16 | Index into item stack |
| Order | string | Ordering string |
| FileName | string | Path to a file |
| MathExpression | string | Mathematical expression string |
| LocalisedString | string \| array | Locale key or table |
| EffectValue | double | Effect modifier value |
| NoiseExpression | string \| boolean \| double | See NoiseExpression section |
