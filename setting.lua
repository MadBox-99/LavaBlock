local util = require("util")

data:extend({
    {
        type = "string-setting",
        name = util.mod_prefix .. "landfill-distribution-strategy",
        setting_type = "runtime-global",
        allowed_values = { "all-to-host", "divided-to-all-active-players", "replicate-for-all-active-players" },
        default_value = "all-to-host"
    },
    {
        type = "double-setting",
        name = util.mod_prefix .. "landfill-multiplier",
        setting_type = "runtime-global",
        minimum_value = 0.0,
        default_value = 1.0
    },
    {
        type = "bool-setting",
        name = util.mod_prefix .. "landfill-starting-island",
        setting_type = "runtime-global",
        default_value = true
    },
    {
        type = "int-setting",
        name = util.mod_prefix .. "starting-island-size",
        setting_type = "runtime-global",
        default_value = 50,
        minimum_value = 1
    }
})
