data:extend({
  {
    -- Number of foundation crafts before the Nauvis foundation recipe is disabled.
    -- Startup setting because it bakes into the foundation-platform-disable technology's
    -- research_trigger count at the data stage.
    type = "int-setting",
    name = "lava-block-foundation-limit",
    setting_type = "startup",
    default_value = 10000,
    minimum_value = 1,
    order = "a"
  },
  {
    type = "bool-setting",
    name = "lava-block-use-instabots",
    setting_type = "runtime-global",
    default_value = false
  },
  {
    type = "bool-setting",
    name = "lava-block-mech-armor-start",
    setting_type = "runtime-global",
    default_value = true
  }
})