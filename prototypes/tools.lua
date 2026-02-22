data:extend(
    {
        require("prototypes.tools.lava-science-pack"),
        require("prototypes.tools.enchanted-science-pack"),
        require("prototypes.tools.xp-science-pack"),
        require("prototypes.tools.military-science-pack-2"),
        require("prototypes.tools.circuit-science-pack"),
    }
)

if mods["space-age"] then
    data:extend({
        require("prototypes.tools.pyroclast-science-pack"),
    })
end