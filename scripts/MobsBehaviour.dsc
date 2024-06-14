MobsBehaviour_VillagerSchedule:
    type: procedure
    definitions: entity
    script:
    - determine null if:!<[entity].exists>
    - determine null if:!<[entity].entity_type.equals[villager]>
    - define time   <[entity].world.time>
    - define clock  <[time].proc[util_timeformat].context[24].split[:].first>
    - determine wander  if:<[clock].is_more_than_or_equal_to[6].and[<[clock].is_less_than[8]>]>
    - determine work    if:<[clock].is_more_than_or_equal_to[8].and[<[clock].is_less_than[12]>]>
    - determine gather  if:<[clock].is_more_than_or_equal_to[15].and[<[clock].is_less_than[16]>]>
    - determine wander  if:<[clock].is_more_than_or_equal_to[16].and[<[clock].is_less_than[18]>]>
    - determine sleep   if:<[clock].is_more_than_or_equal_to[18].and[<[clock].is_less_than[6]>]>
    - determine null



MobsBehaviour_Listener:
    type: world
    debug: false
    events:
        on iron_golem dies:
        - determine passively no_xp
        - determine no_drops


        # Prevent drop EXP in world the end
        on enderman dies:
        - determine no_xp if:<context.entity.location.world.name.contains_text[the_end]>


        # Witch will attack player when player attack them first
        on witch targets player:
        - determine cancelled if:!<context.entity.has_flag[MobsBehaviour.targets]>
        - determine cancelled if:!<context.entity.flag[MobsBehaviour.targets].contains[<player>]>
        on player damages witch:
        - stop if:<context.entity.flag[MobsBehaviour.targets].contains[<player>].is_truthy>
        - flag <context.entity> MobsBehaviour.targets:->:<player> expire:1m
        on witch damages player:
        - stop if:!<context.damager.flag[MobsBehaviour.targets].contains[<player>].is_truthy>
        - flag <context.entity> MobsBehaviour.targets:<-:<player>
        - flag <context.entity> MobsBehaviour.targets:->:<player> expire:1m


        # Reject bad omen from illager captain when killed
        on entity spawns because raid:
        - stop if:!<context.entity.equipment_map.get[helmet].exists>
        - define entity <context.entity>
        - stop if:!<[entity].equipment_map.get[helmet].contains[white_banner]>
        - flag <[entity]> mobsbehaviour.illager_captain
        on player kills entity:
        - stop if:!<context.entity.has_flag[mobsbehaviour.illager_captain]>
        - flag <player> mobsbehaviour.reject_bad_omen
        on player potion effects modified:
        - stop if:!<context.new_effect_data.contains_text[bad_omen].is_truthy>
        - stop if:!<player.has_flag[mobsbehaviour.reject_bad_omen]>
        - flag <player> mobsbehaviour.reject_bad_omen:!
        - determine cancelled


        # todo: only spawn in the end
        on phantom spawns because nutural:
        - determine cancelled if:!<context.location.world.name.contains_text[the_end]>


        # todo: only spawn in mineshaft
        on creeper spawns because nutural:
        - determine cancelled
