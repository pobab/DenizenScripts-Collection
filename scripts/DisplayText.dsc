# todo: feature rotation/flip
DisplayText_Entity:
    type: entity
    debug: false
    entity_type: text_display

DisplayText_Editing:
    type: item
    material: writable_book
    display name: <&e>DisplayText Editing

DisplayText_Book:
    type: item
    material: written_book
    display name: <&6>DisplayText Tool

DisplayText_Selected:
    type: book
    title: DisplayText
    author: Pobab
    text:
    - <player.proc[DisplayText_getEntityDisplay].text.proc[displaytext_proc_spaceseparated].substring[1,20].on_hover[<player.proc[DisplayText_getEntityDisplay].text>].if_null[<&4>Nothing Selected]>...
      <&nl><&m>                           <&r>
      <&nl>Move<&co> <element[<&lb>←<&rb>].on_hover[Click to move backward].on_click[/dtext move backward 1]>
      <element[<&lb>→<&rb>].on_hover[Click to move forward].on_click[/dtext move forward 1]>
      <&nl>Scale<&co> <element[<&lb>←→<&rb>].on_hover[Click to rescale width<&nl>Left Click to Increase<&nl>Right Click to Decrease].on_click[/dtext move backward 1]>
      <element[<&lb>↑↓<&rb>].on_hover[Click to rescale Height<&nl>Left Click to Increase<&nl>Right Click to Decrease].on_click[/dtext move forward 1]>
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
        - case add:
            - define location   <player.eye_location.ray_trace.forward[0.01]>
            - define text       <[args].get[2].to[<[args].size>]>
            - spawn DisplayText_Entity[text=<[text]>] <[location]>

        - case removeall:
            - define entityText <player.world.entities[DisplayText_Entity]>
            - remove <[entityText]>
            - narrate "<&c>all DisplayText removed"

        - case select:
            - if <[args].size> == 2:
                - define selecting  <[args].get[2]>
                - if !<entity[<[selecting]>].exists>:
                    - narrate "<&4>DisplayText not found"
                    - stop
                - define entity     <entity[<[selecting]>]>
                - flag <player> DisplayText.selected:<[entity]>
                - give displaytext_book
                - stop
            - define entitiesText <player.eye_location.ray_trace.find_entities[DisplayText_Entity].within[2]>
            - if <[entitiesText].is_empty>:
                - narrate "<&4>any DisplayText not found"
                - stop
            - foreach <[entitiesText]>:
                - define text       <[value].text.proc[displaytext_proc_spaceseparated]>
                - define title      <[text].substring[1,17]>
                - define hover      "<[text]><&nl><&e>Click to settings"
                - define display    "<[loop_index]>. <[title].color[<&9>]><&9>..."
                - define textFormat:->:<[display].on_hover[<[hover]>].on_click[/dtext select <[value]>]>
            - define book <item[written_book].with[book_author=DisplayText;book_title=Selecting<&sp>DisplayText;book_pages=<[textFormat].separated_by[<&nl>]>]>
            - adjust <player> show_book:<[book]>

        - case edit:
            - stop if:!<player.proc[displaytext_getentitydisplay].is_truthy>
            - define entity     <player.proc[DisplayText_getEntityDisplay]>
            - define text       <[entity].text.split[<&nl>]>
            - define written    <map.with[pages].as[<[text]>]>
            - give <item[DisplayText_Editing].with[book=<[written]>;lore=<&7><[text].color[<&7>]>]>

        - case move:
            - stop if:!<player.proc[displaytext_getentitydisplay].is_truthy>
            - define direction <[args].get[2]>
            - if <[direction]> == forward:
                - define entity     <player.proc[DisplayText_getEntityDisplay]>
                - define location   <[entity].location>
                - teleport <[entity]> <[location].forward[0.1]>
            - if <[direction]> == backward:
                - define entity     <player.proc[DisplayText_getEntityDisplay]>
                - define location   <[entity].location>
                - teleport <[entity]> <[location].backward[0.1]>

        - case text_shadowed:
            - define entity <player.proc[DisplayText_getEntityDisplay]>
            - if <[entity].text_shadowed>:
                - adjust <[entity]> text_shadowed:false
            - else:
                - adjust <[entity]> text_shadowed:true

        - case background_color:
            - define entity <player.proc[DisplayText_getEntityDisplay]>
            - if <[entity].text_shadowed>:
                - adjust <[entity]> background_color:<color[0,0,0,0]>
            - else:
                - adjust <[entity]> background_color:<color[0,0,0,64]>


DisplayText_Listener:
    type: world
    debug: false
    events:
        on player edits book:
        - stop if:!<player.item_in_hand.script.exists>
        - stop if:!<player.item_in_hand.script.name.equals[DisplayText_Editing]>
        - define entity <player.proc[DisplayText_getEntityDisplay]>

        - define book   <context.book>
        - define pages  <[book].book_pages>
        - foreach <[pages]>:
            - define text:->:<[value].proc[displaytext_proc_spaceseparated]>

        - adjust <[entity]> text:<[text].separated_by[<&nl>]>

        after player right clicks block with:DisplayText_Book:
        - adjust <player> show_book:DisplayText_Selected
        on player left clicks block with:DisplayText_Book:
        - determine passively cancelled
        - stop if:!<player.is_sneaking>
        - define entity <player.proc[DisplayText_getEntityDisplay]>
        - teleport <[entity]> <player.eye_location.ray_trace.forward[0.01]>


DisplayText_Proc_SpaceSeparated:
    type: procedure
    definitions: text
    script:
    - determine <[text].split[<&nl>].space_separated>

DisplayText_getEntityDisplay:
    type: procedure
    definitions: player
    script:
    - determine null if:!<player.has_flag[displaytext.selected]>
    - determine <player.flag[displaytext.selected]>
