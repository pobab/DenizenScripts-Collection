NametagHide_Listener:
    type: world
    debug: false
    events:
        after player join:
        - team name:NametagHide add:<player> option:name_tag_visibility status:never
