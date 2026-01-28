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
    steps:
        1:
            click trigger:
                script:
                # Temporary OP-only restriction
                - if !<player.is_op>:
                    - narrate "<&e>Emblem system coming soon!"
                    - stop

                - if !<player.has_flag[met_promachos]>:
                    - run promachos_first_meeting
                - else:
                    - inventory open d:promachos_main_menu

# ============================================
# FIRST MEETING DIALOGUE
# ============================================

promachos_first_meeting:
    type: task
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
    - <&7>View your emblem progress
    - <&7>and unlock completed emblems.
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
        filler: <item[gray_stained_glass_pane].with[display_name=<&7>]>
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
    material: diamond_pickaxe
    display name: <&6><&l>ΜΕΤΑΛΛΟΥΡΓΟΣ<&r> <&8>·<&r> <&e>Metallourgos
    lore:
    - <&7><&o>"Master of flame and forge, shaped by Hephaestus' will"
    - <empty>
    - <&6>Path of the Smith
    - <&7>Delve into stone and strike the earth's veins.
    - <&7>Extract precious metals from mountain depths.
    - <&7>Craft legendary works at the divine anvil.
    - <empty>
    - <&e>Patron: <&6>Hephaestus, God of the Forge
    - <&e>Sacred Tasks: <&8><&o>Mysteries yet veiled...
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
    - <&7>Stand as shield against the darkness.
    - <&7>Master blade and spear in glorious combat.
    - <&7>Prove your might through legendary trials.
    - <empty>
    - <&e>Patron: <&6>Heracles, Hero of Strength
    - <&e>Sacred Tasks: <&8><&o>Mysteries yet veiled...
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
        filler: <item[gray_stained_glass_pane].with[display_name=<&7>]>
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
    definitions: role
    script:
    # Check if already active
    - if <player.flag[role.active]> == <[role]>:
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
    display name: <&6><&l>Roles
    lore:
    - <&7><&o>"Three paths diverge before you..."
    - <empty>
    - <&e>How It Works<&co>
    - <&7>Pick <&6>Georgos<&7>, <&6>Metallourgos<&7>, or <&6>Hoplites<&7>.
    - <&7>Your active role determines which
    - <&7>activities count toward progression.
    - <empty>
    - <&6>Important<&co>
    - <&7>• Only one role active at a time
    - <&7>• Switch anytime by clicking me
    - <&7>• Keys and flags persist across changes

system_info_activities:
    type: item
    material: diamond_pickaxe
    display name: <&6><&l>Activities
    mechanisms:
        hides: ALL
    lore:
    - <&7><&o>"Prove your devotion through sacred labor..."
    - <empty>
    - <&e>What You Do<&co>
    - <&7>Complete tasks specific to your role.
    - <&7>Progress is tracked automatically.
    - <empty>
    - <&6>Georgos (Farmer)<&co>
    - <&7>Harvest wheat, breed cows, craft cakes
    - <empty>
    - <&6>Metallourgos & Hoplites<&co>
    - <&7>Activities coming soon!
    - <empty>
    - <&8>Keys drop every 150 wheat, 20 cows, 3 cakes

system_info_emblems:
    type: item
    material: nether_star
    display name: <&6><&l>Emblems
    lore:
    - <&7><&o>"Symbols of divine favor and mastery..."
    - <empty>
    - <&e>How to Unlock<&co>
    - <&7>Each emblem needs 3 components.
    - <&7>Get components by hitting milestones.
    - <&7>Once all 3 are done, click me.
    - <empty>
    - <&6>Demeter's Emblem<&co>
    - <&7>• 15,000 wheat = Wheat Component
    - <&7>• 2,000 cows = Cow Component
    - <&7>• 300 cakes = Cake Component
    - <empty>
    - <&8>Check progress with /profile → Emblems

system_info_crates:
    type: item
    material: tripwire_hook
    display name: <&6><&l>Crates & Keys
    lore:
    - <&7><&o>"Fortune's gifts await the worthy..."
    - <empty>
    - <&e>How to Use<&co>
    - <&7>You get keys from doing activities.
    - <&7>Right-click a key on any block to open.
    - <&7>Watch the animation, claim your loot!
    - <empty>
    - <&6>Demeter Keys<&co>
    - <&7>5 rarity tiers from common to olympian
    - <&7>Loot includes food, blocks, XP, more keys
    - <empty>
    - <&8>Keys work even if you switch roles

