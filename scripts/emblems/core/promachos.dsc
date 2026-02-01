# ============================================
# PROMACHOS NPC - Role Selection
# ============================================
#
# Promachos (Προμαχός) - Herald of the Gods
# - First interaction: Introduces system, forces role selection
# - Returning: Main menu (change role, check emblems, info)
# - Emblem unlocks: Ceremony when components complete
#

# ============================================
# NPC ASSIGNMENT
# ============================================

promachos_assignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - promachos_interact

# ============================================
# INTERACT SCRIPT
# ============================================

promachos_interact:
    type: interact
    debug: false
    steps:
        1:
            click trigger:
                script:
                - if !<player.has_flag[met_promachos]>:
                    - run promachos_first_meeting
                # Check for ready emblems (components complete but not unlocked)
                - else if <proc[check_demeter_components_complete]> && !<player.has_flag[demeter.emblem.unlocked]>:
                    - run demeter_emblem_unlock_ceremony
                - else if <proc[check_hephaestus_components_complete]> && !<player.has_flag[hephaestus.emblem.unlocked]>:
                    - run hephaestus_emblem_unlock_ceremony
                - else if <proc[check_heracles_components_complete]> && !<player.has_flag[heracles.emblem.unlocked]>:
                    - run heracles_emblem_unlock_ceremony
                - else:
                    - inventory open d:promachos_main_menu

# ============================================
# FIRST MEETING DIALOGUE
# ============================================

promachos_first_meeting:
    type: task
    debug: false
    script:
    # Dialogue sequence (5 parts, 3s delay)
    - narrate "<&e><&l>Promachos<&r><&7>: Greetings, <player.name>. I am Promachos, Herald of the Gods."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: The Olympians watch your deeds. Through your labors, you may earn their favor—and their gifts."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: You must choose a path: <&6>Georgos<&7> (farmer), <&6>Metallourgos<&7> (miner), or <&6>Hoplites<&7> (warrior). Only one path may be walked at a time."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: Each path leads to divine emblems—symbols of mastery. Collect components through your labors, and I shall unlock the emblem when you are ready."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: Choose wisely. Your path begins now."
    - wait 1s

    # Flag as met and open role selection
    - flag player met_promachos:true
    - inventory open d:role_selection_gui

# ============================================
# MAIN MENU GUI
# ============================================

promachos_change_role_button:
    type: item
    material: compass
    display name: <&6><&l>Change Role
    lore:
    - <&7>Switch between Farming,
    - <&7>Mining, and Combat roles.
    - <empty>
    - <&e>Click to change your path.

promachos_check_emblems_button:
    type: item
    material: nether_star
    display name: <&6><&l>Check Emblems
    lore:
    - <&7>View your emblem progress.
    - <empty>
    - <&7>When all components are complete,
    - <&7>speak to Promachos to unlock!
    - <empty>
    - <&e>Click to view status.

promachos_system_info_button:
    type: item
    material: book
    display name: <&6><&l>System Info
    lore:
    - <&7>Learn about the emblem system.
    - <empty>
    - <&e>Click for information.

promachos_main_menu:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Promachos - Herald Menu
    size: 27
    definitions:
        filler: <item[gray_stained_glass_pane].with[display=<&7>]>
        change_role: <item[promachos_change_role_button]>
        system_info: <item[promachos_system_info_button]>
    slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [change_role] [filler] [system_info] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

# ============================================
# ROLE SELECTION GUI
# ============================================

promachos_farming_role_button:
    type: item
    material: golden_hoe
    display name: <&6><&l>ΓΕΩΡΓΟΣ<&r> <&8>·<&r> <&e>Georgos
    lore:
    - <&7><&o>"Tiller of sacred soil, blessed by Demeter's hand"
    - <empty>
    - <&6>Path of the Farmer
    - <&7>Cultivate the earth and nurture life.
    - <&7>Harvest golden wheat beneath endless skies.
    - <&7>Shepherd the sacred herds of the goddess.
    - <empty>
    - <&e>Patron: <&6>Demeter, Goddess of Harvest
    - <&e>Sacred Tasks: <&7>Wheat · Cows · Cakes
    enchantments:
    - mending:1
    mechanisms:
        hides: ALL

