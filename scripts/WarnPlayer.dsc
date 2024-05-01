WarnPlayer_WritableBook:
    type: item
    material: writable_book
    display name: <&e>Warning Book
    lore:
    - <&7>Write their warn


WarnPlayer_Command:
    type: command
    name: warnplayer
    usage: /warnplayer
    description: Give player a warning because they break the rules
    permission: dscript.warnplayer
    aliases:
    - warn
    script:
    - define args <context.args>
    - if <[args].size> == 0:
        - if !<player.has_flag[warn.target]>:
            - stop
        - stop if:<player.inventory.contains_item[warnplayer_writablebook]>
        - give warnplayer_writablebook
        - stop

    - define subcommand <[args].get[1]>
    - stop if:!<server.match_offline_player[<[subcommand]>].exists>
    - define target <server.match_offline_player[<[subcommand]>]>
    - adjust <player> show_book:<[target].proc[WarnPlayer_Book]>
    - flag <player> warn.target:<[target]>


WarnPlayer_Listener:
    type: world
    events:
        on player edits book:
        - stop if:!<player.item_in_hand.script.name.equals[WarnPlayer_WritableBook].is_truthy>
        - narrate "<&6>Signs the book to complete"
        - narrate "<&4>REMEMBER: <&c>Write the title as their warning"
        - announce <context.book>

        on player signs book:
        - stop if:!<player.item_in_hand.script.name.equals[WarnPlayer_WritableBook].is_truthy>
        - stop if:!<player.has_flag[warn.target]>
        - define target <player.flag[warn.target]>
        - define uuid   <util.random_uuid>
        - define time   <util.time_now>
        - define book   <context.book>
        - flag <[book]> time:<[time]>
        - announce <[book]>
        # - flag <[target]> warn.<[uuid]>.title:<[title]>
        # - flag <[target]> warn.<[uuid]>.time:<[time]>
        # - flag <[target]> warn.<[uuid]>.moderator:<player>
        - flag <[target]> warn.<[uuid]>.description:<[book].book_pages>
        # - take item:<[book]> from:<player.inventory>


WarnPlayer_Book:
    type: procedure
    definitions: target
    script:
    - if !<[target].exists>:
        - define target <player>
    - if !<[target].has_flag[warn]>:
        - define "pages:->:<&4>No Warning Found<&r>"
        - define "pages:->:<element[<&lb>Click to write<&rb>].on_click[/warn]>"
        - define book_pages <[pages].separated_by[<&nl>]>
        - determine <item[written_book].with[book_author=Atmin;book_title=Warnings;book_pages=<[book_pages]>]>
    - determine <item[written_book].with[book_author=Atmin;book_title=Warnings;book_pages=YaY]>
