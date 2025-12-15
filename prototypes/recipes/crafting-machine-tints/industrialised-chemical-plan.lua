local function deep_replace(insrc, inorg, intarget)
    for k, v in pairs(insrc) do
        if (type(v) == "table") then
            deep_replace(v, inorg, intarget);
        elseif (v == inorg) then
            insrc[k] = table.deepcopy(intarget);
        end
    end
end

data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set.default_recipe_tint =
{
    primary = { r = 0.75, g = 0.75, b = 1, a = 1 },
    secondary = { r = 1, g = 0.5, b = 0, a = 1 },
    tertiary = { r = 1, g = 0.85, b = 0.75, a = 1 },
    quaternary = { r = 1, g = 1, b = 0, a = 1 },
};
data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set.working_visualisations[5].apply_recipe_tint =
"none";

local pool_graphic = {
    animation = {
        filename = "__LavaBlock__/graphics/entity/industrialised-chemical-plan/biochamber-sluge.png",
        animation_speed = 0.75,
        frame_count = 64,
        height = 144,
        line_length = 8,
        priority = "extra-high",
        scale = 0.5,
        shift = { 0.734375, -0.296875 },
        width = 92
    },
    apply_recipe_tint = "primary"
};
table.insert(data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set.working_visualisations, 6,
    pool_graphic);
--secondary,sec:the checking window
data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set.working_visualisations[4].apply_recipe_tint =
"secondary";
deep_replace(data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set.working_visualisations[4],
    "__space-age__/graphics/entity/biochamber/biochamber-glow-2.png",
    "__LavaBlock__/graphics/entity/industrialised-chemical-plan/biochamber-glow-2.png");
--tertiary the main pool color
data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set.working_visualisations[1].apply_recipe_tint =
"tertiary";
deep_replace(data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set.working_visualisations[1],
    "__space-age__/graphics/entity/biochamber/biochamber-animation-dome.png",
    "__LavaBlock__/graphics/entity/industrialised-chemical-plan/biochamber-animation-dome.png");
--quaternary the secondary pool color
data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set.working_visualisations[3].apply_recipe_tint =
"quaternary";
deep_replace(data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set.working_visualisations[3],
    "__space-age__/graphics/entity/biochamber/biochamber-glow.png",
    "__LavaBlock__/graphics/entity/industrialised-chemical-plan/biochamber-glow.png");

--and finally add gray windows
local sidepanel_graphic = {
    animation = {
        filename = "__LavaBlock__/graphics/entity/industrialised-chemical-plan/biochamber-windows.png",
        animation_speed = 0.75,
        frame_count = 64,
        height = 144,
        line_length = 8,
        priority = "extra-high",
        scale = 0.5,
        shift = { 0.734375, -0.296875 },
        width = 92
    },
    fadeout = true,
};
table.insert(data.raw["assembling-machine"]["industrialised-chemical-plan"].graphics_set.working_visualisations, 1,
    sidepanel_graphic);

local function apply(src, dst)
    for k, v in pairs(src) do
        if (v == "setnil") then
            dst[k] = nil;
        elseif (type(v) == "table") then
            dst[k] = table.deepcopy(v);
        else
            dst[k] = v;
        end
    end
end;

apply({
    crafting_machine_tint = {
        primary = { r = 0.75, g = 1, b = 0.75, a = 1 },
        secondary = { r = 1, g = 1, b = 1, a = 1 },
        tertiary = { r = 0.75, g = 0.65, b = 0.50, a = 1 },
        quaternary = { r = 0, g = 1, b = 0, a = 1 },
    }
}, data.raw.recipe["industrialised-chemical-plan"]);

apply({
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 1, g = 1, b = 0, a = 1 },
}, data.raw.recipe["agricultural-science-pack"].crafting_machine_tint);

apply({
    primary = { r = 0.5, g = 0, b = 0.5, a = 1 },
    secondary = { r = 1, g = 0.35, b = 0.2, a = 1 },
    tertiary = { r = 1, g = 0.2, b = 0, a = 1 },
    quaternary = { r = 0, g = 1, b = 0, a = 1 },
}, data.raw.recipe["bioflux"].crafting_machine_tint);

apply({
    tertiary = { r = 1, g = 1, b = 0, a = 1 },
    quaternary = { r = 1, g = 0, b = 0, a = 1 },
}, data.raw.recipe["yumako-processing"].crafting_machine_tint);
apply({
    tertiary = { r = 0.35, g = 1, b = 0.35, a = 1 },
    quaternary = { r = 0.75, g = 0, b = 0.75, a = 1 },
}, data.raw.recipe["jellynut-processing"].crafting_machine_tint);
apply({
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 1, g = 0.7, b = 0.5, a = 1 },
}, data.raw.recipe["wood-processing"].crafting_machine_tint);

