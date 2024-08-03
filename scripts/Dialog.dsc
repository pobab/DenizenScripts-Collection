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
        - define entity <player.flag[dialog.entity]>
        - flag <[entity]> dialog.interact:!
        on click:
        - define slot <context.slot>
        - define entity     <player.flag[dialog.entity]>
        - define dialog     <[entity].flag[dialog.<player.uuid>.talk]>
        - define profession <[entity].profession>
        - if <[slot]> >= 30 && <[slot]> <= 36:
            - define section 1
            # todo: flag ke entity untuk melanjutkan dialog
            - if <player.has_flag[komisi.<[entity].uuid>]>:
                - narrate yay
            - else if <[dialog]> == work:
                - run Komisi_newTask def.player:<player> def.entity:<[entity]>
                # todo: get direct key button from dialog_data
        - if <[slot]> >= 3 && <[slot]> <= 9:
            - define section 2
        - stop if:!<[section].is_truthy>
        - define direct <script[dialog_data].data_key[<[dialog]>.<[profession]>.button.<[section]>.direct]||null>
        - announce <&9><[direct]>
        - if <[direct]> == close:
            - inventory close
        - else:
            - flag <[entity]> dialog.<player.uuid>.talk:<[direct]>
            - inventory close
            - wait 3t
            - run Dialog_Talk def.entity:<[entity]>


Dialog_UI:
    type: procedure
    debug: false
    definitions: entity
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
    debug: false
    definitions: entity
    script:
    - define result:->:<element[-178].proc[api_textoffset]><&f>
    - define result:->:<&chr[E1BC].font[dialog:gui]>
    - define result:->:<element[-170].proc[api_textoffset]>
    - define result:->:<&chr[E2BC].font[dialog:gui]>
    # todo: masalah dialog disini saat menggantinya gimana?
    - define interact       <[entity].flag[dialog.interact]>
    - define dialog         <[entity].flag[dialog.<[interact].uuid>.talk]>
    - define profession <[entity].profession>
    - define button_ui  <script[dialog_data].data_key[<[dialog]>.<[profession]>.button]||null>
    - determine <[result].unseparated> if:!<[button_ui].is_truthy>
    - foreach <[button_ui]>:
        - define array <[button_ui].keys.get[<[loop_index]>]>
        - define result[<[array].mul[2]>]:<&f><&chr[E<[array]>BD].font[dialog:gui]>
    - determine <[result].unseparated>

Dialog_TextUI:
    type: procedure
    debug: false
    definitions: entity
    script:
    - define result:->:<element[-165].proc[api_textoffset]><&r>
    - if <[entity].entity_type> == villager:
    # todo: masalah dialog disini saat menggantinya gimana?
        - define interact       <[entity].flag[dialog.interact]>
        - define dialog         <[entity].flag[dialog.<[interact].uuid>.talk]>
        - define profession     <[entity].profession>
        - define dialog_text    <script[dialog_data].data_key[<[dialog]>.<[profession]>.text]||null>
        - define dialog_text    <script[dialog_data].data_key[text]> if:!<[dialog_text].is_truthy>
        # todo: make procedure script to aligned text
        - foreach <[dialog_text]>:
            - if <[loop_index]> > 1:
                # get previous text for aligned second text to first text
                - define text <[dialog_text].get[<[loop_index].sub[1]>]>
                - define result:->:<[text].proc[Dialog_TextOffset]>
            - define result:->:<[value].font[dialog:text/row<[loop_index]>]>
            - if <[loop_index]> == <[dialog_text].size>:
                - define result:->:<[value].proc[Dialog_TextOffset]>
        - determine <[result].unseparated>
    - determine null

Dialog_ButtonTextUI:
    type: procedure
    debug: false
    definitions: entity
    script:
    - define result:->:<element[5].proc[api_textoffset]>
    # todo: masalah dialog disini saat menggantinya gimana?
    - define interact       <[entity].flag[dialog.interact]>
    - define dialog         <[entity].flag[dialog.<[interact].uuid>.talk]>
    - define profession <[entity].profession>
    - define button_text <script[dialog_data].data_key[<[dialog]>.<[profession]>.button]||null>
    - determine <[result].unseparated> if:!<[button_text].is_truthy>
    - foreach <[button_text]>:
        - define text <[value].get[text]>
        - if <[loop_index]> > 1:
            - define align <[button_text].deep_get[<[loop_index].sub[1]>.text]>
            - define result:->:<[align].proc[Dialog_TextOffset]>
        - define result:->:<[text].font[dialog:text/button_<[loop_index]>]>
    - determine <[result].unseparated||null>

Dialog_TextOffset:
    type: procedure
    debug: false
    definitions: text
    script:
    - if <[text].contains_text[<&sp>]>:
        - define result:->:<element[-<[text].text_width>].proc[api_textoffset]>
        # count text width of space text
        - define result:->:<element[<[text]>].split[<&sp>].size.sub[1].mul[2].proc[api_textoffset]>
    - else:
        - define result:->:<element[-<[text].text_width>].proc[api_textoffset]>
    - determine <[result].unseparated||null>


Dialog_Listener:
    type: world
    events:
        on player right clicks villager:
        - determine passively cancelled
        - ratelimit <player> 1s
        - stop if:<context.entity.has_flag[dialog.interact]>
        - run Dialog_Talk def.entity:<context.entity>


Dialog_Talk:
    type: task
    debug: false
    definitions: player|entity
    script:
    - define player <player> if:!<[player].exists>
    - define dialog     <[entity].proc[MobsBehaviour_VillagerSchedule]>
    - define profession <[entity].profession>
    - define inventory  <inventory[Dialog_GUI]>
    - flag <[player]> dialog.entity:<[entity]>
    - flag <[entity]> dialog.<[player].uuid>.talk:<[dialog]> if:!<[entity].has_flag[dialog.<[player].uuid>.talk]>
    - flag <[entity]> dialog.interact:<[player]>
    - adjust <[inventory]> title:<proc[Dialog_UI]><[entity].proc[dialog_buttonui]><[entity].proc[dialog_textui]><[entity].proc[dialog_buttontextui]>
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
                    text: Apakah ada yang bisa ku bantu?
                    direct: komisi
                2:
                    text: Baiklah...
                    direct: close
    komisi:
        armorer:
            text:
            - Pergilah menambang %target% %object%
            - jika kau memang ingin berguna!
            button:
                1:
                    text: Baiklah, akan aku kerjakan
                    direct: close
                2:
                    text: Boleh dipermudah gak? hehe...
                    direct: tawar
    working:
        armorer:
            text:
            - Sudahkah kamu menambang %target% %object%
            button:
                1:
                    text: Sudah
                    direct: komisi
                2:
                    text: Bisakah jumlahnya dikurangkan?
                    direct: close
