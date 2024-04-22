Kenalan_Listener:
    type: world
    events:
        on player right clicks player:
        - stop if:<player.is_sneaking.not>
        # todo: kenalain oi oiii oiiiiii
        - narrate Nice

        on player toggles sneaking:
        - if !<context.state>:
            - remove <player.flag[kenalan]>
            - flag <player> kenalan:!
            - stop
        - stop if:<player.target.exists.not>

        - define target <player.target>
        - stop if:<[target].is_player.not>

        # todo: remove nametag ketika player berhenti melihat target
        # - spawn text_display[text=<[target].name>] <[target].location> save:oi
        - spawn text_display[custom_name=<[target].name>;custom_name_visible=true;scale=2,2,2] <[target].location.above[2]> save:oi
        - define nametag <entry[oi].spawned_entity>
        - mount <[nametag]>|<[target]>
        - adjust <[target]> hide_entity:<[nametag]>
        - flag <player> kenalan:->:<[nametag]>
