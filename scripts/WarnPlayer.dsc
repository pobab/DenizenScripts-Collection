WarnPlayer_WritableBook:
    type: item
    material: writable_book
    display name: <&e>Warning Book


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
        - narrate "<&6>Signs the book to complete"
        - narrate "<&4>REMEMBER: <&c>Write the title as their warning"
        - stop

    - define subcommand <[args].get[1]>
    - stop if:!<server.match_offline_player[<[subcommand]>].exists>
    - define target <server.match_offline_player[<[subcommand]>]>
    - adjust <player> show_book:<[target].proc[WarnPlayer_Book]>
    - flag <player> warn.target:<[target]>


#todo: edit
#todo: delete
WarnPlayer_Listener:
    type: world
    events:
        on player edits book:
        - stop if:!<player.item_in_hand.script.name.equals[WarnPlayer_WritableBook].is_truthy>
        - narrate "<&6>Signs the book to complete"
        - narrate "<&4>REMEMBER: <&c>Write the title as their warning"

        after player signs book:
        - stop if:!<context.old_book.script.name.equals[WarnPlayer_WritableBook].is_truthy>
        - stop if:!<player.has_flag[warn.target]>
        - define target <player.flag[warn.target]>
        - define uuid   <util.random_uuid>
        - define time   <util.time_now>
        - define book   <context.book>
        - flag <[target]> warn.<[uuid]>:<item[written_book].with[book_author=<player.uuid>;book_title=<[book].book_title>;book_pages=<[book].book_pages>].with_flag[time:<[time]>]>
        #- take item:<[book]> from:<player.inventory>


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

    - define warnings <player.flag[warn].deep_exclude[target].keys>
    - foreach <[warnings]>:
        - define hover          <list>
        - define book           <player.flag[warn].get[<[value]>]>
        - define title          <[book].book_title>
        - define time           <[book].flag[time]>
        - define description    <[book].book_pages>
        - define hover:->:<&6><[title]>
        - define hover:->:<[description].space_separated>
        - define "hover:->:<&7>Time: <&f><[time].format[dd/MM/yyyy HH:mm]>"
        - define "hover:->:<&7>Moderator: <&f><[book].book_author.as[player].name>"
        - define "pages:->:<[loop_index]>. <[title].on_hover[<[hover].separated_by[<&nl>]>].on_click[/warn <[value]>]>"
    - define "pages:->:<element[<&lb>Click to write<&rb>].on_click[/warn]>"
    - define book_pages <[pages].separated_by[<&nl>]>
    - determine <item[written_book].with[book_author=Atmin;book_title=Warnings;book_pages=<[book_pages]>]>
