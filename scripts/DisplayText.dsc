DisplayText_Entity:
    type: entity
    debug: false
    entity_type: text_display
    mechanisms:
        background_color: TRANSPARENT


DisplayText_Command:
    type: command
    name: displaytext
    usage: /displaytext
    description: Display the text like hologram text do
    permission: dscript.displaytext
    aliases:
    - dtext
    script:
    - define args <context.args>

    - if <[args].size> == 0:
        - narrate "input the text"
        - stop

    - define subcommand <[args].get[1]>
    - choose <[subcommand]>:
        # todo: select text
        # todo: menu select menggunakan buku
        # todo: edit selected text
        # todo: move selected text
        - case add:
            - define location <player.eye_location.ray_trace.forward[0.01]>
            - define text <[args].get[2].to[<[args].size>]>
            - spawn DisplayText_Entity[text=<[text].separated_by[<&nl>]>] <[location]>
        - case removeall:
            - define entityText <player.world.entities[DisplayText_Entity]>
            - remove <[entityText]>
            - narrate "<&c>all DisplayText removed"

            # /ex narrate <player.eye_location.ray_trace.find_entities[DisplayText_Entity].within[1]>
