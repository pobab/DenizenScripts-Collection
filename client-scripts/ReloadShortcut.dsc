##ignorewarning event_missing
##ignorewarning unknown_command
key_reloadscript:
    type: world
    debug: false
    events:
        on keyboard key pressed name:GRAVE_ACCENT:
        - reload
        - serverevent id:reload_script