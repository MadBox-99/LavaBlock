local bio_lab = table.deepcopy(data.raw["lab"]["biolab"])
local inputs = bio_lab.inputs
table.insert(inputs, "lava-barrel")
bio_lab.inputs = inputs
data.raw["lab"]["biolab"] = bio_lab
--data:extend({bio_lab})