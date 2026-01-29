# ============================================
# ADMIN COMMANDS - Demeter
# ============================================
#
# Testing and administration commands for the emblem system
#

# ============================================
# ROLE ADMIN COMMAND
# ============================================

roleadmin_command:
    type: command
    name: roleadmin
    description: Set player's active role
    usage: /roleadmin (player) (FARMING|MINING|COMBAT)
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /roleadmin <player> <FARMING|MINING|COMBAT>"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found: <context.args.get[1]>"
        - stop

    - define role <context.args.get[2].to_uppercase>
    - if !<proc[is_valid_role].context[<[role]>]>:
        - narrate "<&c>Invalid role. Use: FARMING, MINING, or COMBAT"
        - stop

    - flag <[target]> role.active:<[role]>
    - narrate "<&a>Set <[target].name>'s role to <[role]>"
    - narrate "<&a>Your role has been set to <[role]> by an admin." targets:<[target]>

# ============================================
# FARMING XP ADMIN COMMAND
# ============================================

farmingadmin_command:
    type: command
    name: farmingadmin
    description: Manage Farming XP and ranks
    usage: /farmingadmin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /farmingadmin <player> <xp|setxp|rank|reset> [args...]"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found"
        - stop

    - define action <context.args.get[2].to_lowercase>

    - choose <[action]>:
        # Give XP
        - case xp:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /farmingadmin <player> xp <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - run award_farming_xp def.player:<[target]> def.amount:<[amount]> def.source:admin_command
            - define total <[target].flag[farming.xp].if_null[0]>
            - define rank <[target].flag[farming.rank].if_null[0]>
            - narrate "<&a>Gave <[target].name> <[amount]> XP (Total: <[total]>, Rank: <[rank]>)"

        # Set total XP
        - case setxp:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /farmingadmin <player> setxp <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - define old_rank <[target].flag[farming.rank].if_null[0]>
            - flag <[target]> farming.xp:<[amount]>
            - define new_rank <proc[get_farming_rank].context[<[amount]>]>
            - flag <[target]> farming.rank:<[new_rank]>
            - narrate "<&a>Set <[target].name>'s XP to <[amount]> (Rank: <[old_rank]> → <[new_rank]>)"
            - if <[new_rank]> > <[old_rank]>:
                - run farming_rank_up_ceremony def.player:<[target]> def.rank:<[new_rank]>

        # Force set rank
        - case rank:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /farmingadmin <player> rank <0|1|2|3|4|5>"
                - stop
            - define new_rank <context.args.get[3]>
            - if !<list[0|1|2|3|4|5].contains[<[new_rank]>]>:
                - narrate "<&c>Rank must be 0, 1, 2, 3, 4, or 5"
                - stop
            - define old_rank <[target].flag[farming.rank].if_null[0]>
            - flag <[target]> farming.rank:<[new_rank]>
            - define rank_name <proc[get_farming_rank_name].context[<[new_rank]>]>
            - narrate "<&a>Set <[target].name>'s rank from <[old_rank]> to <[new_rank]> (<[rank_name]>)"
            # Trigger ceremony if rank increased
            - if <[new_rank]> > <[old_rank]>:
                - run farming_rank_up_ceremony def.player:<[target]> def.rank:<[new_rank]>

        # Reset farming XP and rank
        - case reset:
            - flag <[target]> farming.xp:!
            - flag <[target]> farming.rank:!
            - narrate "<&a>Reset farming XP and rank for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: xp, setxp, rank, or reset"

# ============================================
# DEMETER ADMIN COMMAND
# ============================================

