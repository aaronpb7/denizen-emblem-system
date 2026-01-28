# Bulletin System
# News and updates for players

# ==================== CONFIGURATION ====================
# Increment this when adding new bulletin content
# Players will see notification on join if their seen version is lower

bulletin_data:
    type: data
    version: 3

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
    - [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_promachos_new] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler]
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

bulletin_promachos_new:
    type: item
    material: writable_book
    display name: <&e><&l>28/01 - Promachos Arrives!
    lore:
    - <&7><&o>"A herald of the gods walks among mortals..."
    - <empty>
    - <&6>New NPC at Spawn<&co> <&e>Promachos
    - <&7>An ancient herald who guards the
    - <&7>secrets of forgotten emblems.
    - <empty>
    - <&e>What Awaits You<&co>
    - <&6>Roles <&8>- <&7>Choose your sacred path
    - <&7>  Farmer, Miner, or Warrior?
    - <empty>
    - <&6>Emblems <&8>- <&7>Unlock divine symbols
    - <&7>  Complete challenges to earn them
    - <empty>
    - <&6>Keys <&8>- <&7>Open mystical crates
    - <&7>  Earn rewards as you progress
    - <empty>
    - <&6>And More <&8>- <&7>Discover as you explore!
    - <empty>
    - <&8>Find Promachos to begin your legend

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