apply({
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 0, g = 0.25, b = 0.5, a = 1 },
}, data.raw.recipe["iron-bacteria"].crafting_machine_tint);
apply({
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 0, g = 0.5, b = 1, a = 1 },
}, data.raw.recipe["iron-bacteria-cultivation"].crafting_machine_tint);

apply({
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 1, g = 0.5, b = 0, a = 1 },
}, data.raw.recipe["copper-bacteria"].crafting_machine_tint);
apply({
    tertiary = { r = 1, g = 0.7, b = 0.2, a = 1 },
    quaternary = { r = 1, g = 0.5, b = 0, a = 1 },
}, data.raw.recipe["copper-bacteria-cultivation"].crafting_machine_tint);


apply({
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 1, g = 0.5, b = 0.5, a = 1 },
}, data.raw.recipe["rocket-fuel-from-jelly"].crafting_machine_tint);
apply({
    tertiary = { r = 0.9, g = 1, b = 0.9, a = 1 },
    quaternary = { r = 0, g = 0.2, b = 0, a = 1 },
}, data.raw.recipe["biolubricant"].crafting_machine_tint);
apply({
    tertiary = { r = 1, g = 1, b = 1, a = 0 },
    quaternary = { r = 1, g = 1, b = 1, a = 0 },
}, data.raw.recipe["bioplastic"].crafting_machine_tint);
apply({
    tertiary = { r = 1, g = 1, b = 0, a = 1 },
    quaternary = { r = 1, g = 1, b = 1, a = 1 },
}, data.raw.recipe["biosulfur"].crafting_machine_tint);
apply({
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 0, g = 0, b = 0, a = 1 },
}, data.raw.recipe["burnt-spoilage"].crafting_machine_tint);

apply({
    tertiary = { r = 0, g = 0, b = 1, a = 1 },
    quaternary = { r = 1, g = 0, b = 0, a = 1 },
}, data.raw.recipe["carbon-fiber"].crafting_machine_tint);

apply({
    primary = { r = 0.8, g = 0.9, b = 1, a = 1 },
    secondary = table.deepcopy(data.raw.recipe["pentapod-egg"].crafting_machine_tint.primary),
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 0, g = 1, b = 0, a = 1 },
}, data.raw.recipe["pentapod-egg"].crafting_machine_tint);
apply({
    primary = { r = 0.8, g = 0.9, b = 1, a = 1 },
    secondary = { r = 1, g = 0, b = 0, a = 1 },
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 0.5, g = 0.5, b = 1, a = 1 },
}, data.raw.recipe["fish-breeding"].crafting_machine_tint);

--nutrients
apply({
    primary = { r = 0.8, g = 0.9, b = 1, a = 1 },
    secondary = { r = 0, g = 0, b = 0, a = 1 },
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 1, g = 1, b = 1, a = 1 },
}, data.raw.recipe["nutrients-from-spoilage"].crafting_machine_tint);
apply({
    primary = { r = 0.8, g = 0.9, b = 1, a = 1 },
    secondary = { r = 1, g = 0.5, b = 0, a = 1 },
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 1, g = 1, b = 1, a = 1 },
}, data.raw.recipe["nutrients-from-yumako-mash"].crafting_machine_tint);
apply({
    primary = { r = 0.8, g = 0.9, b = 1, a = 1 },
    secondary = { r = 1, g = 0.35, b = 0.2, a = 1 },
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 1, g = 1, b = 1, a = 1 },
}, data.raw.recipe["nutrients-from-bioflux"].crafting_machine_tint);

apply({
    primary = { r = 0.8, g = 0.9, b = 1, a = 1 },
    secondary = { r = 1, g = 0.5, b = 0, a = 1 },
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 1, g = 1, b = 1, a = 1 },
}, data.raw.recipe["nutrients-from-biter-egg"].crafting_machine_tint);
apply({
    primary = { r = 0.8, g = 0.9, b = 1, a = 1 },
    secondary = { r = 1, g = 0, b = 0, a = 1 },
    tertiary = { r = 1, g = 1, b = 1, a = 1 },
    quaternary = { r = 1, g = 1, b = 1, a = 1 },
}, data.raw.recipe["nutrients-from-fish"].crafting_machine_tint);