demeteradmin_command:
    type: command
    name: demeteradmin
    description: Manage Demeter progression
    usage: /demeteradmin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /demeteradmin <player> <keys|set|component|reset> [args...]"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found"
        - stop

    - define action <context.args.get[2].to_lowercase>

    - choose <[action]>:
        # Give keys
        - case keys:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /demeteradmin <player> keys <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - run give_item_to_player def:<[target]>|demeter_key|<[amount]>
            - narrate "<&a>Gave <[target].name> <[amount]> Demeter Keys"

        # Set activity counter
        - case set:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /demeteradmin <player> set <wheat|cows|cakes> <count>"
                - stop
            - define activity <context.args.get[3].to_lowercase>
            - define count <context.args.get[4]>
            - if !<[count].is_integer>:
                - narrate "<&c>Count must be a number"
                - stop
            - choose <[activity]>:
                - case wheat:
                    - flag <[target]> demeter.wheat.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s wheat count to <[count]>"
                    - run demeter_check_rank def.player:<[target]>
                - case cows:
                    - flag <[target]> demeter.cows.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s cows count to <[count]>"
                    - run demeter_check_rank def.player:<[target]>
                - case cakes:
                    - flag <[target]> demeter.cakes.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s cakes count to <[count]>"
                - default:
                    - narrate "<&c>Invalid activity. Use: wheat, cows, or cakes"

        # Toggle component
        - case component:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /demeteradmin <player> component <wheat|cow|cake> <true|false>"
                - stop
            - define component <context.args.get[3].to_lowercase>
            - define value <context.args.get[4].to_lowercase>
            - if <[value]> != true && <[value]> != false:
                - narrate "<&c>Value must be true or false"
                - stop
            - choose <[component]>:
                - case wheat:
                    - if <[value]> == true:
                        - flag <[target]> demeter.component.wheat:true
                        - narrate "<&a>Set wheat component to true for <[target].name>"
                    - else:
                        - flag <[target]> demeter.component.wheat:!
                        - narrate "<&a>Removed wheat component for <[target].name>"
                - case cow:
                    - if <[value]> == true:
                        - flag <[target]> demeter.component.cow:true
                        - narrate "<&a>Set cow component to true for <[target].name>"
                    - else:
                        - flag <[target]> demeter.component.cow:!
                        - narrate "<&a>Removed cow component for <[target].name>"
                - case cake:
                    - if <[value]> == true:
                        - flag <[target]> demeter.component.cake:true
                        - narrate "<&a>Set cake component to true for <[target].name>"
                    - else:
                        - flag <[target]> demeter.component.cake:!
                        - narrate "<&a>Removed cake component for <[target].name>"
                - default:
                    - narrate "<&c>Invalid component. Use: wheat, cow, or cake"

        # Reset all Demeter flags
        - case reset:
            - flag <[target]> demeter:!
            - narrate "<&a>Reset all Demeter flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, set, component, or reset"

# ============================================
# CERES ADMIN COMMAND
# ============================================

ceresadmin_command:
    type: command
    name: ceresadmin
    description: Manage Ceres progression
    usage: /ceresadmin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /ceresadmin <player> <keys|item|reset> [args...]"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found"
        - stop

    - define action <context.args.get[2].to_lowercase>

    - choose <[action]>:
        # Give Ceres keys
        - case keys:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /ceresadmin <player> keys <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - run give_item_to_player def:<[target]>|ceres_key|<[amount]>
            - narrate "<&a>Gave <[target].name> <[amount]> Ceres Keys"

        # Toggle item obtained
        - case item:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /ceresadmin <player> item <hoe|title|shulker|wand> <true|false>"
                - stop
            - define item <context.args.get[3].to_lowercase>
            - define value <context.args.get[4].to_lowercase>
            - if <[value]> != true && <[value]> != false:
                - narrate "<&c>Value must be true or false"
                - stop
            - choose <[item]>:
                - case hoe:
                    - if <[value]> == true:
                        - flag <[target]> ceres.item.hoe:true
                        - narrate "<&a>Set Ceres Hoe obtained for <[target].name>"
                    - else:
                        - flag <[target]> ceres.item.hoe:!
                        - narrate "<&a>Removed Ceres Hoe for <[target].name>"
                - case title:
                    - if <[value]> == true:
                        - flag <[target]> ceres.item.title:true
                        - narrate "<&a>Set Ceres Title obtained for <[target].name>"
                    - else:
                        - flag <[target]> ceres.item.title:!
                        - narrate "<&a>Removed Ceres Title for <[target].name>"
                - case shulker:
                    - if <[value]> == true:
                        - flag <[target]> ceres.item.shulker:true
                        - narrate "<&a>Set Yellow Shulker obtained for <[target].name>"
                    - else:
                        - flag <[target]> ceres.item.shulker:!
                        - narrate "<&a>Removed Yellow Shulker for <[target].name>"
                - case wand:
                    - if <[value]> == true:
                        - flag <[target]> ceres.item.wand:true
                        - narrate "<&a>Set Ceres Wand obtained for <[target].name>"
                    - else:
                        - flag <[target]> ceres.item.wand:!
                        - narrate "<&a>Removed Ceres Wand for <[target].name>"
                - default:
                    - narrate "<&c>Invalid item. Use: hoe, title, shulker, or wand"

        # Reset all Ceres flags
        - case reset:
            - flag <[target]> ceres:!
            - narrate "<&a>Reset all Ceres flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, item, or reset"

# ============================================
# HERACLES ADMIN COMMAND
# ============================================

