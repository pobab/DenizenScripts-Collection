Komisi_Command:
    type: command
    name: komisi
    debug: false
    usage: /komisi
    description: komisi
    permission: dscript.komisi
    script:
    - foreach <player.proc[Komisi_uuidTask]> as:id:
        - narrate "<[loop_index]>. <player.proc[Komisi_getTask].context[<[id]>|profession]>:"
        - narrate "-<&gt> Object: <player.proc[Komisi_getTask].context[<[id]>|target]> <player.proc[Komisi_getTask].context[<[id]>|recent]>/<player.proc[Komisi_getTask].context[<[id]>|quantity]>"

Komisi_Listener:
    type: world
    debug: false
    events:
        on player breaks *_ore:
        - define object <context.material.name>
        - run Komisi_setTask def.player:<player> def.uuid:<player.proc[Komisi_uuidTask].context[armorer]> def.object:<[object]> def.value:+1

        on player kills entity:
        - define object <context.entity.entity_type>
        - run Komisi_setTask def.player:<player> def.uuid:<player.proc[Komisi_uuidTask].context[butcher]> def.object:<[object]> def.value:+1

        on player breaks brewing_stand:
        - flag <context.location> komisi:! if:<context.location.has_flag[komisi]>
        on player clicks in brewing:
        - stop if:<context.slot.is_less_than[1]>
        - stop if:!<context.clicked_inventory.inventory_type.equals[brewing]>
        - define inventory  <context.clicked_inventory>
        - define location   <[inventory].location>
        - flag <[location]> komisi.brewing.brews:<player> if:!<[location].has_flag[komisi.brewing.started]>
        after brewing starts:
        - define location   <context.location>
        - define inventory  <[location].inventory>
        - define player     <[location].flag[komisi.brewing.brews]> if:<[location].has_flag[komisi.brewing.brews]>
        - stop if:!<[player].exists>
        # flag komisi.brewing.started digunakan untuk mencegah perubahan player saat menyeduh potion berlangsung
        - flag <[location]> komisi.brewing.started
        - waituntil rate:1s max:25s <[location].brewing_time.is_less_than_or_equal_to[0]>
        - flag <[location]> komisi:!
        on brewing stand brews:
        - define location   <context.location>
        - define inventory  <[location].inventory>
        - define player     <[location].flag[komisi.brewing.brews]> if:<[location].has_flag[komisi.brewing.brews]>
        - stop if:!<[player].exists>
        - foreach <context.result> as:item:
            - foreach next if:!<[item].effects_data.exists>
            - define object <[item].effects_data.first.get[base_type]>
            - run Komisi_setTask def.player:<[player]> def.uuid:<[player].proc[Komisi_uuidTask].context[cleric]> def.object:<[object]> def.value:+1

        on player breaks wheat|beetroos|carrots|potatoes|melon|pumpkin:
        - stop if:!<context.material.age.exists>
        - define material   <context.material>
        - define object     <[material].name>
        - stop if:<[material].age.is_less_than[<[material].maximum_age>].or[<[object].equals[melon].not>].or[<[object].equals[pumpkin].not>]>
        - run Komisi_setTask def.player:<player> def.uuid:<player.proc[Komisi_uuidTask].context[farmer]> def.object:<[object]> def.value:+1

        on player fishes entity:
        - stop if:<context.xp.is_less_than_or_equal_to[0]>
        - define object <context.item.material.name>
        - run Komisi_setTask def.player:<player> def.uuid:<player.proc[Komisi_uuidTask].context[fisherman]> def.object:<[object]> def.value:+1


Komisi_newTask:
    type: task
    debug: false
    definitions: player|entity|quantity|profession
    script:
    - define uuid       <util.random_uuid>
    - define player     <player> if:!<[player].exists>
    - define quantity   <util.random.int[1].to[16]> if:!<[quantity].exists>
    - define profession <list[armorer|butcher|cleric|farmer|fisherman].random> if:!<[profession].exists>
    - if <[entity].exists>:
        - define uuid       <[entity].uuid>
        - define profession <[entity].profession> if:<[entity].profession.exists>
        - flag <[player]> komisi.<[uuid]>.entity:<[entity].entity_type>

    - if <[profession]> == armorer:
        - define target <list[iron_ore|gold_ore|coal_ore|diamond_ore].random>
    - else if <[profession]> == butcher:
        - define target <list[chicken|rabbit|pig|sheep|cow].random>
    - else if <[profession]> == cleric:
        - define target <server.potion_types.random>
    - else if <[profession]> == farmer:
        - define target <list[wheat|carrot|potato|beetroot|pumpkin|melon].random>
    - else if <[profession]> == fisherman:
        - define target <list[cod|salmon|pufferfish|tropical_fish].random>

    - flag <[player]> komisi.<[uuid]>.<[profession]>.<[target]>.recent:0
    - flag <[player]> komisi.<[uuid]>.<[profession]>.<[target]>.quantity:<[quantity]>


