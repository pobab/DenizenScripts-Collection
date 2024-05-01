# todo: feature rotation/flip
# todo: tiap subcommand dibikin task script
DisplayText_Entity:
    type: entity
    debug: false
    entity_type: text_display

DisplayText_Editing:
    type: item
    debug: false
    material: writable_book
    display name: <&e>DisplayText Editing

DisplayText_Book:
    type: item
    debug: false
    material: written_book
    display name: <&6>DisplayText Tool

DisplayText_Selected:
    type: book
    debug: false
    title: DisplayText
    author: Pobab
    text:
    - <player.proc[DisplayText_getEntity].text.proc[displaytext_proc_spaceseparated].substring[1,20].on_hover[<player.proc[DisplayText_getEntity].text>].if_null[<&4>Nothing Selected]>...
      <&nl><&m>                           <&r>
      <&nl>Move<&co> <element[<&lb>←<&rb>].on_hover[Click to move backward].on_click[/dtext move backward 1]>
      <element[<&lb>→<&rb>].on_hover[Click to move forward].on_click[/dtext move forward 1]>
      <&nl>Scale<&co> <element[<&lb><&4>←].on_hover[<&e>Rescale width<&nl><&c>Click ← to Decrease].on_click[/dtext scale decrease width 1]><element[<&2>→<&r><&rb>].on_hover[<&e>Rescale width<&nl><&a>Click → to Increase].on_click[/dtext scale increase width 1]>
      <element[<&lb><&2>↑].on_hover[<&e>Rescale height<&nl><&a>Click ↑ to Increase].on_click[/dtext scale increase height 1]><element[<&4>↓<&r><&rb>].on_hover[<&e>Rescale height<&nl><&c>Click ↓ to Decrease].on_click[/dtext scale decrease height 1]>
      <&nl><&nl>
      <element[<&lb>Turn text shadowed<&rb>].on_hover[<&e>Click to toggle text shadowed<&nl><&7>Current<&co> <&f><player.proc[displaytext_getentity].text_shadowed>].on_click[/dtext text_shadowed]>
      <&sp><&sp><&sp><&nbsp><&nbsp>
      <element[<&lb>Click to edit<&rb>]>
      <&nl><&nl><&nl><&nl><&nl><&nl>
      <&sp><player.eye_location.ray_trace.find_entities[DisplayText_Entity].within[1].is_empty.if_true[<&r>].if_false[<&lb>Select other Text<&rb>].on_click[/dtext select]>


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
            - if !<[args].get[2].exists>:
                - run DisplayText_Selecting
                - stop
            - define selecting <[args].get[2]>
            - run DisplayText_Select def:<[selecting]>

        - case edit:
            - stop if:!<player.proc[DisplayText_getEntity].is_truthy>
            - define entity     <player.proc[DisplayText_getEntity]>
            - define text       <[entity].text.split[<&nl>]>
            - define written    <map.with[pages].as[<[text]>]>
            - give <item[DisplayText_Editing].with[book=<[written]>;lore=<&7><[text].color[<&7>]>]>

        - case move:
            - stop if:!<player.proc[DisplayText_getEntity].is_truthy>
            - define direction <[args].get[2]>
            - if <[direction]> == forward:
                - define entity     <player.proc[DisplayText_getEntity]>
                - define location   <[entity].location>
                - teleport <[entity]> <[location].forward[0.1]>
            - if <[direction]> == backward:
                - define entity     <player.proc[DisplayText_getEntity]>
                - define location   <[entity].location>
                - teleport <[entity]> <[location].backward[0.1]>

        - case scale:
            - stop if:!<player.proc[DisplayText_getEntity].is_truthy>
            - stop if:<[args].size.is_less_than[3]>
            - define fluctuate  <[args].get[2]>
            - define shape      <[args].get[3]>
            - define value      <[args].get[4].if_null[1]>
            - run displaytext_rescale def:<[fluctuate]>|<[shape]>|<[value]>

        - case text_shadowed:
            - stop if:!<player.proc[DisplayText_getEntity].is_truthy>
            - define entity <player.proc[DisplayText_getEntity]>
            - if <[entity].text_shadowed>:
                - adjust <[entity]> text_shadowed:false
            - else:
                - adjust <[entity]> text_shadowed:true

        - case background_color:
            - stop if:!<player.proc[DisplayText_getEntity].is_truthy>
            - define entity <player.proc[DisplayText_getEntity]>
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
        - define entity <player.proc[DisplayText_getEntity]>
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
        - define entity <player.proc[DisplayText_getEntity]>
        - teleport <[entity]> <player.eye_location.ray_trace.forward[0.01]>


DisplayText_Rescale:
    type: task
    definitions: fluctuate|shape|value
    script:
    - define entity <player.proc[displaytext_getentity]>
    - define scale  <[entity].scale>
    - if <[fluctuate]> == increase:
        - if <[shape]> == width:
            - define rescale <location[<[scale].x.add[<[value]>]>,<[scale].y>,0]>
        - else if <[shape]> == height:
            - define rescale <location[<[scale].x>,<[scale].y.add[<[value]>]>,0]>
    - else if <[fluctuate]> == decrease:
        - if <[shape]> == width:
            - define rescale <location[<[scale].x.sub[<[value]>]>,<[scale].y>,0]>
        - else if <[shape]> == height:
            - define rescale <location[<[scale].x>,<[scale].y.sub[<[value]>]>,0]>
    - stop if:!<[rescale].exists>
    - stop if:<[rescale].x.equals[0].or[<[rescale].y.equals[0]>]>
    - adjust <[entity]> scale:<[rescale]>

DisplayText_Selecting:
    type: task
    debug: false
    script:
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

DisplayText_Select:
    type: task
    debug: false
    definitions: selecting
    script:
    - if !<entity[<[selecting]>].exists>:
        - narrate "<&4>DisplayText not found"
        - stop
    - define entity     <entity[<[selecting]>]>
    - run displaytext_setentity def:<[entity]>
    - stop if:<player.inventory.contains_item[DisplayText_Book]>
    - give displaytext_book

DisplayText_Background:
    # todo: background custom color
    # todo: reset background
    # todo: remove background
    type: task
    script:
    - define book <item[writable_book].with[book_author=DisplayText;book_title=BackgroundText;book_pages=<&r>]>
    - give <[book]>

DisplayText_Proc_SpaceSeparated:
    type: procedure
    debug: false
    definitions: text
    script:
    - determine <[text].split[<&nl>].space_separated>

DisplayText_getEntity:
    type: procedure
    debug: false
    definitions: player
    script:
    - determine null if:!<player.has_flag[displaytext.selected]>
    - determine <player.flag[displaytext.selected]>

DisplayText_setEntity:
    type: task
    definitions: entity
    script:
    - flag <player> displaytext.selected:<[entity]>
