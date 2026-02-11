# ============================================
# SERVER EVENTS
# ============================================
#
# 1. Daily server restart at midnight
# 2. Bulletin notification on join (if unread)
# 3. Emblem warning on join (if no emblem selected)
#

server_midnight_restart:
    type: world
    debug: false
    events:
        on system time 00:00:
        - announce "<&c><&l>SERVER RESTARTING <&7>in <&f>60 seconds<&7>!"
        - playsound <server.online_players> sound:block_note_block_pling pitch:1.0
        - wait 30s
        - announce "<&c><&l>SERVER RESTARTING <&7>in <&f>30 seconds<&7>!"
        - playsound <server.online_players> sound:block_note_block_pling pitch:1.0
        - wait 20s
        - announce "<&c><&l>SERVER RESTARTING <&7>in <&f>10 seconds<&7>!"
        - playsound <server.online_players> sound:block_note_block_pling pitch:1.5
        - wait 10s
        - adjust server restart

server_join_handler:
    type: world
    debug: false
    events:
        on player joins:

        # --- Bulletin notification ---
        - define current_version <script[bulletin_data].data_key[version]>
        - define seen_version <player.flag[bulletin.seen_version].if_null[0]>
        - define has_bulletin <[seen_version].is_less_than[<[current_version]>]>

        - if <[has_bulletin]>:
            - wait 40t
            - title "title:<&e><&l>New Updates!" "subtitle:<&7>Check <&f>/profile <&7>for the bulletin" fade_in:10t stay:70t fade_out:20t
            - playsound <player> sound:block_note_block_chime pitch:1.2
            - narrate " "
            - narrate "<&e><&l>NEW UPDATES AVAILABLE!"
            - narrate "<&7>Type <&f>/profile <&7>and click the <&e>Bulletin <&7>to see what's new."
            - narrate " "

        # --- Emblem warning ---
        # Only warn players who have met Promachos but have no emblem set
        - if <player.has_flag[met_promachos]> && !<player.has_flag[emblem.active]>:
            - if <[has_bulletin]>:
                - wait 5s
            - else:
                - wait 40t
            - narrate "<&e><&l>Promachos<&r><&7>: You have not chosen an emblem! Speak to me to select one."
            - playsound <player> sound:entity_villager_ambient
            - title "subtitle:<&7>Visit <&e>Promachos <&7>to choose an emblem" fade_in:10t stay:60t fade_out:10t
