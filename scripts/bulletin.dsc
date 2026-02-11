# Bulletin System
# News and updates for players

# ==================== CONFIGURATION ====================
# Increment this when adding new bulletin content
# Players will see notification on join if their seen version is lower

bulletin_data:
    type: data
    version: 5

# ==================== BULLETIN GUI ====================

bulletin_inventory:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Server Bulletin
    size: 45
    slots:
    - [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler]
    - [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_promachos_new] [bulletin_combat_new] [bulletin_mining_new] [bulletin_filler] [bulletin_filler] [bulletin_filler]
    - [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler]
    - [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler]
    - [bulletin_back_button] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler] [bulletin_filler]

bulletin_filler:
    type: item
    material: gray_stained_glass_pane
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
    display name: <&e><&l>28/01 - Emblem System Launch!
    lore:
    - <&7><&o>"A herald of the gods walks among mortals..."
    - <empty>
    - <&6><&l>NEW PROGRESSION SYSTEM
    - <&7>A complete overhaul to server progression!
    - <&7>Choose an emblem and complete sacred tasks.
    - <empty>
    - <&e><&l>EMBLEM OF DEMETER
    - <&6>Demeter<&7>, Goddess of Harvest
    - <&7>• Harvest wheat, breed cows, craft cakes
    - <&7>• Earn <&6>Demeter Keys <&7>from activities
    - <&7>• Open crates for rewards and upgrades
    - <&7>• Unlock <&d>Ceres Grove <&7>meta-progression
    - <empty>
    - <&6>Rewards<&co>
    - <&7>• Mythic tools and consumables
    - <&7>• Exclusive cosmetic titles
    - <empty>
    - <&c>Heracles <&7>and <&8>Hephaestus <&7>emblems also available!
    - <empty>
    - <&e>Talk to Promachos to choose your emblem!

bulletin_combat_new:
    type: item
    material: writable_book
    display name: <&c><&l>29/01 - Emblem of Heracles!
    lore:
    - <&7><&o>"The hero's path calls to the brave..."
    - <empty>
    - <&4><&l>EMBLEM OF HERACLES
    - <&c>Heracles<&7>, Greatest of Greek Heroes
    - <&7>• Slay pillagers, defend villages, trade emeralds
    - <&7>• Earn <&c>Heracles Keys <&7>from combat deeds
    - <&7>• Open crates for weapons and upgrades
    - <&7>• Unlock <&d>Mars Arena <&7>meta-progression
    - <empty>
    - <&c>Rewards<&co>
    - <&7>• Mythic weapons and gear
    - <&7>• Exclusive combat titles
    - <empty>
    - <&6>Demeter <&7>and <&8>Hephaestus <&7>emblems also available!
    - <empty>
    - <&e>Talk to Promachos to choose your emblem!

bulletin_mining_new:
    type: item
    material: enchanted_book
    display name: <&8><&l>31/01 - Emblem of Hephaestus!
    lore:
    - <&8><&o>"The forge awaits those who shape the earth..."
    - <empty>
    - <&8><&l>EMBLEM OF HEPHAESTUS
    - <&8>Hephaestus<&7>, God of the Forge
    - <&7>• Mine iron ore, smelt in blast furnace, craft golems
    - <&7>• Earn <&8>Hephaestus Keys <&7>from forge work
    - <&7>• Open crates for tools and upgrades
    - <&7>• Unlock <&d>Vulcan Crucible <&7>meta-progression
    - <empty>
    - <&8>Rewards<&co>
    - <&7>• Mythic pickaxes and consumables
    - <&7>• Exclusive forge titles
    - <empty>
    - <&6>Demeter <&7>and <&c>Heracles <&7>emblems also available!
    - <empty>
    - <&e>Talk to Promachos to choose your emblem!

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
    debug: false
    script:
    - inventory open d:bulletin_inventory
    # Mark as seen
    - define current_version <script[bulletin_data].data_key[version]>
    - flag player bulletin.seen_version:<[current_version]>

# ==================== CLICK HANDLERS ====================

bulletin_click_handler:
    type: world
    debug: false
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
    debug: false
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
