##########################################################################################
#                                                                                        #
#                                     TimeFormatter                                      #
#                             A procedure which formats time                             #
#                Version: 1.0.1                            Author: Icecapade             #
#                                                                                        #
#                                     Documentation:                                     #
#    https://github.com/Hydroxycobalamin/Denizen-Script-Collection/wiki/TimeFormatter    #
#                                                                                        #
##########################################################################################
Util_TimeFormat:
    type: procedure
    debug: false
    definitions: object|format
    script:
    # Get the current time.
    - define time <[object].time.if_null[<[object]>]>
    - if !<[time].is_integer>:
        - debug error "<&[error]>The object provided is not an integer, valid player or world."
    - define time <[time].mod[24000]>
    # Calculate time
    - define hour   <[time].div[1000].add[6].mod[24]>
    - define minute <[hour].mod[1].mul[60].round_down>
    # 24 hour format.
    - if <[format]> == 24:
        - define hour       <[hour].round_down>
        - define meridiem   <empty>
    # 12 hour format.
    - else if <[format]> == 12:
        - define hour <[hour].round_down>
        - if <[hour]> < 12:
            - define meridiem AM
        - else:
            - define meridiem PM
        - if <[hour]> > 12:
            - define hour <[hour].sub[12]>
    # If no format is given, output an error.
    - else:
        - debug error "<&[error]>No format given. Add 24 or 12 to the format argument."
    - determine <[hour]><&co><[minute]>
