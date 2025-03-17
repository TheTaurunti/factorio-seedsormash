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


-- ====================

-- Set up recipes for mod to alter
local yumako_processing = data.raw["recipe"]["yumako-processing"]
local yumako_seed_processing = table.deepcopy(yumako_processing)
yumako_seed_processing.name = "som_yumako-seed-processing"

local jellynut_processing = data.raw["recipe"]["jellynut-processing"]
local jellynut_seed_processing = table.deepcopy(jellynut_processing)
jellynut_seed_processing.name = "som_jellynut-seed-processing"


-- Edit recipes
remove_recipe_result(yumako_processing, "yumako-seed")
remove_recipe_result(yumako_seed_processing, "yumako-mash")
yumako_seed_processing.ingredients[1].amount = 5
yumako_seed_processing.results[1].probability = nil
yumako_seed_processing.order = "a[seeds]-c[yumako-seed-processing]"
data:extend({ yumako_seed_processing })


remove_recipe_result(jellynut_processing, "jellynut-seed")
remove_recipe_result(jellynut_seed_processing, "jelly")
jellynut_seed_processing.ingredients[1].amount = 5
jellynut_seed_processing.results[1].probability = nil
jellynut_seed_processing.order = "a[seeds]-d[jellynut-seed-processing]"
data:extend({ jellynut_seed_processing })

-- Add to tech unlocks
local tech = data.raw["technology"]

table.insert(tech["yumako"].effects, { type = "unlock-recipe", recipe = "som_yumako-seed-processing" })
table.insert(tech["jellynut"].effects, { type = "unlock-recipe", recipe = "som_jellynut-seed-processing" })