promachos_mining_role_button:
    type: item
    material: iron_pickaxe
    display name: <&6><&l>ΜΕΤΑΛΛΟΥΡΓΟΣ<&r> <&8>·<&r> <&e>Metallourgos
    lore:
    - <&8><&o>"Master of flame and forge, shaped by Hephaestus' will"
    - <empty>
    - <&6>Path of the Smith
    - <&7>Delve into stone and strike iron veins.
    - <&7>Smelt raw metal in the sacred furnace.
    - <&7>Craft mighty iron golems of war.
    - <empty>
    - <&e>Patron: <&6>Hephaestus, God of the Forge
    - <&e>Sacred Tasks: <&7>Iron Ore · Smelting · Golems
    enchantments:
    - mending:1
    mechanisms:
        hides: ALL

promachos_combat_role_button:
    type: item
    material: diamond_sword
    display name: <&6><&l>ΟΠΛΙΤΗΣ<&r> <&8>·<&r> <&e>Hoplites
    lore:
    - <&7><&o>"Warrior eternal, forged in Heracles' trials"
    - <empty>
    - <&6>Path of the Warrior
    - <&7>Defend villages and master combat prowess.
    - <&7>Strike down raiders and trade with valor.
    - <&7>Prove yourself worthy of heroic legend.
    - <empty>
    - <&e>Patron<&co> <&6>Heracles, Hero of Strength
    - <&e>Sacred Tasks<&co> <&7>Pillagers · Raids · Emeralds
    enchantments:
    - mending:1
    mechanisms:
        hides: ALL

promachos_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return to Promachos

role_selection_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Promachos - Choose Your Path
    size: 27
    definitions:
        filler: <item[gray_stained_glass_pane].with[display=<&7>]>
        farming_role: <item[promachos_farming_role_button]>
        mining_role: <item[promachos_mining_role_button]>
        combat_role: <item[promachos_combat_role_button]>
        back: <item[promachos_back_button]>
    slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [farming_role] [filler] [mining_role] [filler] [combat_role] [filler] [filler]
    - [back] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

# ============================================
# GUI EVENT HANDLERS
# ============================================

promachos_gui_events:
    type: world
    debug: false
    events:
        # Main menu clicks
        after player clicks promachos_change_role_button in promachos_main_menu:
        - inventory open d:role_selection_gui

        after player clicks promachos_system_info_button in promachos_main_menu:
        - inventory open d:system_info_gui

        # Role selection clicks
        after player clicks promachos_farming_role_button in role_selection_gui:
        - run set_player_role def:FARMING

        after player clicks promachos_mining_role_button in role_selection_gui:
        - run set_player_role def:MINING

        after player clicks promachos_combat_role_button in role_selection_gui:
        - run set_player_role def:COMBAT

        after player clicks promachos_back_button in role_selection_gui:
        - inventory open d:promachos_main_menu

        # System info menu clicks
        after player clicks system_info_back_button in system_info_gui:
        - inventory open d:promachos_main_menu

# ============================================
# ROLE SETTING TASK
# ============================================

set_player_role:
    type: task
    debug: false
    definitions: role
    script:
    # Check if already active
    - if <player.flag[role.active].if_null[NONE]> == <[role]>:
        - inventory close
        - define display <proc[get_role_display_name].context[<[role]>]>
        - narrate "<&7>You are already a <&6><[display]><&7>."
        - playsound <player> sound:entity_villager_no
        - stop

    # Set new role
    - flag player role.active:<[role]>
    - inventory close

    # Confirmation message
    - define display <proc[get_role_display_name].context[<[role]>]>
    - define god <proc[get_god_for_role].context[<[role]>]>

    - if <player.has_flag[role.changed_before]>:
        - narrate "<&e><&l>Promachos<&r><&7>: You have changed your path to <&6><[display]><&7>. Your previous progress is preserved."
    - else:
        - choose <[role]>:
            - case FARMING:
                - narrate "<&e><&l>Promachos<&r><&7>: You have chosen the path of <&6>Georgos<&7>. May <&e><[god]><&7> bless your fields."
            - case MINING:
                - narrate "<&e><&l>Promachos<&r><&7>: You have chosen the path of <&6>Metallourgos<&7>. May <&e><[god]><&7> guide your forge."
            - case COMBAT:
                - narrate "<&e><&l>Promachos<&r><&7>: You have chosen the path of <&6>Hoplites<&7>. May <&e><[god]><&7> grant you strength."
        - flag player role.changed_before:true

    - playsound <player> sound:block_enchantment_table_use

