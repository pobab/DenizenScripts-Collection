##ignorewarning bad_execute
Clientizen_ReloadScript:
    type: world
    events:
        on clientizen event id:reload_script:
        #- stop if:!<player.is_op>
        - execute "ex reload" as_player
