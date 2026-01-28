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
# DEMETER ADMIN COMMAND
# ============================================

demeteradmin_command:
    type: command
    name: demeteradmin
    description: Manage Demeter progression
    usage: /demeteradmin (player) (action) [args...]
    permission: emblems.admin
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /demeteradmin <player> <keys|set|component|rank|checkrank|reset> [args...]"
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

        # Force set rank
        - case rank:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /demeteradmin <player> rank <0|1|2|3>"
                - stop
            - define new_rank <context.args.get[3]>
            - if !<list[0|1|2|3].contains[<[new_rank]>]>:
                - narrate "<&c>Rank must be 0, 1, 2, or 3"
                - stop
            - define old_rank <[target].flag[demeter.rank].if_null[0]>
            - flag <[target]> demeter.rank:<[new_rank]>
            - define rank_name <proc[get_demeter_rank_name].context[<[new_rank]>]>
            - narrate "<&a>Set <[target].name>'s rank from <[old_rank]> to <[new_rank]> (<[rank_name]>)"
            # Trigger ceremony if rank increased
            - if <[new_rank]> > <[old_rank]>:
                - run demeter_rank_up_ceremony def.player:<[target]> def.rank:<[new_rank]>

        # Recalculate rank from counters
        - case checkrank:
            - define old_rank <[target].flag[demeter.rank].if_null[0]>
            - define calculated_rank <proc[get_demeter_rank].context[<[target]>]>
            - flag <[target]> demeter.rank:<[calculated_rank]>
            - define rank_name <proc[get_demeter_rank_name].context[<[calculated_rank]>]>
            - narrate "<&a>Recalculated <[target].name>'s rank: <[old_rank]> -> <[calculated_rank]> (<[rank_name]>)"
            - if <[calculated_rank]> > <[old_rank]>:
                - run demeter_rank_up_ceremony def.player:<[target]> def.rank:<[calculated_rank]>

        # Reset all Demeter flags
        - case reset:
            - flag <[target]> demeter:!
            - narrate "<&a>Reset all Demeter flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, set, component, rank, checkrank, or reset"

# ============================================
# CERES ADMIN COMMAND
# ============================================

ceresadmin_command:
    type: command
    name: ceresadmin
    description: Manage Ceres progression
    usage: /ceresadmin (player) (action) [args...]
    permission: emblems.admin
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
# TEST ROLL COMMANDS
# ============================================

testroll_command:
    type: command
    name: testroll
    description: Simulate crate roll without consuming key
    usage: /testroll (demeter|ceres)
    permission: emblems.admin
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

    # Demeter rank system
    - flag <[target]> demeter.rank:!

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
