# Bulletin System
# News and updates for players

# ==================== CONFIGURATION ====================
# Increment this when adding new bulletin content
# Players will see notification on join if their seen version is lower

bulletin_data:
    type: data
    version: 2

# ==================== JOIN EVENT ====================

bulletin_join_handler:
    type: world
    events:
        on player joins:
        - define current_version <script[bulletin_data].data_key[version]>
        - define seen_version <player.flag[bulletin.seen_version].if_null[0]>
        # Check if player hasn't seen latest bulletin
        - if <[seen_version]> < <[current_version]>:
            - wait 40t
            - title "title:<&e><&l>New Updates!" "subtitle:<&7>Check <&f>/profile <&7>for the bulletin" fade_in:10t stay:70t fade_out:20t
            - playsound <player> sound:block_note_block_chime pitch:1.2
            - narrate " "
            - narrate "<&e><&l>NEW UPDATES AVAILABLE!"
            - narrate "<&7>Type <&f>/profile <&7>and click the <&e>Bulletin <&7>to see what's new."
            - narrate " "

# ==================== BULLETIN GUI ====================

bulletin_inventory:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Server Bulletin
    size: 45
    slots:
    - [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler]
    - [bulletin_filler] [bulletin_welcome] [bulletin_filler] [bulletin_emblems] [bulletin_filler] [bulletin_promachos] [bulletin_filler] [bulletin_house] [bulletin_filler]
    - [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler]
    - [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler]
    - [bulletin_back_button] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler]

bulletin_filler:
    type: item
    material: black_stained_glass_pane
    display name: <empty>

bulletin_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return to profile

bulletin_welcome:
    type: item
    material: oak_sign
    display name: <&a><&l>20/01 - Welcome!
    lore:
    - <&7>Welcome to the server!
    - " "
    - <&7>We've added a new progression
    - <&7>system featuring <&e>Emblems<&7>.
    - " "
    - <&7>Complete challenges to earn
    - <&7>powerful rewards and prove
    - <&7>your dedication to the gods!

bulletin_emblems:
    type: item
    material: nether_star
    display name: <&6><&l>20/01 - Three New Emblems
    lore:
    - <&7>Three emblem paths are now available<&co>
    - " "
    - <&f>Forgeheart Emblem <&8>- <&7>Hephaestus
    - <&7>  Mining, golems, and forge mastery
    - " "
    - <&f>Verdant Oath Emblem <&8>- <&7>Demeter
    - <&7>  Farming, breeding, and harvest
    - " "
    - <&f>Trial of Might Emblem <&8>- <&7>Heracles
    - <&7>  Raids, combat, and conquest
    - " "
    - <&e>Each has 5 stages with XP rewards!

bulletin_promachos:
    type: item
    material: player_head
    display name: <&e><&l>20/01 - Meet Promachos
    lore:
    - <&7>Find the NPC <&e>Promachos <&7>at spawn!
    - " "
    - <&7>He is the guardian of the
    - <&7>forgotten emblems and will<&co>
    - " "
    - <&f>• <&7>Introduce you to the emblem system
    - <&f>• <&7>Trade materials for progression
    - <&f>• <&7>Exchange final items for emblems
    - " "
    - <&e>Speak to him to get started!

bulletin_house:
    type: item
    material: bricks
    display name: <&6><&l>27/01 - A Home for Promachos
    lore:
    - <&7>Promachos is seeking brave adventurers
    - <&7>to help build him a proper house!
    - " "
    - <&7>He has wandered the lands for ages
    - <&7>and dreams of a place to call home.
    - " "
    - <&e>All who contribute will receive
    - <&e>a special reward for their efforts!

# ==================== PROFILE ICON ====================

bulletin_icon:
    type: item
    material: writable_book
    display name: <&e>Bulletin
    lore:
    - <&7>Server news and updates
    - " "
    - <&e>Click to view

bulletin_icon_new:
    type: item
    material: writable_book
    display name: <&e>Bulletin <&c><&l>NEW!
    lore:
    - <&7>Server news and updates
    - " "
    - <&e>Click to view
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

# ==================== OPEN TASK ====================

open_bulletin:
    type: task
    script:
    - inventory open d:bulletin_inventory
    # Mark as seen
    - define current_version <script[bulletin_data].data_key[version]>
    - flag player bulletin.seen_version:<[current_version]>

# ==================== CLICK HANDLERS ====================

bulletin_click_handler:
    type: world
    events:
        after player clicks bulletin_icon in profile_inventory:
        - run open_bulletin

        after player clicks bulletin_icon_new in profile_inventory:
        - run open_bulletin

        after player clicks bulletin_back_button in bulletin_inventory:
        - run open_profile_gui

# ==================== ADMIN COMMAND ====================

bulletin_announce_command:
    type: command
    name: bulletinannounce
    description: Announce a new bulletin to all online players
    usage: /bulletinannounce
    permission: op
    script:
    - define players <server.online_players>
    - if <[players].is_empty>:
        - narrate "<&c>No players online to announce to."
        - stop
    - foreach <[players]> as:target:
        - title targets:<[target]> "title:<&e><&l>New Bulletin!" "subtitle:<&7>Check <&f>/profile <&7>for important news" fade_in:10t stay:70t fade_out:20t
        - playsound <[target]> sound:block_note_block_chime pitch:1.2
        - narrate targets:<[target]> " "
        - narrate targets:<[target]> "<&e><&l>NEW BULLETIN RELEASED!"
        - narrate targets:<[target]> "<&7>Type <&f>/profile <&7>and click the <&e>Bulletin <&7>to see what's new."
        - narrate targets:<[target]> " "
    - narrate "<&a>Bulletin announcement sent to <&f><[players].size> <&a>player(s)."
