NametagHide_Listener:
    type: world
    events:
        on player join:
        - team name:NametagHide add:<player> option:name_tag_visibility status:never
