data:extend({
    {
        type = "recipe",
        allow_productivity = true,
        crafting_machine_tint = {
            primary = {
                a = 1,
                b = 1,
                g = 0.186,
                r = 0.04
            },
            quaternary = {
                a = 1,
                b = 0.5,
                g = 0.3,
                r = 0.1
            },
            secondary = {
                a = 1,
                b = 1,
                g = 0.4,
                r = 0.2
            },
            tertiary = {
                a = 1,
                b = 1,
                g = 0.651,
                r = 0.6
            }
        },
        enabled = true,
        energy_required = 20,
        ingredients = {
            {
                amount = 3,
                name = "ice",
                type = "item"
            },
            {
                amount = 1,
                name = "lithium-plate",
                type = "item"
            }
        },
        main_product = "lava-science-pack",
        name = "lava-science-pack",
        results = {
            {
                amount = 1,
                name = "lava-science-pack",
                type = "item"
            }
        },
        surface_conditions = {
            {
                max = 300,
                min = 300,
                property = "pressure"
            }
        },

    },
})