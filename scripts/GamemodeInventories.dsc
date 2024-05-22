GamemodeInventories_Listener:
    type: world
    debug: false
    events:
        on player changes gamemode:
        - define from   <player.gamemode>
        - define to     <context.gamemode>
        - flag <player> GamemodeInventories.<[from]>:<player.inventory.list_contents>
        - define newInv <player.flag[GamemodeInventories.<[to]>].if_null[<list>]>
        - inventory clear
        - inventory set destination:<player.inventory> origin:<[newInv]> if:!<[newInv].is_empty>
