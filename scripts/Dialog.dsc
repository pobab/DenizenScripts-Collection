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
    - ;-50;<&chr[e001].font[custom/dialog/gui]>
    - ;-239;<&chr[e009].font[custom/dialog/gui]>
    - ;-51;<&chr[e018].font[custom/dialog/gui]>
    - ;-8;<&chr[e004].font[custom/dialog/gui]>
    procedural items:
    - define size <script.data_key[size]>
    - repeat <[size]>:
        - define result:->:<item[air]>

    - determine <[result]>


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


Dialog_Talk:
    type: task
    debug: false
    definitions: def
    script:
    - define data <script[dialog_data].data_key[text]>
    - define result:->:<element[-173].proc[api_textoffset]>
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
        - define result:->:<[value].font[custom/dialog/text/row<[loop_index]>]>
    - define inventory <inventory[Dialog_GUI]>
    - adjust <[inventory]> title:<[inventory].title><&r><[result].unseparated>
    - inventory open d:<[inventory]>