heraclesadmin_command:
    type: command
    name: heraclesadmin
    description: Manage Heracles progression
    usage: /heraclesadmin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /heraclesadmin <player> <keys|set|xp|component|raid|reset> [args...]"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found"
        - stop

    - define action <context.args.get[2].to_lowercase>

    - choose <[action]>:
        # Give keys
        - case keys:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /heraclesadmin <player> keys <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - run give_item_to_player def:<[target]>|heracles_key|<[amount]>
            - narrate "<&a>Gave <[target].name> <[amount]> Heracles Keys"

        # Set activity counter
        - case set:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /heraclesadmin <player> set <pillagers|raids|emeralds> <count>"
                - stop
            - define activity <context.args.get[3].to_lowercase>
            - define count <context.args.get[4]>
            - if !<[count].is_integer>:
                - narrate "<&c>Count must be a number"
                - stop
            - choose <[activity]>:
                - case pillagers:
                    - flag <[target]> heracles.pillagers.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s pillagers to <[count]>"
                - case raids:
                    - flag <[target]> heracles.raids.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s raids to <[count]>"
                - case emeralds:
                    - flag <[target]> heracles.emeralds.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s emeralds to <[count]>"
                - default:
                    - narrate "<&c>Invalid activity. Use: pillagers, raids, or emeralds"

        # Give combat XP
        - case xp:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /heraclesadmin <player> xp <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - run award_combat_xp def.player:<[target]> def.amount:<[amount]> def.source:admin_command
            - define total <[target].flag[heracles.xp].if_null[0]>
            - narrate "<&a>Gave <[target].name> <[amount]> combat XP (Total: <[total]>)"

        # Toggle component
        - case component:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /heraclesadmin <player> component <pillagers|raids|emeralds> <true|false>"
                - stop
            - define component <context.args.get[3].to_lowercase>
            - define value <context.args.get[4].to_lowercase>
            - if <[value]> != true && <[value]> != false:
                - narrate "<&c>Value must be true or false"
                - stop
            - choose <[component]>:
                - case pillagers:
                    - if <[value]> == true:
                        - flag <[target]> heracles.component.pillagers:true
                        - narrate "<&a>Set pillagers component to true for <[target].name>"
                    - else:
                        - flag <[target]> heracles.component.pillagers:!
                        - narrate "<&a>Removed pillagers component for <[target].name>"
                - case raids:
                    - if <[value]> == true:
                        - flag <[target]> heracles.component.raids:true
                        - narrate "<&a>Set raids component to true for <[target].name>"
                    - else:
                        - flag <[target]> heracles.component.raids:!
                        - narrate "<&a>Removed raids component for <[target].name>"
                - case emeralds:
                    - if <[value]> == true:
                        - flag <[target]> heracles.component.emeralds:true
                        - narrate "<&a>Set emeralds component to true for <[target].name>"
                    - else:
                        - flag <[target]> heracles.component.emeralds:!
                        - narrate "<&a>Removed emeralds component for <[target].name>"
                - default:
                    - narrate "<&c>Invalid component. Use: pillagers, raids, or emeralds"

        # Award raid completion (with XP and keys)
        - case raid:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /heraclesadmin <player> raid <level>"
                - narrate "<&7>Level 1-5 (Bad Omen I-V)"
                - stop
            - define level <context.args.get[3]>
            - if !<list[1|2|3|4|5].contains[<[level]>]>:
                - narrate "<&c>Level must be 1, 2, 3, 4, or 5"
                - stop
            # Award XP based on level
            - define xp_amount <script[combat_xp_rates].data_key[rates.raids.<[level]>].if_null[50]>
            - run award_combat_xp def.player:<[target]> def.amount:<[xp_amount]> def.source:admin_raid
            # Award 2 keys
            - give heracles_key quantity:2 player:<[target]>
            # Increment raid count
            - flag <[target]> heracles.raids.count:++
            - define count <[target].flag[heracles.raids.count]>
            - narrate "<&a>Awarded raid completion to <[target].name>:"
            - narrate "<&7>  Level: <[level]> | XP: +<[xp_amount]> | Keys: +2 | Total raids: <[count]>/50"
            - narrate "<&7>Player notified." targets:<player>
            - narrate "<&c><&l>ADMIN RAID AWARD<&r> <&7>Level <[level]> raid completion" targets:<[target]>
            - narrate "<&7>+<[xp_amount]> Combat XP | +2 Heracles Keys" targets:<[target]>
            - narrate "<&7>Raids: <&a><[count]><&7>/50" targets:<[target]>

        # Reset all Heracles flags
        - case reset:
            - flag <[target]> heracles:!
            - narrate "<&a>Reset all Heracles flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, set, xp, component, raid, or reset"

# ============================================
# TEST ROLL COMMANDS
# ============================================