# ============================================
# SYSTEM INFO GUI
# ============================================

system_info_roles:
    type: item
    material: compass
    display name: <&6><&l>Roles & Activities
    lore:
    - <&7><&o>"Three paths diverge before you..."
    - <empty>
    - <&e>How It Works<&co>
    - <&7>Pick <&6>Georgos<&7>, <&8>Metallourgos<&7>, or <&c>Hoplites<&7>.
    - <&7>Your active role determines which
    - <&7>activities count toward progression.
    - <empty>
    - <&6>Georgos <&7>(Farming)<&co>
    - <&7>Harvest wheat, breed cows, craft cakes
    - <empty>
    - <&c>Hoplites <&7>(Combat)<&co>
    - <&7>Slay pillagers, trade emeralds, complete raids
    - <empty>
    - <&8>Metallourgos <&7>(Mining)<&co>
    - <&7>Mine iron ore, smelt in blast furnace, create golems

system_info_ranks:
    type: item
    material: experience_bottle
    display name: <&6><&l>Ranks & XP System
    lore:
    - <&7><&o>"Rise through mastery, earn divine favor..."
    - <empty>
    - <&e>How It Works<&co>
    - <&7>Each role has 5 ranks to unlock.
    - <&7>Earn XP from role activities to rank up.
    - <&7>Higher ranks grant permanent buffs.
    - <empty>
    - <&6>Farming Ranks<&co>
    - <&7>Speed boost + extra crop drops
    - <empty>
    - <&c>Combat Ranks<&co>
    - <&7>Low-health regen + vanilla XP bonus
    - <empty>
    - <&8>Mining Ranks<&co>
    - <&7>Haste buff + ore XP bonus
    - <empty>
    - <&8>View rank progress in /profile

system_info_emblems:
    type: item
    material: nether_star
    display name: <&6><&l>Emblems & Components
    lore:
    - <&7><&o>"Symbols of divine favor and mastery..."
    - <empty>
    - <&e>How to Unlock<&co>
    - <&7>Each emblem needs 3 components.
    - <&7>Get components by hitting milestones.
    - <&7>Once all 3 are done, return to me.
    - <empty>
    - <&6>Demeter's Emblem <&7>(Farming)<&co>
    - <&7>Wheat, cow, and cake milestones
    - <empty>
    - <&c>Heracles' Emblem <&7>(Combat)<&co>
    - <&7>Pillager, emerald, and raid milestones
    - <empty>
    - <&8>Hephaestus' Emblem <&7>(Mining)<&co>
    - <&7>Iron ore, smelting, and golem milestones
    - <empty>
    - <&8>Track progress with /profile → Emblems

system_info_crates:
    type: item
    material: tripwire_hook
    display name: <&6><&l>Crates & Rewards
    lore:
    - <&7><&o>"Fortune's gifts await the worthy..."
    - <empty>
    - <&e>How It Works<&co>
    - <&7>Right-click keys on any block to open.
    - <&7>5 rarity tiers → better loot at higher tiers
    - <empty>
    - <&6>Demeter Crates <&7>(Farming)<&co>
    - <&7>Food, blocks, tools, blessings
    - <empty>
    - <&c>Heracles Crates <&7>(Combat)<&co>
    - <&7>Weapons, armor, totems, blessings
    - <empty>
    - <&8>Hephaestus Crates <&7>(Mining)<&co>
    - <&7>Ores, ingots, tools, blessings

system_info_progression:
    type: item
    material: enchanted_golden_apple
    display name: <&6><&l>Meta-Progression
    lore:
    - <&7><&o>"Beyond the gods lies greater glory..."
    - <empty>
    - <&e>Roman Pantheon<&co>
    - <&7>A tier above the Greek gods.
    - <&7>How to access? That's for you to discover...
    - <empty>
    - <&d>Ceres <&7>(Farming)
    - <&d>Mars <&7>(Combat)
    - <&d>Vulcan <&7>(Mining)
    - <empty>
    - <&8><&o>The worthy shall find a way.

