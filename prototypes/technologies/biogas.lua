-- Straw and algae digested to methane, the methane reformed with steam to
-- hydrogen and carbon monoxide, and the two built back up into light oil
-- in the Fuel Plant.
--
-- After Synthetic ethanol, which is where the Fuel Plant comes from and
-- which itself needs the fermentation tank. After Algae cultivation for
-- the green algae, and Advanced oil processing because light oil has no
-- use before it - solid fuel from light oil and cracking both come with
-- it. All chemical science.
return {
    type = "technology",
    name = "biogas",
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/technology/bio-ethanol.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/methane.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "straw-digesting" },
        { type = "unlock-recipe", recipe = "algae-digesting" },
        { type = "unlock-recipe", recipe = "methane-reforming" },
        { type = "unlock-recipe", recipe = "light-oil-synthesis" },
    },
    prerequisites = { "synthetic-ethanol", "algae-cultivation", "advanced-oil-processing" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-b-j",
}