testroll_command:
    type: command
    name: testroll
    description: Simulate crate roll without consuming key
    usage: /testroll (demeter|ceres)
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 1:
        - narrate "<&c>Usage: /testroll <demeter|ceres>"
        - stop

    - define crate <context.args.get[1].to_lowercase>

    - choose <[crate]>:
        - case demeter:
            - narrate "<&e>Simulating Demeter crate roll..."
            - run demeter_crate_animation

        - case ceres:
            - narrate "<&b>Simulating Ceres crate roll..."
            - run ceres_crate_animation

        - default:
            - narrate "<&c>Invalid crate. Use: demeter or ceres"

# ============================================
# GLOBAL RESET COMMAND
# ============================================

emblemreset_command:
    type: command
    name: emblemreset
    description: Completely reset a player's emblem progression
    usage: /emblemreset (player) [confirm]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 1:
        - narrate "<&c>Usage: /emblemreset <player> [confirm]"
        - narrate "<&7>This will wipe ALL emblem progress, flags, and unlocks."
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found: <context.args.get[1]>"
        - stop

    # Require confirmation
    - if <context.args.size> < 2 || <context.args.get[2]> != "confirm":
        - narrate "<&e><&l>WARNING:<&r> <&c>This will permanently delete:"
        - narrate "<&7>- Role selection and active role"
        - narrate "<&7>- All Demeter progress (wheat, cows, cakes)"
        - narrate "<&7>- All Demeter components and ranks"
        - narrate "<&7>- All Ceres unlocks (hoe, title, shulker, wand)"
        - narrate "<&7>- All cosmetic titles"
        - narrate "<&7>- All crate statistics"
        - narrate "<&7>- Promachos introduction flag"
        - narrate ""
        - narrate "<&e>To confirm, run: <&f>/emblemreset <[target].name> confirm"
        - stop

    # Execute full reset
    - run emblemreset_task def.target:<[target]>
    - narrate "<&a>✓ Successfully reset all emblem progress for <&e><[target].name>"
    - narrate "<&7>They can now start fresh by visiting Promachos."

emblemreset_task:
    type: task
    debug: false
    definitions: target
    script:
    # Core system flags
    - flag <[target]> met_promachos:!
    - flag <[target]> role.active:!
    - flag <[target]> role.changed_before:!

    # Demeter activity progress
    - flag <[target]> demeter.wheat.count:!
    - flag <[target]> demeter.wheat.keys_awarded:!
    - flag <[target]> demeter.component.wheat:!
    - flag <[target]> demeter.component.wheat_date:!

    - flag <[target]> demeter.cows.count:!
    - flag <[target]> demeter.cows.keys_awarded:!
    - flag <[target]> demeter.component.cow:!
    - flag <[target]> demeter.component.cow_date:!

    - flag <[target]> demeter.cakes.count:!
    - flag <[target]> demeter.cakes.keys_awarded:!
    - flag <[target]> demeter.component.cake:!
    - flag <[target]> demeter.component.cake_date:!

    # Farming XP and rank system
    - flag <[target]> farming.xp:!
    - flag <[target]> farming.rank:!

    # Demeter crate system
    - flag <[target]> demeter.crates_opened:!
    - flag <[target]> demeter.tier.mortal:!
    - flag <[target]> demeter.tier.heroic:!
    - flag <[target]> demeter.tier.legendary:!
    - flag <[target]> demeter.tier.mythic:!
    - flag <[target]> demeter.tier.olympian:!
    - flag <[target]> demeter.item.title:!

    # Demeter crate animation flags (cleanup)
    - flag <[target]> demeter.crate.pending_loot:!
    - flag <[target]> demeter.crate.pending_tier:!
    - flag <[target]> demeter.crate.pending_tier_color:!
    - flag <[target]> demeter.crate.animation_running:!

    # Ceres meta-progression
    - flag <[target]> ceres.crates_opened:!
    - flag <[target]> ceres.item.hoe:!
    - flag <[target]> ceres.item.title:!
    - flag <[target]> ceres.item.shulker:!
    - flag <[target]> ceres.item.wand:!
    - flag <[target]> ceres.unique_items:!

    # Ceres crate animation flags (cleanup)
    - flag <[target]> ceres.crate.pending_result:!
    - flag <[target]> ceres.crate.animation_running:!

    # Cosmetics system
    - flag <[target]> cosmetic.title.active:!

    # Hephaestus (placeholder - for future)
    - flag <[target]> hephaestus:!

    # Heracles (placeholder - for future)
    - flag <[target]> heracles:!

    # Vulcan (placeholder - for future)
    - flag <[target]> vulcan:!

    # Mars (placeholder - for future)
    - flag <[target]> mars:!

    # Notify target player
    - narrate "<&e>[Emblem System]<&r> <&7>Your emblem progression has been completely reset by an admin." targets:<[target]>
    - narrate "<&7>Visit <&e>Promachos<&7> to begin your journey!" targets:<[target]>

    # Log to console
    - announce to_console "Emblem reset completed for player: <[target].name>"
