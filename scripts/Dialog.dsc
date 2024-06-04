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
    definitions: entity
    script:
    - define result:->:<element[-178].proc[api_textoffset]><&f>
    - define result:->:<&chr[E1BC].font[dialog:gui]>
    - define result:->:<element[-170].proc[api_textoffset]>
    - define result:->:<&chr[E2BC].font[dialog:gui]>
    - define result:->:<element[-165].proc[api_textoffset]><&r>
    - define dialog     <[entity].proc[MobsBehaviour_VillagerSchedule]>
    - define profession <[entity].profession>
    - define button_ui  <script[dialog_data].data_key[<[dialog]>.<[profession]>.button]||null>
    - determine <[result].unseparated> if:!<[button_ui].is_truthy>
    - foreach <[button_ui]>:
        - define array <[button_ui].keys.get[<[loop_index]>]>
        - define result[<[array].mul[2]>]:<&f><&chr[E<[array]>BD].font[dialog:gui]>
    - determine <[result].unseparated>

Dialog_TextUI:
    type: procedure
    definitions: entity
    script:
    - if <[entity].entity_type> == villager:
        - define dialog         <[entity].proc[MobsBehaviour_VillagerSchedule]>
        - define profession     <[entity].profession>
        - define dialog_text    <script[dialog_data].data_key[<[dialog]>.<[profession]>.text]||null>
        - define dialog_text    <script[dialog_data].data_key[text]> if:!<[dialog_text].is_truthy>
        - foreach <[dialog_text]>:
            - if <[loop_index]> > 1:
                - define text <[dialog_text].get[<[loop_index].sub[1]>]>
                # Text Offset to make the dialog text align to left
                - if <[text].contains_text[<&sp>]>:
                    - define result:->:<element[-<[text].text_width>].proc[api_textoffset]>
                    # count text width of space text
                    - define result:->:<element[<[text]>].split[<&sp>].size.sub[1].mul[2].proc[api_textoffset]>
                - else:
                    - define result:->:<element[-<[text].text_width>].proc[api_textoffset]>
            - define result:->:<[value].font[dialog:text/row<[loop_index]>]>
        - determine <[result].unseparated>
    - determine null


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
    - define inventory <inventory[Dialog_GUI]>
    - adjust <[inventory]> title:<proc[Dialog_UI]><[entity].proc[dialog_buttonui]><[entity].proc[dialog_textui]>
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
