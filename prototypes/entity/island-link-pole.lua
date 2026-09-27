-- A pole for crossing lava, not for powering a base. It reaches 64 tiles,
-- which is the engine's own limit on a wire, and it takes two wires: one in
-- and one out, so a line of them strung across the ocean is a transmission
-- line and not a second grid. The limit is enforced by script
-- (scripts/island-link-pole.lua); the prototype only makes a newly placed
-- pole reach for two neighbours rather than five.
--
-- Its supply area is kept tiny on purpose. A pole with a 64-tile reach and
-- a big pole's supply area would replace the big pole everywhere, not only
-- over the lava.
local pole = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
pole.name = "island-link-pole"
pole.minable.result = "island-link-pole"
pole.maximum_wire_distance = 64
pole.supply_area_distance = 1
pole.auto_connect_up_to_n_wires = 2
pole.fast_replaceable_group = nil
pole.next_upgrade = nil
pole.max_health = 300

-- The big pole's own sprite, painted hazard orange. It is a vanilla pole
-- with a different job, and at a glance on a crowded map it has to read as
-- "not the pole you wire your base with".
local TINT = { r = 1.00, g = 0.52, b = 0.20, a = 1.0 }
for _, layer in pairs(pole.pictures.layers) do
    if not layer.draw_as_shadow then
        layer.tint = TINT
    end
end

pole.icons = {
    { icon = "__base__/graphics/icons/big-electric-pole.png", icon_size = 64, tint = TINT },
}
pole.icon = nil

return pole
