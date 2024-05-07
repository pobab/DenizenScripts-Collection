my_command:
    type: command
    name: a
    usage: /a
    description: a
    permission: dscript.a
    script:
    - run dialog_task_layout

##ignorewarning unknown_key_inventory
Dialog_GUI:
    type: inventory
    gui: true
    size: 9
    debug: false
    inventory: chest
    procedural items:
    - define size <script.data_key[size]>
    - repeat <[size]>:
        - define result:->:<item[air]>

    - determine <[result]>

Dialog_Task_Layout:
    type: task
    debug: false
    script:
    - define layoutBase     ;-50;<&chr[e001].font[custom/dialog/gui]>
    - define background     ;-239;<&chr[e009].font[custom/dialog/gui]>
    - define npc_picture    ;-51;<&chr[e018].font[custom/dialog/gui]>
    - define dialog_bubble  ;-8;<&chr[e004].font[custom/dialog/gui]>
    - define 1 ;-173;<element[plis lah woy gg amat nih ajg kau].font[custom/dialog/text/row1]>
    - define 2 ;-<element[plis lah woy gg amat nih ajg kau].text_width>;<element[plis lah woy gg amat nih ajg kau].split[<&sp>].size.sub[1].mul[2]>;<element[gg].font[custom/dialog/text/row2]>
    - define 3 ;-<element[gg].text_width>;<element[binit].font[custom/dialog/text/row3]>
    - define raw            <&f><[layoutBase]><[background]><[npc_picture]><[dialog_bubble]><&0><[1]><[2]><[3]><&r>
    - foreach <[raw].split[;]>:
        - define minText <[raw].after[-]> if:<[raw].contains_text[-]>
        - if <[value].proc[util_textidentifyint]>:
            - define result:->:<[value].proc[api_textoffset]>
        - else:
            - define result:->:<[value]>
    - define inventory      <inventory[Dialog_GUI]>
    - adjust <[inventory]> title:<[result].unseparated>
    - inventory open d:<[inventory]>

