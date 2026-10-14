-- Ethylene, made by taking the water back out of ethanol: bioethylene, as
-- Brazil makes it from cane spirit. It is the building block of most
-- plastic in the world. Here it goes with hydrochloric acid into PVC.
return {
    type = "fluid",
    name = "ethylene",
    subgroup = "fluid",
    default_temperature = 15,
    gas_temperature = -104,                      -- Boiling point in C
    heat_capacity = "1.5kJ",
    -- Pink, the one colour no other gas on the island has taken.
    base_color = { r = 0.94, g = 0.51, b = 0.75 },
    flow_color = { r = 1.00, g = 0.72, b = 0.88 },
    icon = "__LavaBlock-graphics__/graphics/icons/gas/ethylene.png",
    icon_size = 64,
    order = "a[gas]-m[methane]-b[ethylene]",
    auto_barrel = true,
}
