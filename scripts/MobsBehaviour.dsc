MobsBehaviour_Listener:
    type: world
    debug: false
    events:
        on iron_golem dies:
        - determine passively no_xp
        - determine no_drops


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
