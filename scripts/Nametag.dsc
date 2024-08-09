Nametag_Entity:
    type: entity
    debug: false
    entity_type: text_display
    mechanisms:
        scale: 2,2,2
        custom_name_visible: true


Nametag_Listener:
    type: world
    debug: false
    events:
        # Hide player nametag every join
        after player join:
        - team name:NametagHide add:<player> option:name_tag_visibility status:never

        after player right clicks player:
        - ratelimit <player> 3t
        - stop if:!<player.is_sneaking>
        - define target <context.entity>
        - stop if:<player.flag[nametag.shown].contains[<[target]>]||false>
        - while <player.is_spawned> && <player.is_online> && <player.is_sneaking>:
            - while next if:<player.flag[nametag.shown].contains[<[target]>]||false>
            - spawn Nametag_Entity[custom_name=<[target].name>] <[target].location.above[2]> save:oi
            - define nametag <entry[oi].spawned_entity>
            - mount <[nametag]>|<[target]>
            - adjust <server.online_players.exclude[<player>]> hide_entity:<[nametag]>
            - flag <player> nametag.shown:->:<[target]>
            - wait 1s
        - remove <[target].passenger> if:<[target].has_passenger>
        - flag <player> nametag.shown:<-:<[target]>

        on player quit:
        - remove <player.passenger> if:<player.has_passenger>
        - flag <player> nametag:! if:<player.has_flag[nametag]>
