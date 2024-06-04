##ignorewarning unknown_key_inventory
##ignorewarning def_of_nothing
Dialog_GUI:
    type: inventory
    gui: true
    size: 9
    debug: false
    title: <script.name>
    inventory: chest
    procedural items:
    - define size <script.data_key[size]>
    - repeat <[size]>:
        - define result:->:<item[air]>

    - determine <[result]>
    listener:
        on open:
        - flag <player> dialog.inventories:<player.inventory.list_contents>
        - inventory clear
        on close:
        - inventory set destination:<player.inventory> origin:<player.flag[dialog.inventories]> if:<player.has_flag[dialog.inventories]>


Dialog_UI:
    type: procedure
    definitions: def
    script:
    - define result:->:<&f><element[-50].proc[api_textoffset]>
    - define result:->:<&chr[e001].font[dialog:gui]>
    - define result:->:<element[-239].proc[api_textoffset]>
    - define result:->:<&chr[e009].font[dialog:gui]>
    - define result:->:<element[-51].proc[api_textoffset]>
    - define result:->:<&chr[e018].font[dialog:gui]>
    - define result:->:<element[-8].proc[api_textoffset]>
    - define result:->:<&chr[e004].font[dialog:gui]><&r>
    - determine <[result].unseparated>

Dialog_ButtonUI:
    type: procedure
    definitions: button
    script:
    - define result:->:<element[-178].proc[api_textoffset]><&f>
    - define result:->:<&chr[E1BC].font[dialog:gui]>
    - define result:->:<element[-170].proc[api_textoffset]>
    - define result:->:<&chr[E2BC].font[dialog:gui]>
    - define result:->:<element[-165].proc[api_textoffset]><&r>
    - determine <[result].unseparated> if:!<[button].is_truthy>
    - foreach <[button]>:
        - define array <[button].keys.get[<[loop_index]>]>
        - define result[<[array].mul[2]>]:<&f><&chr[E<[array]>BD].font[dialog:gui]>
    - determine <[result].unseparated>


Dialog_Listener:
    type: world
    events:
        on player right clicks villager:
        - determine passively cancelled
        - ratelimit <player> 1s
        - run Dialog_Talk def.entity:<context.entity>


Dialog_Talk:
    type: task
    debug: false
    definitions: player|entity
    script:
    - define player <player> if:!<[player].exists>
    - define data   <script[dialog_data].data_key[text]>
    - if <[entity].exists>:
        - define profession <[entity].profession>
        - define clock      <[entity].world.time.proc[util_timeformat].context[24].split[:].first>
        - define direct     work                                                            if:<[clock].is_more_than_or_equal_to[8].and[<[clock].is_less_than_or_equal_to[12]>]>
        - define direct     <[player].flag[dialog.temp.direct]>                             if:<[player].has_flag[dialog.temp.direct]>
        - define data       <script[dialog_data].data_key[<[direct]>.<[profession]>]>       if:<script[dialog_data].data_key[<[direct]>.<[profession]>].exists>
        - define button     <[data].get[button]||null>

    - define inventory <inventory[Dialog_GUI]>
    - adjust <[inventory]> title:<proc[Dialog_UI]><&r><[button].proc[dialog_buttonui]>
    - inventory open d:<[inventory]>


Dialog_Data:
    type: data
    debug: false
    text:
    - aku adalah kesatria hitam dan
    - kesatria merah dan putih bekerja
    - raja pobab karena istri mereka
    - sang raja adalah penikmat tobrut
    - aku sebagai kesatria hitam bangga
    - karena guruku ialah fiqun master
    wander:
        armorer:
            text:
            - wander
            button:
                1:
                    text: wander
                    direct: close
                2:
                    text: wander
                    direct: komisi
    gather:
        armorer:
            text:
            - gather
            button:
                1:
                    text: wander
                    direct: close
                2:
                    text: wander
                    direct: komisi
    work:
        armorer:
            text:
            - Hey, aku sedang sibuk bekerja
            - tidak bisakah kamu berhenti
            - mengganggu ku?
            button:
                1:
                    text: wander
                    direct: close
                2:
                    text: wander
                    direct: komisi
    rumor:
        farmer:
            text:
            - yay
            button:
                1:
                    text: wander
                    direct: close
                2:
                    text: wander
                    direct: komisi
    komisi:
        armorer:
            text:
            - Pergilah menambang %target% %object%
            - jika kau memang ingin berguna!
            button:
                1:
                    text: wander
                    direct: close
                2:
                    text: wander
                    direct: komisi
