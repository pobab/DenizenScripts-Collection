DisplayText_Entity:
    type: entity
    debug: false
    entity_type: text_display
    # todo: bikin fiturnya terpisah dimulai dari background_color, text_shadowed

DisplayText_Editing:
    type: item
    material: writable_book
    display name: <&e>DisplayText Editing

DisplayText_Book:
    type: item
    material: written_book
    display name: DisplayText Tool

DisplayText_Selected:
    type: book
    title: DisplayText
    author: Pobab
    text:
    - <player.has_flag[DisplayText.selected].if_true[<player.flag[DisplayText.selected].text.proc[displaytext_proc_spaceseparated].substring[1,20]>...].if_false[<&4>Noting Selected]>
      <&nl><&m>                           <&r>
      <&nl><element[<&lb>←<&rb>].on_hover[Click to move backward].on_click[/dtext move backward 1]>
      <element[<&lb>→<&rb>].on_hover[Click to move forward].on_click[/dtext move forward 1]>
      <&nl><element[<&lb>Turn text shadowed<&rb>].on_click[/dtext text_shadowed]>
      <&nl><element[<&lb>Click to edit<&rb>]>


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
        ## todo: select text
        ## todo: menu select menggunakan buku
        ## todo: edit selected text
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
                - define text       <[value].text.proc[displaytext_proc_spaceseparated]>
                - define title      <[text].substring[1,17]>
                - define hover      "<[text]><&nl><&e>Click to settings"
                - define display    "<[loop_index]>. <[title].color[<&9>]><&9>..."
                - define textFormat:->:<[display].on_hover[<[hover]>].on_click[/dtext edit <[value]>]>
            - define book <item[written_book].with[book_author=DisplayText;book_title=Selecting<&sp>DisplayText;book_pages=<[textFormat].separated_by[<&nl>]>]>
            - adjust <player> show_book:<[book]>

        - case edit:
            - define selected   <[args].get[2]>
            - define entity     <entity[<[selected]>]>
            - define text       <[entity].text.split[<&nl>]>
            - define written    <map.with[pages].as[<[text]>]>
            - give <item[DisplayText_Editing].with[book=<[written]>;lore=<&7><[text].color[<&7>]>]>
            - flag <player> DisplayText.selected:<[entity]>

        - case move:
            - define direction <[args].get[2]>
            - if <[direction]> == forward:
                - define entity <player.flag[displaytext.selected]>
                - define location <[entity].location>
                - teleport <[entity]> <[location].forward[0.1]>
            - if <[direction]> == backward:
                - define entity <player.flag[displaytext.selected]>
                - define location <[entity].location>
                - teleport <[entity]> <[location].backward[0.1]>


DisplayText_Listener:
    type: world
    debug: false
    events:
        on player edits book:
        - stop if:<player.item_in_hand.script.exists.not>
        - stop if:<player.item_in_hand.script.name.equals[DisplayText_Editing].not>
        - define entity <player.flag[displaytext.selected]>

        - define book   <context.book>
        - define pages  <[book].book_pages>
        - foreach <[pages]>:
            - define text:->:<[value].proc[displaytext_proc_spaceseparated]>

        - adjust <[entity]> text:<[text].separated_by[<&nl>]>

        after player right clicks block with:DisplayText_Book:
        - adjust <player> show_book:DisplayText_Selected
        on player left clicks block with:DisplayText_Book:
        - define entity <player.flag[displaytext.selected]>
        - teleport <[entity]> <player.eye_location.ray_trace.forward[0.01]>
        - determine cancelled


DisplayText_Proc_SpaceSeparated:
    type: procedure
    definitions: text
    script:
    - determine <[text].split[<&nl>].space_separated>