system_info_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Promachos - System Guide
    size: 45
    definitions:
        filler: <item[gray_stained_glass_pane].with[display=<&7>]>
        roles: <item[system_info_roles]>
        ranks: <item[system_info_ranks]>
        emblems: <item[system_info_emblems]>
        crates: <item[system_info_crates]>
        meta: <item[system_info_progression]>
        back: <item[system_info_back_button]>
    slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [roles] [filler] [ranks] [filler] [emblems] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [crates] [filler] [filler] [filler] [meta] [filler] [filler]
    - [back] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

system_info_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return to Promachos

# ============================================
# EMBLEM CHECK GUI
# ============================================

emblem_check_gui:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    title: <&8>Emblem Progress
    size: 27
    procedural items:
    - determine <proc[get_emblem_check_items]>

get_emblem_check_items:
    type: procedure
    debug: false
    script:
    - define items <list>

    # Filler
    - define filler <item[gray_stained_glass_pane].with[display=<&7>]>
    - repeat 27:
        - define items <[items].include[<[filler]>]>

    # Row 2: Three emblems centered (slots 12, 14, 16)
    - define items <[items].set[<proc[get_demeter_emblem_status_item]>].at[12]>
    - define items <[items].set[<proc[get_hephaestus_emblem_status_item]>].at[14]>
    - define items <[items].set[<proc[get_heracles_emblem_status_item]>].at[16]>

    # Back button (bottom left slot 19)
    - define items <[items].set[<item[emblem_check_back_button]>].at[19]>

    - determine <[items]>

emblem_check_back_button:
    type: item
    material: arrow
    display name: <&e>← Back
    lore:
    - <&7>Return to profile

