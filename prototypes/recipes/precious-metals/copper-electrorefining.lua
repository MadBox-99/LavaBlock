-- Copper plate hung in sulfuric acid as an anode and dissolved onto a pure
-- cathode by a current. The copper comes out purer; what does not
-- dissolve falls to the bottom of the tank as anode slime.
--
-- Ten plates and ten acid for nine plates and a slime: a plate in ten is
-- the price of the slime. The nine that come back are ignored by
-- productivity, which multiplies the slime only - otherwise the tank would
-- make copper.
return {
    type = "recipe",
    name = "copper-electrorefining",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "copper-plate",  amount = 10 },
        { type = "fluid", name = "sulfuric-acid", amount = 10 },
    },
    results = {
        { type = "item", name = "copper-plate", amount = 9, ignored_by_productivity = 9 },
        { type = "item", name = "anode-slime",  amount = 1 },
    },
    main_product = "anode-slime",
    allow_productivity = true,
    -- Reversed, a slime would recycle into two and a half copper plates for
    -- the one it cost.
    auto_recycle = false,
    crafting_machine_tint = {
        primary = { r = 0.20, g = 0.55, b = 0.80, a = 1.0 },
        secondary = { r = 0.80, g = 0.45, b = 0.20, a = 1.0 },
    },
}