system_info_progression:
    type: item
    material: writable_book
    display name: <&6><&l>Track Progress
    lore:
    - <&7><&o>"Know thyself and chart your journey..."
    - <empty>
    - <&e>Use /profile<&co>
    - <&7>Type <&e>/profile<&7> to open your GUI.
    - <&7>It shows your current role, emblem
    - <&7>status, and server news.
    - <empty>
    - <&6>Click Emblems to see<&co>
    - <&7>• Component completion status
    - <&7>• Progress counters (wheat/cows/cakes)
    - <&7>• Unlock ceremonies when ready
    - <empty>
    - <&8>Everything updates live as you play

system_info_gui:
    type: inventory
    inventory: chest
    gui: true
    title: <&8>Promachos - System Guide
    size: 45
    definitions:
        filler: <item[gray_stained_glass_pane].with[display_name=<&7>]>
        roles: <item[system_info_roles]>
        activities: <item[system_info_activities]>
        emblems: <item[system_info_emblems]>
        crates: <item[system_info_crates]>
        progression: <item[system_info_progression]>
        back: <item[system_info_back_button]>
    slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [roles] [filler] [activities] [filler] [emblems] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [crates] [filler] [filler] [filler] [progression] [filler] [filler]
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
    title: <&8>Emblem Progress
    size: 27
    procedural items:
    - determine <proc[get_emblem_check_items]>

get_emblem_check_items:
    type: procedure
    script:
    - define items <list>

    # Filler
    - define filler <item[gray_stained_glass_pane].with[display_name=<&7>]>
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
    script:
    # Check if unlocked
    - if <player.has_flag[demeter.emblem.unlocked]>:
        - define lore <list>
        - define lore <[lore].include[<&2>UNLOCKED]>
        - define lore <[lore].include[<empty>]>
        - define lore <[lore].include[<&7>Symbol of agricultural mastery.]>
        - determine <item[enchanted_golden_apple].with[display_name=<&6><&l>Demeter's Emblem<&r> <&2>✓;lore=<[lore]>]>

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

    - determine <item[wheat].with[display_name=<&6><&l>Demeter's Emblem;lore=<[lore]>]>

demeter_emblem_ready:
    type: item
    material: nether_star
    display name: <&e><&l>Demeter's Emblem<&r> <&e>⚠
    lore:
    - <&e>READY TO UNLOCK!
    - <empty>
    - <&7>All components obtained!
    - <&2>Click to unlock this emblem.
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS

# Hephaestus placeholder
get_hephaestus_emblem_status_item:
    type: procedure
    script:
    - define lore <list>
    - define lore <[lore].include[<&8>???]>
    - define lore <[lore].include[<empty>]>
    - define lore <[lore].include[<&8><&o>Select the Metallourgos role]>
    - define lore <[lore].include[<&8><&o>to begin this path.]>
    - determine <item[gray_dye].with[display_name=<&8>???;lore=<[lore]>]>

# Heracles placeholder
get_heracles_emblem_status_item:
    type: procedure
    script:
    - define lore <list>
    - define lore <[lore].include[<&8>???]>
    - define lore <[lore].include[<empty>]>
    - define lore <[lore].include[<&8><&o>Select the Hoplites role]>
    - define lore <[lore].include[<&8><&o>to begin this path.]>
    - determine <item[gray_dye].with[display_name=<&8>???;lore=<[lore]>]>

# Check if all Demeter components complete
check_demeter_components_complete:
    type: procedure
    script:
    - if <player.has_flag[demeter.component.wheat]> && <player.has_flag[demeter.component.cow]> && <player.has_flag[demeter.component.cake]>:
        - determine true
    - determine false

# ============================================
# EMBLEM UNLOCK CEREMONY
# ============================================

emblem_check_gui_clicks:
    type: world
    debug: false
    events:
        after player clicks demeter_emblem_ready in emblem_check_gui:
        - run demeter_emblem_unlock_ceremony

demeter_emblem_unlock_ceremony:
    type: task
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

    - narrate "<&e><&l>Promachos<&r><&2>You have unlocked the <&6><&l>Emblem of Demeter<&2>!"

    # Set flags
    - flag player demeter.emblem.unlocked:true
    - flag player demeter.emblem.unlock_date:<util.time_now>

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

    # Reopen emblem GUI
    - wait 2s
    - inventory open d:emblem_check_gui