# Demeter emblem status
get_demeter_emblem_status_item:
    type: procedure
    debug: false
    script:
    # Check if unlocked
    - if <player.has_flag[demeter.emblem.unlocked]>:
        - define lore <list>
        - define lore <[lore].include[<&2>UNLOCKED]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&7>Symbol of agricultural mastery.]>
        - determine <item[enchanted_golden_apple].with[display=<&6><&l>Demeter's Emblem<&r> <&2>✓;lore=<[lore]>]>

    # Check if ready
    - if <proc[check_demeter_components_complete]>:
        - determine <item[demeter_emblem_ready]>

    # In progress - high level overview
    - define wheat_complete <player.has_flag[demeter.component.wheat]>
    - define cow_complete <player.has_flag[demeter.component.cow]>
    - define cake_complete <player.has_flag[demeter.component.cake]>

    - define components_done 0
    - if <[wheat_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[cow_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[cake_complete]>:
        - define components_done <[components_done].add[1]>

    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of agricultural mastery"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three sacred activities]>
    - define lore <[lore].include[<&7>to unlock Demeter's blessing.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click for detailed progress]>

    - determine <item[wheat].with[display=<&6><&l>Demeter's Emblem;lore=<[lore]>]>

demeter_emblem_ready:
    type: item
    material: nether_star
    display name: <&6><&l>Demeter's Emblem <&a>✓
    lore:
    - <&a><&l>READY TO UNLOCK!
    - <empty>
    - <&7>You have gathered all three
    - <&7>sacred offerings of <&6>Demeter<&7>.
    - <empty>
    - <&e>Speak to <&6>Promachos<&e> to
    - <&e>receive your emblem!
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

# Hephaestus emblem status
get_hephaestus_emblem_status_item:
    type: procedure
    debug: false
    script:
    # If unlocked
    - if <player.has_flag[hephaestus.emblem.unlocked]>:
        - define lore <list>
        - define lore <[lore].include[<&2>UNLOCKED]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&7>Symbol of forge mastery.]>
        - determine <item[iron_pickaxe].with[display=<&8><&l>Hephaestus' Emblem<&r> <&2>✓;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

    # Check if ready
    - if <proc[check_hephaestus_components_complete]>:
        - determine <item[hephaestus_emblem_ready]>

    # In progress - high level overview
    - define iron_complete <player.has_flag[hephaestus.component.iron]>
    - define smelting_complete <player.has_flag[hephaestus.component.smelting]>
    - define golem_complete <player.has_flag[hephaestus.component.golem]>

    - define components_done 0
    - if <[iron_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[smelting_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[golem_complete]>:
        - define components_done <[components_done].add[1]>

    - define lore <list>
    - define lore <[lore].include[<&8><&o>"Emblem of forge mastery"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&8>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three sacred activities]>
    - define lore <[lore].include[<&7>to unlock Hephaestus' blessing.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click for detailed progress]>

    - determine <item[iron_pickaxe].with[display=<&8><&l>Hephaestus' Emblem;lore=<[lore]>]>

hephaestus_emblem_ready:
    type: item
    material: iron_pickaxe
    display name: <&8><&l>Hephaestus' Emblem <&a>✓
    lore:
    - <&a><&l>READY TO UNLOCK!
    - <empty>
    - <&7>You have mastered all three
    - <&7>sacred crafts of <&8>Hephaestus<&7>.
    - <empty>
    - <&e>Speak to <&6>Promachos<&e> to
    - <&e>receive your emblem!
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

# Heracles emblem status
get_heracles_emblem_status_item:
    type: procedure
    debug: false
    script:
    # If unlocked
    - if <player.has_flag[heracles.emblem.unlocked]>:
        - define lore <list>
        - define lore <[lore].include[<&2>UNLOCKED]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&7>Symbol of combat mastery.]>
        - determine <item[diamond_sword].with[display=<&c><&l>Heracles' Emblem<&r> <&2>✓;lore=<[lore]>;enchantments=mending,1;hides=ALL]>

    # Check if ready
    - if <proc[check_heracles_components_complete]>:
        - determine <item[heracles_emblem_ready]>

    # In progress - high level overview
    - define pillagers_complete <player.has_flag[heracles.component.pillagers]>
    - define raids_complete <player.has_flag[heracles.component.raids]>
    - define emeralds_complete <player.has_flag[heracles.component.emeralds]>

    - define components_done 0
    - if <[pillagers_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[raids_complete]>:
        - define components_done <[components_done].add[1]>
    - if <[emeralds_complete]>:
        - define components_done <[components_done].add[1]>

    - define lore <list>
    - define lore <[lore].include[<&7><&o>"Emblem of heroic valor"]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Progress<&co> <&7><[components_done]>/3 components]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&7>Complete three heroic deeds]>
    - define lore <[lore].include[<&7>to unlock Heracles' favor.]>
    - define lore "<[lore].include[<&sp>]>"
    - define lore <[lore].include[<&e>Click for detailed progress]>

    - determine <item[diamond_sword].with[display=<&c><&l>Heracles' Emblem;lore=<[lore]>]>

heracles_emblem_ready:
    type: item
    material: diamond_sword
    display name: <&c><&l>Heracles' Emblem <&a>✓
    lore:
    - <&a><&l>READY TO UNLOCK!
    - <empty>
    - <&7>You have completed all three
    - <&7>heroic trials of <&c>Heracles<&7>.
    - <empty>
    - <&e>Speak to <&6>Promachos<&e> to
    - <&e>receive your emblem!
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

# Check if all Demeter components complete
check_demeter_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[demeter.component.wheat]> && <player.has_flag[demeter.component.cow]> && <player.has_flag[demeter.component.cake]>:
        - determine true
    - determine false

# Check if all Heracles components complete
check_heracles_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[heracles.component.pillagers]> && <player.has_flag[heracles.component.raids]> && <player.has_flag[heracles.component.emeralds]>:
        - determine true
    - determine false

# Check if all Hephaestus components complete
check_hephaestus_components_complete:
    type: procedure
    debug: false
    script:
    - if <player.has_flag[hephaestus.component.iron]> && <player.has_flag[hephaestus.component.smelting]> && <player.has_flag[hephaestus.component.golem]>:
        - determine true
    - determine false

# ============================================
# EMBLEM UNLOCK CEREMONY
# ============================================

demeter_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0

    # Dialogue sequence
    - narrate "<&e><&l>Promachos<&r><&7>: You have gathered the sacred offerings of <&e>Demeter<&7>."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: The goddess of harvest smiles upon you. Receive her emblem!"
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: <&2>You have unlocked the <&6><&l>Emblem of Demeter<&2>!"

    # Set flags
    - flag player demeter.emblem.unlocked:true
    - flag player demeter.emblem.unlock_date:<util.time_now>

    # Award bonus keys
    - give demeter_key quantity:30
    - narrate "<&7>Bonus reward: <&e>30 Demeter Keys"

    # Visual effects
    - title "title:<&6><&l>EMBLEM UNLOCKED!" "subtitle:<&e>Demeter's Blessing" fade_in:10t stay:40t fade_out:10t
    - playeffect effect:totem at:<player.location> quantity:50 offset:1.5

    # Server announcement
    - announce "<&e><&l>[Promachos]<&r> <&f><player.name> <&7>has unlocked the <&6><&l>Emblem of Demeter<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Unlock next farming emblem line (placeholder)
    - flag player farming.next_emblem.unlocked:true
    - wait 2s
    - narrate "<&e><&l>Promachos<&r><&7>: A new path has been revealed to you, Georgos. Return when you are ready to pursue the next emblem."

heracles_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:entity_ender_dragon_growl volume:0.5

    # Dialogue sequence
    - narrate "<&e><&l>Promachos<&r><&7>: You have completed the heroic trials of <&c>Heracles<&7>."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: The greatest of heroes recognizes your valor. Receive his emblem!"
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: <&2>You have unlocked the <&c><&l>Emblem of Heracles<&2>!"

    # Set flags
    - flag player heracles.emblem.unlocked:true
    - flag player heracles.emblem.unlock_date:<util.time_now>

    # Award bonus keys
    - give heracles_key quantity:30
    - narrate "<&7>Bonus reward: <&c>30 Heracles Keys"

    # Visual effects
    - title "title:<&c><&l>EMBLEM UNLOCKED!" "subtitle:<&4>Heracles' Favor" fade_in:10t stay:40t fade_out:10t
    - playeffect effect:flame at:<player.location> quantity:50 offset:1.5

    # Server announcement
    - announce "<&c><&l>[Promachos]<&r> <&f><player.name> <&7>has unlocked the <&c><&l>Emblem of Heracles<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Unlock next combat emblem line (placeholder)
    - flag player combat.next_emblem.unlocked:true
    - wait 2s
    - narrate "<&e><&l>Promachos<&r><&7>: A new path has been revealed to you, Hoplites. Return when you are ready to pursue the next emblem."

hephaestus_emblem_unlock_ceremony:
    type: task
    debug: false
    script:
    # Close GUI
    - inventory close

    # Play epic sound
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:block_anvil_use volume:0.5

    # Dialogue sequence
    - narrate "<&e><&l>Promachos<&r><&7>: You have mastered the sacred crafts of <&8>Hephaestus<&7>."
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: The god of the forge blesses your works. Receive his emblem!"
    - wait 3s

    - narrate "<&e><&l>Promachos<&r><&7>: <&2>You have unlocked the <&8><&l>Emblem of Hephaestus<&2>!"

    # Set flags
    - flag player hephaestus.emblem.unlocked:true
    - flag player hephaestus.emblem.unlock_date:<util.time_now>

    # Award bonus keys
    - give hephaestus_key quantity:30
    - narrate "<&7>Bonus reward: <&7>30 Hephaestus Keys"

    # Visual effects
    - title "title:<&8><&l>EMBLEM UNLOCKED!" "subtitle:<&f>Hephaestus' Blessing" fade_in:10t stay:40t fade_out:10t
    - playeffect effect:lava at:<player.location> quantity:50 offset:1.5

    # Server announcement
    - announce "<&8><&l>[Promachos]<&r> <&f><player.name> <&8>has unlocked the <&8><&l>Emblem of Hephaestus<&8>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5

    # Unlock next mining emblem line (placeholder)
    - flag player mining.next_emblem.unlocked:true
    - wait 2s
    - narrate "<&e><&l>Promachos<&r><&7>: A new path has been revealed to you, Metallourgos. Return when you are ready to pursue the next emblem."
