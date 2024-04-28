Kenalan_Listener:
    type: world
    debug: false
    events:
        on player right clicks player:
        - stop if:<player.is_sneaking.not>
        - define target <context.entity>
        # todo: kenalain oi oiii oiiiiii
        - stop if:<player.flag[temen.beneran].contains[<[target]>]>
        - if <player.flag[teman.calon].contains[<[target]>]>:
            - narrate "<&lt><player.name><&gt> <[target].name> kenalan yuk!"
            - stop
        - flag <player> teman.calon:->:<[target]>
        - flag <[target]> teman.calon:->:<player>
        - narrate "<&lt><player.name><&gt> <[target].name> kenalan yuk!"


        after player toggles sneaking:
        - if !<context.state>:
            - stop if:<player.has_flag[kenalan].not>
            - remove <player.flag[kenalan]>
            - flag <player> kenalan:!
            - stop

        - while <player.is_spawned> && <player.is_online>:
            - if <player.is_sneaking.not>:
                - stop if:<player.has_flag[kenalan].not>
                - remove <player.flag[kenalan]>
                - flag <player> kenalan:!
                - stop
            - if <player.target.exists.not>:
                - if <player.has_flag[kenalan]>:
                    - remove <player.flag[kenalan]>
                    - flag <player> kenalan:!
                - wait 3t
                - while next
            - define target <player.target>
            - if <player.flag[temen.beneran].contains[<[target]>].not>:
                - wait 3t
                - while next
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
