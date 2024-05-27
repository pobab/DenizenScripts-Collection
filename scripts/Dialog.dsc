##ignorewarning unknown_key_inventory
##ignorewarning def_of_nothing
Dialog_GUI:
    type: inventory
    gui: true
    size: 9
    debug: false
    title: <&f><script.parsed_key[ui_design].unseparated.split[;].parse_tag[<[parse_value].proc[Util_TextIdentifyInt].if_true[<[parse_value].proc[api_textoffset]>].if_false[<[parse_value]>]>].unseparated>
    inventory: chest
    ui_design:
    - ;-50;<&chr[e001].font[dialog:gui]>
    - ;-239;<&chr[e009].font[dialog:gui]>
    - ;-51;<&chr[e018].font[dialog:gui]>
    - ;-8;<&chr[e004].font[dialog:gui]>
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
        - define direct     working                                                         if:<[clock].is_more_than_or_equal_to[8].and[<[clock].is_less_than_or_equal_to[12]>]>
        - define direct     <[player].flag[dialog.temp.direct]>                             if:<[player].has_flag[dialog.temp.direct]>
        - define data       <script[dialog_data].data_key[<[direct]>.<[profession]>.text]>  if:<script[dialog_data].data_key[<[direct]>.<[profession]>.text].exists>
    - define result:->:<element[-178].proc[api_textoffset]>
    - define result:->:<&f><&chr[E005].font[dialog:gui]>
    - define result:->:<element[-170].proc[api_textoffset]>
    - define result:->:<&chr[E007].font[dialog:gui]>
    - define result:->:<element[-165].proc[api_textoffset]><&r>
    - foreach <[data]>:
        - if <[loop_index]> > 1:
            - define text <[data].get[<[loop_index].sub[1]>]>
            # Text Offset to make the dialog text align to left
            - if <[text].contains_text[<&sp>]>:
                - define result:->:<element[-<[text].text_width>].proc[api_textoffset]>
                # count text width of space text
                - define result:->:<element[<[text]>].split[<&sp>].size.sub[1].mul[2].proc[api_textoffset]>
            - else:
                - define result:->:<element[-<[text].text_width>].proc[api_textoffset]>
        - define result:->:<[value].font[dialog:text/row<[loop_index]>]>
    - define inventory <inventory[Dialog_GUI]>
    - adjust <[inventory]> title:<[inventory].title><&r><[result].unseparated>
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
    working:
        armorer:
            text:
            - Hey, aku sedang sibuk bekerja
            - tidak bisakah kamu berhenti
            - mengganggu ku?
            button_1:
                text: Ummm, Yeah... baiklah
                direct: close
            button_2:
                text: Apakah ada yang bisa ku bantu?
                direct: komisi
    rumor:
        farmer:
            text:
            - yay
            button_1:
                text: ok
                direct: talk
            button_2:
                text: can
                direct: komisi
    komisi:
        armorer:
            text:
            - Pergilah menambang %target% %object%
            - jika kau memang ingin berguna!
            button_1:
                text: Baiklah...
                direct: talk
            button_2:
                text: can
                direct: komisi
