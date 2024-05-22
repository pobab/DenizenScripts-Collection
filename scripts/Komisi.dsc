Komisi_Listener:
    type: world
    events:
        on player fishes entity:
        - stop if:<context.xp.is_less_than_or_equal_to[0]>
        - define object <context.item.material.name>
        - run Komisi_progressTask def.player:<player> def.uuid:<player.proc[Komisi_uuidTask].context[fisherman]> def.object:<[object]>


Komisi_newTask:
    type: task
    definitions: player|entity
    script:
    - define quantity   <util.random.int[1].to[16]>
    - define profession <list[fisherman].random>
    # - define profession <list[fisherman|butcher|shepherd].random>

    - define uuid <util.random_uuid>
    - if <[entity].exists>:
        - define uuid <[entity].uuid>
        - define profession <[entity].profession> if:<[entity].profession.exists>
        - flag <[player]> komisi.<[uuid]>.entity:<[entity].entity_type>

    - if <[profession]> == fisherman:
        - define target <list[cod|salmon|pufferfish|tropical_fish].random>

    - flag <[player]> komisi.<[uuid]>.<[profession]>.<[target]>.recent:0
    - flag <[player]> komisi.<[uuid]>.<[profession]>.<[target]>.quantity:<[quantity]>


Komisi_uuidTask:
    type: procedure
    definitions: player|profession
    script:
    - define task <[player].flag[komisi].deep_keys.filter[contains_text[<[profession]>]]>
    - foreach <[task]>:
        - define uuid:->:<[value].split[.].first>
    - determine <[uuid].deduplicate> if:<[uuid].exists>
    - determine <list>


Komisi_progressTask:
    type: task
    definitions: player|uuid|object|value
    script:
    - foreach <[uuid]> as:id:
        - define profession <[player].flag[komisi.<[id]>].keys.first>
        - define target <[player].flag[komisi.<[id]>.<[profession]>].keys.first>
        - foreach next if:!<[target].equals[<[object]>]>

