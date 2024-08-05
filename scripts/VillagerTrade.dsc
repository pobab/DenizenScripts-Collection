VillagerTrade_Listener:
    type: world
    events:
        after player closes merchant:
        - define entity     <context.entity>
        - define default    <[entity].flag[villagertrade.default]||null>
        - adjust <[entity]> trades:<[default]> if:<[default].is_truthy>
        after player breaks bedrock:
        - narrate "Nice <context.material>"


VillagerTrade_DeterminedExp:
    type: procedure
    definitions: entity
    description: return TradeTag
    script:
    - define trades <[entity].trades>
    - foreach <[trades]> as:trade:
        - define result:->:<[trade]> if:<[trade].villager_xp.is_less_than_or_equal_to[1]>
        - define result:->:<[trade].with[villager_xp=0]>
    - determine <[result]>


VillagerTrade_PerPlayer:
    type: task
    debug: false
    definitions: entity|player
    script:
    - define trades <[entity].trades>
    - define level  <[entity].villager_level>
    - flag <[entity]> villagertrade.perplayer.<[player].uuid>.<[level]>:<[entity].proc[VillagerTrade_DeterminedExp]>
    - flag <[entity]> villagertrade.perplayer.<[player].uuid>.recent:<[entity].proc[VillagerTrade_DeterminedExp]>


# todo: gunakan villager trade default hanya untuk randomize trade flag
VillagerTrade_OpenTrades:
    type: task
    definitions: entity|player
    script:
    - if !<[entity].has_flag[villagertrade.default]>:
        - flag <[entity]> villagertrade.default.trades:<[entity].trades>
    - adjust <[entity]> trades:<[entity].flag[villagertrade.perplayer.<[player].uuid>.recent]>
    - opentrades <[entity]>
