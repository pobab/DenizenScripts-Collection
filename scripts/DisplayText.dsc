DisplayText_Entity:
    type: entity
    debug: false
    entity_type: text_display
    # todo: bikin fiturnya terpisah dimulai dari background_color, text_shadowed
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
        ## todo: menu select menggunakan buku
        # todo: edit selected text
        # todo: move selected text
        - case add:
            - define location   <player.eye_location.ray_trace.forward[0.01]>
            - define text       <[args].get[2].to[<[args].size>]>
            - spawn DisplayText_Entity[text=<[text].separated_by[<&nl>]>] <[location]>

        - case removeall:
            - define entityText <player.world.entities[DisplayText_Entity]>
            - remove <[entityText]>
            - narrate "<&c>all DisplayText removed"

        - case select:
            - define entitiesText   <player.eye_location.ray_trace.find_entities[DisplayText_Entity].within[3]>
            - foreach <[entitiesText]>:
                - define text       <[value].text.split[<&nl>].space_separated>
                - define title      <[text].substring[1,17]>
                - define hover      "<[text]><&nl><&e>Click to settings"
                - define display    "<[loop_index]>. <[title]>..."
                - define textFormat:->:<[display].on_hover[<[hover]>].on_click[/dtext edit <[value]>]>
            - define book <item[written_book].with[book_author=DisplayText;book_title=Selecting<&sp>DisplayText;book_pages=<[textFormat].separated_by[<&nl>]>]>
            - adjust <player> show_book:<[book]>

        - case edit:
            - define selected   <[args].get[2]>
            - define entity     <entity[<[selected]>]>
            - define text       <[entity].text>
            - define written    <map[pages=<[text].split[<&nl>].space_separated>]>
            - give <item[writable_book].with[book=<[written]>]>
            - flag <player> DisplayText.selected:<[entity]>


DisplayText_Listener:
    type: world
    events:
        on player edits book:
        - narrate "Nice <context.material>"