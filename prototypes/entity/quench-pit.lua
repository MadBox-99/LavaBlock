-- A hole in the crust with a machine built over it. Whatever you pipe in
-- goes down into the lava the island floats on and comes back as weather.
--
-- Why this exists: nothing in the mod produced a byproduct you were forced
-- to get rid of, so every surplus fluid had to be stored or the line had to
-- be throttled. That is the wrong kind of difficulty - it is bookkeeping,
-- not a decision. A sink makes the surplus a cost instead: you can always
-- get rid of it, and getting rid of it dirties the air.
--
-- The pollution is the whole balance. Quenching is free of items, free of
-- research after the first technology, and available from early on; if it
-- were clean it would be a button that deletes a problem. At 12 per minute
-- it is three chemical plants' worth of smoke for one pit, which is enough
-- that a base voiding a lot of fluid has to answer for it somewhere - and
-- the Bio Garden is the only thing on this island that answers.
local quench_pit = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
quench_pit.name = "quench-pit"
quench_pit.minable.result = "quench-pit"
quench_pit.crafting_categories = { "fluid-quenching" }
quench_pit.crafting_speed = 1.0
quench_pit.energy_usage = "150kW"
quench_pit.next_upgrade = nil
quench_pit.fast_replaceable_group = nil

quench_pit.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = 12 },
}

-- Efficiency modules are the point of having slots at all: they are the
-- only way to make voiding cleaner, which turns "how much do I dump" into a
-- question with an answer the player can buy. Productivity is deliberately
-- absent - there is no product to multiply, and quality would be nonsense.
quench_pit.module_slots = 2
quench_pit.allowed_effects = { "speed", "consumption", "pollution" }

-- One unfiltered input, reachable from all four sides. Unfiltered because
-- the machine's whole job is that it does not care what arrives; the recipe
-- decides what it drinks, and a pump's filter is what guards the line.
--
-- The buffer is deliberately large. A pit is fed by whatever overflows, in
-- surges rather than in a steady stream, and a small tank would back the
-- surge up into the pipe it is supposed to be relieving.
quench_pit.fluid_boxes = {
    {
        production_type = "input",
        volume = 2000,
        pipe_connections = {
            { flow_direction = "input", direction = defines.direction.north, position = { 0, -1 } },
            { flow_direction = "input", direction = defines.direction.east,  position = { 1, 0 } },
            { flow_direction = "input", direction = defines.direction.south, position = { 0, 1 } },
            { flow_direction = "input", direction = defines.direction.west,  position = { -1, 0 } },
        },
    },
}
quench_pit.fluid_boxes_off_when_no_fluid_recipe = false

-- PLACEHOLDER GRAPHICS. This is the vanilla chemical plant's model, standing
-- in until the pit is built and rendered in Blender like every other machine
-- here (see docs/blender-renders.md). It is a chemical plant on the map
-- today, which is exactly the kind of collision the mod's own rule against
-- look-alike machines forbids, so it does not ship in a release like this.
quench_pit.icon = "__base__/graphics/icons/chemical-plant.png"
quench_pit.icon_size = 64
quench_pit.icons = nil

return quench_pit
