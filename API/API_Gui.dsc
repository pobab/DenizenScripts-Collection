API_GUI_Listener:
    type: world
    debug: false
    check_gui_script:
    - stop if:!<context.inventory.script.data_key[].contains[listener].exists>
    - define script <context.inventory.script>
    - define listener_keys <[script].list_deep_keys>
    events:
        on player clicks in inventory:
        - inject <script> path:check_gui_script

        - if <[listener_keys].contains[listener.on click]>:
            - inject <[script]> "path:listener.on click"

        #

        #
        on player closes inventory:
        - inject <script> path:check_gui_script

        - if <[listener_keys].contains[listener.on close]>:
            - inject <[script]> "path:listener.on close"

        #

        #
        on player opens inventory:
        - inject <script> path:check_gui_script

        - if <[listener_keys].contains[listener.on open]>:
            - inject <[script]> "path:listener.on open"

        #

        #
        on player drags in inventory:
        - inject <script> path:check_gui_script

        - if <[listener_keys].contains[listener.on drags item]>:
            - inject <[script]> "path:listener.on drags item"

        #

#
