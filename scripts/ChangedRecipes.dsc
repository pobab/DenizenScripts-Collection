ChangedRecipes_Listener:
    type: world
    debug: false
    remove_recipes:
    - define recipes <util.scripts.filter[contains[changedrecipes_]].parse[data_key[material].as[item]].parse[recipe_ids].exclude[null]>
    - foreach <[recipes]> as:recipe:
        - adjust server remove_recipes:<[recipe]>
    # # hapus sementara resep ender eye untuk disable the end
    # - adjust server remove_recipes:ender_eye
    events:
        on server start:
        - inject <script> path:remove_recipes
        on reload scripts:
        - inject <script> path:remove_recipes


ChangedRecipes_IronHelmet:
    type: item
    debug: false
    material: iron_helmet
    recipes:
        1:
            type: shaped
            input:
            - iron_ingot|iron_ingot|iron_ingot
            - iron_block|air|iron_block
            - air|air|air

ChangedRecipes_IronChestplate:
    type: item
    debug: false
    material: iron_chestplate
    recipes:
        1:
            type: shaped
            input:
            - iron_ingot|air|iron_ingot
            - iron_block|iron_block|iron_block
            - iron_ingot|iron_ingot|iron_ingot

ChangedRecipes_IronLeggings:
    type: item
    debug: false
    material: iron_Leggings
    recipes:
        1:
            type: shaped
            input:
            - iron_block|iron_ingot|iron_block
            - iron_ingot|air|iron_ingot
            - iron_ingot|air|iron_ingot

ChangedRecipes_IronBoots:
    type: item
    debug: false
    material: iron_boots
    recipes:
        1:
            type: shaped
            input:
            - iron_ingot|air|iron_ingot
            - iron_block|air|iron_block
            - air|air|air

ChangedRecipes_DiamondHelmet:
    type: item
    debug: false
    material: diamond_helmet
    recipes:
        1:
            type: shaped
            input:
            - diamond|diamond|diamond
            - diamond_block|air|diamond_block
            - air|air|air

ChangedRecipes_DiamondChestplate:
    type: item
    material: diamond_chestplate
    recipes:
        1:
            type: shaped
            input:
            - diamond|air|diamond
            - diamond_block|diamond_block|diamond_block
            - diamond|diamond|diamond

ChangedRecipes_DiamondLeggings:
    type: item
    debug: false
    material: diamond_Leggings
    recipes:
        1:
            type: shaped
            input:
            - diamond_block|diamond|diamond_block
            - diamond|air|diamond
            - diamond|air|diamond

ChangedRecipes_DiamondBoots:
    type: item
    debug: false
    material: diamond_boots
    recipes:
        1:
            type: shaped
            input:
            - diamond|air|diamond
            - diamond_block|air|diamond_block
            - air|air|air

ChangedRecipes_Beacon:
    type: item
    debug: false
    material: beacon
    recipes:
        1:
            type: shaped
            input:
            - glass|glass|glass
            - diamond_block|nether_star|diamond_block
            - obsidian|obsidian|obsidian

ChangedRecipes_ShulkerBox:
    type: item
    debug: false
    material: shulker_box
    recipes:
        1:
            type: shaped
            input:
            - air|shulker_shell|air
            - diamond|chest|diamond
            - air|shulker_shell|air

ChangedRecipes_FireworkRocket:
    type: item
    debug: false
    material: firework_rocket
    recipes:
        1:
            type: shapeless
            input: fire_charge|paper

ChangedRecipes_NetheriteIngot:
    type: item
    debug: false
    material: netherite_ingot
    recipes:
        1:
            type: shapeless
            input: netherite_scrap|netherite_scrap|netherite_scrap|netherite_scrap|gold_block|gold_block|gold_block|gold_block

ChangedRecipes_Chest:
    type: item
    debug: false
    material: Chest
    recipes:
        1:
            type: shaped
            input:
            - stripped_*_wood|stripped_*_log|stripped_*_wood
            - stripped_*_log|iron_ingot|stripped_*_log
            - stripped_*_wood|stripped_*_log|stripped_*_wood