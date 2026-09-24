-- The oldest way there is to make a brick: wet the crushed rock, tread it,
-- press it into a mould and leave it in the sun. This machine does the first
-- three; the sun is the item's own drying timer.
--
-- What it is really for is the furnace, not the lava. A brick out of the
-- chemical plant costs 5000 lava; crushed and fired it costs about 333, so
-- the smelting recipe is already a first-ten-minutes thing by the time
-- anyone reads this. What the crushing route still needs is a furnace and
-- fuel for the last step, and that is what drying replaces: the same bricks
-- out of the same gravel, with no kiln and no fuel, paid for in time and in
-- the space to stack them while they dry.
local pug_mill = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
pug_mill.name = "pug-mill"
pug_mill.minable.result = "pug-mill"
pug_mill.crafting_categories = { "adobe-mixing" }
pug_mill.crafting_speed = 1.0
-- Low. It turns a paddle through wet grit; it does not heat anything, and
-- the whole argument for the machine is that it costs no fuel.
pug_mill.energy_usage = "90kW"
pug_mill.next_upgrade = nil
pug_mill.fast_replaceable_group = nil

pug_mill.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    -- Almost nothing: mixing mud is not combustion. The Quench Pit pollutes
    -- twelve a minute for comparison, and a chemical plant four.
    emissions_per_minute = { pollution = 1 },
}

pug_mill.module_slots = 2
pug_mill.allowed_effects = { "speed", "consumption", "pollution", "productivity" }

-- Water in on the north face only. One inlet, filtered: the machine takes
-- exactly one fluid and a named filter puts its icon on the connection, so a
-- misplumbed pipe shows before it is built.
pug_mill.fluid_boxes = {
    {
        production_type = "input",
        filter = "water",
        volume = 400,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north,
              position = { 0, -1 } },
        },
    },
}
pug_mill.fluid_boxes_off_when_no_fluid_recipe = false

-- PLACEHOLDER GRAPHICS: the vanilla assembling machine 2, standing in until
-- the mill is modelled and rendered in Blender like every other machine here
-- (see docs/blender-renders.md). A look-alike machine must not ship.
pug_mill.icon = "__base__/graphics/icons/assembling-machine-2.png"
pug_mill.icon_size = 64
pug_mill.icons = nil

return pug_mill
