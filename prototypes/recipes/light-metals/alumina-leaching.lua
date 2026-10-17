-- The Bayer process, on basalt: crushed rock digested in hot caustic soda,
-- which takes the alumina into solution and leaves the rest. The liquor is
-- cooled, the alumina falls out as a white powder, and the caustic goes
-- back round - most of it.
--
-- 50 sodium hydroxide in, 40 back: ten consumed for four alumina, which is
-- what the losses to the red mud cost a real plant. The forty that comes
-- back is a catalyst, so productivity is kept off it; it multiplies the
-- alumina only.
--
-- Four alumina is two aluminium plates, so the eight aluminium in a low
-- density structure's ten duralumin plates come to forty gravel and forty
-- caustic soda.
return {
    type = "recipe",
    name = "alumina-leaching",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "basalt-gravel",    amount = 10 },
        { type = "fluid", name = "sodium-hydroxide", amount = 50 },
    },
    results = {
        { type = "item",  name = "alumina",          amount = 4 },
        { type = "fluid", name = "sodium-hydroxide", amount = 40, ignored_by_productivity = 40 },
    },
    main_product = "alumina",
    allow_productivity = true,
    crafting_machine_tint = {
        primary = { r = 0.92, g = 0.90, b = 0.86, a = 1.0 },
        secondary = { r = 0.70, g = 0.30, b = 0.20, a = 1.0 },
    },
}