Komisi_uuidTask:
    type: procedure
    debug: false
    definitions: player|profession
    script:
    - determine <list> if:!<[player].has_flag[komisi]>
    - determine <[player].flag[komisi].keys> if:!<[profession].exists>

    - define task <[player].flag[komisi].deep_keys.filter[contains_text[<[profession]>]]>
    - foreach <[task]>:
        - define uuid:->:<[value].split[.].first>
    - determine <[uuid].deduplicate> if:<[uuid].exists>
    - determine <list>


Komisi_getTask:
    type: procedure
    debug: false
    definitions: player|uuid|data
    script:
    - determine null if:!<[data].exists>
    - determine null if:!<[player].has_flag[komisi]>
    - determine <[player].flag[komisi.<[uuid]>].keys.exclude[entity].first>         if:<[data].equals[profession]>
    - define profession <[player].proc[<script.name>].context[<[uuid]>|profession]>
    - determine <[player].flag[komisi.<[uuid]>.<[profession]>].keys.first>          if:<[data].equals[target]>
    - define target     <[player].proc[<script.name>].context[<[uuid]>|target]>
    - determine <[player].flag[komisi.<[uuid]>.<[profession]>.<[target]>.recent]>   if:<[data].equals[recent]>
    - determine <[player].flag[komisi.<[uuid]>.<[profession]>.<[target]>.quantity]> if:<[data].equals[quantity]>


Komisi_setTask:
    type: task
    debug: false
    definitions: player|uuid|object|value
    subscript:
        validate_value:
        - if !<[value].is_integer>:
            - narrate "<&4>value must integer" if:<player.has_permission[admin]>
            - foreach next
    script:
    - foreach <[uuid]> as:id:
        - define profession <[player].proc[Komisi_getTask].context[<[id]>|profession]>
        - define target     <[player].proc[Komisi_getTask].context[<[id]>|target]>
        - define recent     <[player].proc[Komisi_getTask].context[<[id]>|recent]>
        - define goal       <[player].proc[Komisi_getTask].context[<[id]>|quantity]>
        - if <[object].contains_text[=]>:
            - define object <[value].after[=]>
            - flag <[player]> komisi.<[id]>.<[profession]>.<[target]>.recent:<[recent]>
            - flag <[player]> komisi.<[id]>.<[profession]>.<[target]>.quantity:<[goal]>
            - flag <[player]> komisi.<[id]>.<[profession]>.<[object]>:!
            - define target <[target]>
        - foreach next if:!<[target].equals[<[object]>]>

        - foreach next if:!<[value].exists>
        - if <[value].contains_text[+]>:
            # todo: bikin fungsi ketika komisi completed
            - define value <[value].after[+]>
            - inject <script> path:subscript.validate_value
            - foreach next if:<[recent].is_more_than_or_equal_to[<[goal]>]>
            - flag <[player]> komisi.<[id]>.<[profession]>.<[object]>.recent:<[recent].add[<[value]>]>
            - define recent <[player].proc[Komisi_getTask].context[<[id]>|recent]>
            - narrate <&a>+<[value]>    if:<[recent].is_less_than[<[goal]>]>                targets:<[player]>
            - narrate <&2>complete      if:<[recent].is_more_than_or_equal_to[<[goal]>]>    targets:<[player]>
        - else if <[value].contains_text[-]>:
            - define value <[value].after[-]>
            - inject <script> path:subscript.validate_value
            - flag <[player]> komisi.<[id]>.<[profession]>.<[object]>.recent:<[recent].sub[<[value]>]>
        - else if <[value].contains_text[=]>:
            - define value <[value].after[=]>
            - inject <script> path:subscript.validate_value
            - flag <[player]> komisi.<[id]>.<[profession]>.<[object]>.recent:<[value]>
        - else:
            - inject <script> path:subscript.validate_value
            - flag <[player]> komisi.<[id]>.<[profession]>.<[object]>.quantity:<[value]>

