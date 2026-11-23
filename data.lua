-- ===========
-- Setup Phase
-- ===========

local YUMAKO_FRUIT_ICON_PATH = "__space-age__/graphics/icons/yumako.png"
local YUMAKO_MASH_ICON_PATH = "__space-age__/graphics/icons/yumako-mash.png"
local YUMAKO_SEED_ICON_PATH = "__space-age__/graphics/icons/yumako-seed.png"

local JELLYNUT_FRUIT_ICON_PATH = "__space-age__/graphics/icons/jellynut.png"
local JELLYNUT_JELLY_ICON_PATH = "__space-age__/graphics/icons/jelly.png"
local JELLYNUT_SEED_ICON_PATH = "__space-age__/graphics/icons/jellynut-seed.png"

-- =====

local function remove_recipe_result(recipe, result_name_to_remove)
  if (not recipe.results) then return end

  local new_results = {}
  local removed_result = nil

  for _, result in ipairs(recipe.results) do
    local name = result.name

    if (name == result_name_to_remove)
    then
      removed_result = result
    else
      table.insert(new_results, result)
    end
  end

  recipe.results = new_results
  return removed_result
end

local function set_seedmash_icon(recipe, path_main, path_secondary, icon_shift)
  recipe.icons = {
    { icon = path_main },
    { icon = path_secondary, scale = 0.45, shift = icon_shift }
  }
end

-- ====================

-- Set up recipes for mod to alter
local yumako_processing = data.raw["recipe"]["yumako-processing"]
yumako_processing.auto_recycle = false
local yumako_seed_processing = table.deepcopy(yumako_processing)
yumako_seed_processing.name = "som_yumako-seed-processing"

local jellynut_processing = data.raw["recipe"]["jellynut-processing"]
jellynut_processing.auto_recycle = false
local jellynut_seed_processing = table.deepcopy(jellynut_processing)
jellynut_seed_processing.name = "som_jellynut-seed-processing"


-- Edit recipes
remove_recipe_result(yumako_processing, "yumako-seed")
yumako_processing.order = "a[seeds]-a[yumako-seed-processing]-a"

remove_recipe_result(yumako_seed_processing, "yumako-mash")
yumako_seed_processing.ingredients[1].amount = 5
yumako_seed_processing.results[1].independent_probability = nil
yumako_seed_processing.order = "a[seeds]-a[yumako-seed-processing]-b"
data:extend({ yumako_seed_processing })


remove_recipe_result(jellynut_processing, "jellynut-seed")
jellynut_processing.order = "a[seeds]-b[jellynut-seed-processing]-a"

remove_recipe_result(jellynut_seed_processing, "jelly")
jellynut_seed_processing.ingredients[1].amount = 5
jellynut_seed_processing.results[1].independent_probability = nil
jellynut_seed_processing.order = "a[seeds]-b[jellynut-seed-processing]-b"
data:extend({ jellynut_seed_processing })

-- Alter recipe icons to make seed and mash recipes visibly different
local shift_l = { -8, 8 }
local shift_r = { 8, 8 }

set_seedmash_icon(yumako_processing, YUMAKO_FRUIT_ICON_PATH, YUMAKO_MASH_ICON_PATH, shift_l)
set_seedmash_icon(yumako_seed_processing, YUMAKO_FRUIT_ICON_PATH, YUMAKO_SEED_ICON_PATH, shift_r)

set_seedmash_icon(jellynut_processing, JELLYNUT_FRUIT_ICON_PATH, JELLYNUT_JELLY_ICON_PATH, shift_l)
set_seedmash_icon(jellynut_seed_processing, JELLYNUT_FRUIT_ICON_PATH, JELLYNUT_SEED_ICON_PATH, shift_r)


-- Add to tech unlocks
local tech = data.raw["technology"]

table.insert(tech["yumako"].effects, { type = "unlock-recipe", recipe = "som_yumako-seed-processing" })
table.insert(tech["jellynut"].effects, { type = "unlock-recipe", recipe = "som_jellynut-seed-processing" })
