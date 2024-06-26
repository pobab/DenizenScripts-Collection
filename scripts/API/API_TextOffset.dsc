API_TextOffset:
    type: procedure
    debug: false
    definitions: int
    script:
    - determine "<&c>Invalid integer!<&f>" if:!<[int].is_truthy>
    - determine "<&c>args isn't integer!<&f>" if:!<[int].is_integer.or[<[int].contains_text[-]>]>

    - define char    82
    - define spacing <list>
    - if <[int].contains_text[-]>:
        - define char 80
        - define int  <[int].after[-]>
        - determine "<&c>args isn't integer!<&f>" if:!<[int].is_integer>
    - while <[int]> > 0:
        - if <[int]> >= 1024:
            - define int:-:1024
            - define spacing:->:<&chr[F<[char]>E].font[space:default]>
        - else if <[int]> >= 512:
            - define int:-:512
            - define spacing:->:<&chr[F<[char]>D].font[space:default]>
        - else if <[int]> >= 128:
            - define int:-:128
            - define spacing:->:<&chr[F<[char]>C].font[space:default]>
        - else if <[int]> >= 64:
            - define int:-:64
            - define spacing:->:<&chr[F<[char]>B].font[space:default]>
        - else if <[int]> >= 32:
            - define int:-:32
            - define spacing:->:<&chr[F<[char]>A].font[space:default]>
        - else if <[int]> >= 16:
            - define int:-:16
            - define spacing:->:<&chr[F<[char]>9].font[space:default]>
        - else if <[int]> >= 8:
            - define int:-:8
            - define spacing:->:<&chr[F<[char]>8].font[space:default]>
        - else if <[int]> >= 7:
            - define int:-:7
            - define spacing:->:<&chr[F<[char]>7].font[space:default]>
        - else if <[int]> >= 6:
            - define int:-:6
            - define spacing:->:<&chr[F<[char]>6].font[space:default]>
        - else if <[int]> >= 5:
            - define int:-:5
            - define spacing:->:<&chr[F<[char]>5].font[space:default]>
        - else if <[int]> >= 4:
            - define int:-:4
            - define spacing:->:<&chr[F<[char]>4].font[space:default]>
        - else if <[int]> >= 3:
            - define int:-:3
            - define spacing:->:<&chr[F<[char]>3].font[space:default]>
        - else if <[int]> >= 2:
            - define int:-:2
            - define spacing:->:<&chr[F<[char]>2].font[space:default]>
        - else:
            - define int:-:1
            - define spacing:->:<&chr[F<[char]>1].font[space:default]>

    - determine <[spacing].unseparated>
