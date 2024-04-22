Kenalan_Listener:
    type: world
    debug: false
    events:
        on player right clicks player:
        - stop if:<player.is_sneaking.not>
        # todo: kenalain oi oiii oiiiiii
        - narrate Nice

        after player toggles sneaking:
        - if !<context.state>:
            - stop if:<player.has_flag[kenalan].not>
            - remove <player.flag[kenalan]>
            - flag <player> kenalan:!
            - stop

        - while <player.is_spawned> && <player.is_online>:
            - stop if:<player.is_sneaking.not>
            - if <player.target.exists.not>:
                - if <player.has_flag[kenalan]>:
                    - remove <player.flag[kenalan]>
                    - flag <player> kenalan:!
                - wait 3t
                - while next
            - define target <player.target>
            - if <[target].is_player.not>:
                - if <player.has_flag[kenalan]>:
                    - remove <player.flag[kenalan]>
                    - flag <player> kenalan:!
                - wait 3t
                - while next
            - if <player.has_flag[kenalan]>:
                - wait 3t
                - while next
            - spawn text_display[custom_name=<[target].name>;custom_name_visible=true;scale=2,2,2] <[target].location.above[2]> save:oi
            - define nametag <entry[oi].spawned_entity>
            - mount <[nametag]>|<[target]>
            - adjust <[target]> hide_entity:<[nametag]>
            - flag <player> kenalan:<[nametag]>
            - wait 3t
