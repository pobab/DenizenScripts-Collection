Chat_Listener:
    type: world
    debug: false
    events:
        # todo: bikin walkie talkie
        on player chats:
        - if <player.item_in_hand.material.name> == grass_block || <player.item_in_offhand.material.name> == grass_block:
            - narrate "<&2>📻| <player.name>:<&f> <context.message>" targets:<server.online_players>
        - else:
            - narrate "<&7>🗣| <player.name>:<&f> <context.message>" targets:<player.location.find_players_within[25]>
        - determine cancelled
