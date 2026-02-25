# ============================================
# SERVER EVENTS
# ============================================
#
# 1. Daily server restart at midnight
# 2. Bulletin notification on join (if unread)
# 3. Emblem warning on join (if no emblem selected)
# 4. Lore whispers — random hourly ominous messages + thunderstorm
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

        # --- Triton catches migration (conduit → catches) ---
        - if !<player.has_flag[triton.catches_migrated]>:
            - if <player.has_flag[triton.component.conduits]>:
                - flag player triton.component.catches:true
                - flag player triton.component.catches_date:<player.flag[triton.component.conduits_date].if_null[<util.time_now.format>]>
            - flag player triton.catches_migrated:true

        # --- Emblem warning ---
        # Only warn players who have met Promachos but have no emblem set
        - if <player.has_flag[met_promachos]> && !<player.has_flag[emblem.active]>:
            - if <[has_bulletin]>:
                - wait 5s
            - else:
                - wait 40t
            - narrate "<&e><&l>Promachos<&r><&7>: You have not chosen an emblem! Visit one of the gods to choose one."
            - playsound <player> sound:entity_villager_ambient
            - title "subtitle:<&7>Visit a god to choose an emblem" fade_in:10t stay:60t fade_out:10t

# ============================================
# LORE WHISPERS
# ============================================
# Once per hour at a random minute, broadcast an
# ominous lore line and trigger a thunderstorm.

lore_whisper_scheduler:
    type: world
    debug: false
    events:
        on system time hourly:
        - if <server.online_players.size> == 0:
            - stop
        - define delay <util.random.int[1].to[55]>
        - wait <[delay]>m
        - if <server.online_players.size> == 0:
            - stop
        - run lore_whisper_broadcast

lore_whisper_broadcast:
    type: task
    debug: false
    definitions: line
    script:
    - define whispers <list>
    - define whispers <[whispers].include[The ground trembles beneath your feet. Something stirs.]>
    - define whispers <[whispers].include[A crack splits the sky for just a moment... then silence.]>
    - define whispers <[whispers].include[The air grows heavy. The gods have gone quiet.]>
    - define whispers <[whispers].include[Somewhere beneath the world, something is waking up.]>
    - define whispers <[whispers].include[The river flows backwards. The dead do not rest.]>
    - define whispers <[whispers].include[A sound without a source echoes from the deep.]>
    - define whispers <[whispers].include[The sea pulls back from the shore... as if afraid.]>
    - define whispers <[whispers].include[The forge fire flickers. Hephaestus will not say why.]>
    - define whispers <[whispers].include[Lightning has not struck in days. The sky feels... empty.]>
    - define whispers <[whispers].include[The walls between worlds grow thin. Something presses against them.]>
    - define whispers <[whispers].include[An old voice whispers a name no one recognizes.]>
    - define whispers <[whispers].include[The harvest withers where no blight has touched.]>
    - define line <[whispers].random>
    - announce "<&7><&o><[line]>"
    - playsound <server.online_players> sound:ambient_cave volume:0.4
    - wait 3s
    - weather storm reset:1m
    - wait 5s
    - weather thunder reset:55s
