MobsBehaviour_Listener:
    type: world
    debug: false
    events:
        on iron_golem dies:
        - determine passively no_xp
        - determine no_drops

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


        # todo: only spawn in the end
        on phantom spawns because nutural:
        - determine cancelled if:!<context.location.world.name.contains_text[the_end]>


        # todo: only spawn in mineshaft
        on creeper spawns because nutural:
        - determine cancelled
