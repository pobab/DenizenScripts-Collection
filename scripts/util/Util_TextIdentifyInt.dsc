Util_TextIdentifyInt:
    type: procedure
    definitions: text
    script:
    - define negative <[text].after[-]> if:<[text].contains_text[-]>
    - if <[text].is_integer> || <[negative].exists> && <[negative].is_integer>:
        - determine true
    - determine false
