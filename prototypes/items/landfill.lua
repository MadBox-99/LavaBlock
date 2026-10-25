-- Landfill, from the start of the game. On the island it cannot be laid on
-- lava; it goes into the foundation platform, which can.
--
-- Vanilla's fifty stone, not the five it was here. At five it was ten times
-- cheaper than vanilla everywhere else too, so filling Gleba's wetlands
-- cost a tenth of what it should; the foundation takes one landfill instead
-- of ten, so the island pays the same fifty stone a foundation as before.
data.raw.recipe['landfill'].ingredients = { { type = "item", name = "stone", amount = 50 } }
data.raw.recipe['landfill'].enabled = true
data.raw.item['landfill'].stack_size = 500
