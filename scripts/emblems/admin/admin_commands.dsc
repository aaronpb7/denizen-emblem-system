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
# MINING XP ADMIN COMMAND
# ============================================

miningadmin_command:
    type: command
    name: miningadmin
    description: Manage Mining XP and ranks
    usage: /miningadmin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /miningadmin <player> <xp|setxp|rank|reset> [args...]"
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
                - narrate "<&c>Usage: /miningadmin <player> xp <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - run award_mining_xp def.player:<[target]> def.amount:<[amount]> def.source:admin_command
            - define total <[target].flag[mining.xp].if_null[0]>
            - define rank <[target].flag[mining.rank].if_null[0]>
            - narrate "<&a>Gave <[target].name> <[amount]> Mining XP (Total: <[total]>, Rank: <[rank]>)"

        # Set total XP
        - case setxp:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /miningadmin <player> setxp <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - define old_rank <[target].flag[mining.rank].if_null[0]>
            - flag <[target]> mining.xp:<[amount]>
            - define new_rank <proc[get_mining_rank].context[<[amount]>]>
            - flag <[target]> mining.rank:<[new_rank]>
            - narrate "<&a>Set <[target].name>'s Mining XP to <[amount]> (Rank: <[old_rank]> → <[new_rank]>)"
            - if <[new_rank]> > <[old_rank]>:
                - run mining_rank_up_ceremony def.player:<[target]> def.rank:<[new_rank]>

        # Force set rank
        - case rank:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /miningadmin <player> rank <0|1|2|3|4|5>"
                - stop
            - define new_rank <context.args.get[3]>
            - if !<list[0|1|2|3|4|5].contains[<[new_rank]>]>:
                - narrate "<&c>Rank must be 0, 1, 2, 3, 4, or 5"
                - stop
            - define old_rank <[target].flag[mining.rank].if_null[0]>
            - flag <[target]> mining.rank:<[new_rank]>
            - define rank_name <proc[get_mining_rank_name].context[<[new_rank]>]>
            - narrate "<&a>Set <[target].name>'s rank from <[old_rank]> to <[new_rank]> (<[rank_name]>)"
            - if <[new_rank]> > <[old_rank]>:
                - run mining_rank_up_ceremony def.player:<[target]> def.rank:<[new_rank]>

        # Reset mining XP and rank
        - case reset:
            - flag <[target]> mining.xp:!
            - flag <[target]> mining.rank:!
            - narrate "<&a>Reset mining XP and rank for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: xp, setxp, rank, or reset"

# ============================================
# HEPHAESTUS ADMIN COMMAND
# ============================================

hephaestusadmin_command:
    type: command
    name: hephaestusadmin
    description: Manage Hephaestus progression
    usage: /hephaestusadmin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /hephaestusadmin <player> <keys|set|component|reset> [args...]"
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
                - narrate "<&c>Usage: /hephaestusadmin <player> keys <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - give hephaestus_key quantity:<[amount]> player:<[target]>
            - narrate "<&a>Gave <[target].name> <[amount]> Hephaestus Keys"

        # Set activity counter
        - case set:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /hephaestusadmin <player> set <iron|smelting|golems> <count>"
                - stop
            - define activity <context.args.get[3].to_lowercase>
            - define count <context.args.get[4]>
            - if !<[count].is_integer>:
                - narrate "<&c>Count must be a number"
                - stop
            - choose <[activity]>:
                - case iron:
                    - flag <[target]> hephaestus.iron.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s iron count to <[count]>"
                - case smelting:
                    - flag <[target]> hephaestus.smelting.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s smelting count to <[count]>"
                - case golems:
                    - flag <[target]> hephaestus.golems.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s golems count to <[count]>"
                - default:
                    - narrate "<&c>Invalid activity. Use: iron, smelting, or golems"

        # Toggle component
        - case component:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /hephaestusadmin <player> component <iron|smelting|golem> <true|false>"
                - stop
            - define component <context.args.get[3].to_lowercase>
            - define value <context.args.get[4].to_lowercase>
            - if <[value]> != true && <[value]> != false:
                - narrate "<&c>Value must be true or false"
                - stop
            - choose <[component]>:
                - case iron:
                    - if <[value]> == true:
                        - flag <[target]> hephaestus.component.iron:true
                        - narrate "<&a>Set iron component to true for <[target].name>"
                    - else:
                        - flag <[target]> hephaestus.component.iron:!
                        - narrate "<&a>Removed iron component for <[target].name>"
                - case smelting:
                    - if <[value]> == true:
                        - flag <[target]> hephaestus.component.smelting:true
                        - narrate "<&a>Set smelting component to true for <[target].name>"
                    - else:
                        - flag <[target]> hephaestus.component.smelting:!
                        - narrate "<&a>Removed smelting component for <[target].name>"
                - case golem:
                    - if <[value]> == true:
                        - flag <[target]> hephaestus.component.golem:true
                        - narrate "<&a>Set golem component to true for <[target].name>"
                    - else:
                        - flag <[target]> hephaestus.component.golem:!
                        - narrate "<&a>Removed golem component for <[target].name>"
                - default:
                    - narrate "<&c>Invalid component. Use: iron, smelting, or golem"

        # Reset all Hephaestus flags
        - case reset:
            - flag <[target]> hephaestus:!
            - flag <[target]> mining.xp:!
            - flag <[target]> mining.rank:!
            - narrate "<&a>Reset all Hephaestus flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, set, component, or reset"

# ============================================
# VULCAN ADMIN COMMAND
# ============================================

vulcanadmin_command:
    type: command
    name: vulcanadmin
    description: Manage Vulcan progression
    usage: /vulcanadmin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /vulcanadmin <player> <keys|item|reset> [args...]"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found"
        - stop

    - define action <context.args.get[2].to_lowercase>

    - choose <[action]>:
        # Give Vulcan keys
        - case keys:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /vulcanadmin <player> keys <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - give vulcan_key quantity:<[amount]> player:<[target]>
            - narrate "<&a>Gave <[target].name> <[amount]> Vulcan Keys"

        # Toggle item obtained
        - case item:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /vulcanadmin <player> item <pickaxe|title|shulker|charm> <true|false>"
                - stop
            - define item <context.args.get[3].to_lowercase>
            - define value <context.args.get[4].to_lowercase>
            - if <[value]> != true && <[value]> != false:
                - narrate "<&c>Value must be true or false"
                - stop
            - choose <[item]>:
                - case pickaxe:
                    - if <[value]> == true:
                        - flag <[target]> vulcan.item.pickaxe:true
                        - narrate "<&a>Set Vulcan Pickaxe obtained for <[target].name>"
                    - else:
                        - flag <[target]> vulcan.item.pickaxe:!
                        - narrate "<&a>Removed Vulcan Pickaxe for <[target].name>"
                - case title:
                    - if <[value]> == true:
                        - flag <[target]> vulcan.item.title:true
                        - narrate "<&a>Set Vulcan Title obtained for <[target].name>"
                    - else:
                        - flag <[target]> vulcan.item.title:!
                        - narrate "<&a>Removed Vulcan Title for <[target].name>"
                - case shulker:
                    - if <[value]> == true:
                        - flag <[target]> vulcan.item.shulker:true
                        - narrate "<&a>Set Gray Shulker obtained for <[target].name>"
                    - else:
                        - flag <[target]> vulcan.item.shulker:!
                        - narrate "<&a>Removed Gray Shulker for <[target].name>"
                - case charm:
                    - if <[value]> == true:
                        - flag <[target]> vulcan.item.charm:true
                        - narrate "<&a>Set Vulcan Forge Charm obtained for <[target].name>"
                    - else:
                        - flag <[target]> vulcan.item.charm:!
                        - narrate "<&a>Removed Vulcan Forge Charm for <[target].name>"
                - default:
                    - narrate "<&c>Invalid item. Use: pickaxe, title, shulker, or charm"

        # Reset all Vulcan flags
        - case reset:
            - flag <[target]> vulcan:!
            - narrate "<&a>Reset all Vulcan flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, item, or reset"

# ============================================
# CHECK KEYS AWARDED COMMAND
# ============================================

checkkeys_command:
    type: command
    name: checkkeys
    description: Check keys_awarded tracking for a player
    usage: /checkkeys (player)
    debug: false
    script:
    - if <context.args.size> < 1:
        - define target <player>
    - else:
        - define target <server.match_offline_player[<context.args.get[1]>].if_null[null]>
        - if <[target]> == null:
            - narrate "<&c>Player not found: <context.args.get[1]>"
            - stop

    - narrate "<&6>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    - narrate "<&e><&l>KEY TRACKING FOR <[target].name>"
    - narrate "<&6>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Demeter
    - narrate "<&6>DEMETER:"
    - define wheat_count <[target].flag[demeter.wheat.count].if_null[0]>
    - define wheat_awarded <[target].flag[demeter.wheat.keys_awarded].if_null[0]>
    - define wheat_should <[wheat_count].div[150].round_down>
    - define wheat_owed <[wheat_should].sub[<[wheat_awarded]>].max[0]>
    - narrate "<&7>  Wheat: <&f><[wheat_count]> <&7>| Awarded: <&f><[wheat_awarded]> <&7>| Should: <&f><[wheat_should]> <&7>| Owed: <&a><[wheat_owed]>"

    - define cows_count <[target].flag[demeter.cows.count].if_null[0]>
    - define cows_awarded <[target].flag[demeter.cows.keys_awarded].if_null[0]>
    - define cows_should <[cows_count].div[20].round_down>
    - define cows_owed <[cows_should].sub[<[cows_awarded]>].max[0]>
    - narrate "<&7>  Cows: <&f><[cows_count]> <&7>| Awarded: <&f><[cows_awarded]> <&7>| Should: <&f><[cows_should]> <&7>| Owed: <&a><[cows_owed]>"

    - define cakes_count <[target].flag[demeter.cakes.count].if_null[0]>
    - define cakes_awarded <[target].flag[demeter.cakes.keys_awarded].if_null[0]>
    - define cakes_should <[cakes_count].div[5].round_down>
    - define cakes_owed <[cakes_should].sub[<[cakes_awarded]>].max[0]>
    - narrate "<&7>  Cakes: <&f><[cakes_count]> <&7>| Awarded: <&f><[cakes_awarded]> <&7>| Should: <&f><[cakes_should]> <&7>| Owed: <&a><[cakes_owed]>"

    # Heracles
    - narrate "<&c>HERACLES:"
    - define pillagers_count <[target].flag[heracles.pillagers.count].if_null[0]>
    - define pillagers_awarded <[target].flag[heracles.pillagers.keys_awarded].if_null[0]>
    - define pillagers_should <[pillagers_count].div[25].round_down>
    - define pillagers_owed <[pillagers_should].sub[<[pillagers_awarded]>].max[0]>
    - narrate "<&7>  Pillagers: <&f><[pillagers_count]> <&7>| Awarded: <&f><[pillagers_awarded]> <&7>| Should: <&f><[pillagers_should]> <&7>| Owed: <&a><[pillagers_owed]>"

    - define raids_count <[target].flag[heracles.raids.count].if_null[0]>
    - define raids_awarded <[target].flag[heracles.raids.keys_awarded].if_null[0]>
    - define raids_should <[raids_count].mul[2]>
    - define raids_owed <[raids_should].sub[<[raids_awarded]>].max[0]>
    - narrate "<&7>  Raids: <&f><[raids_count]> <&7>| Awarded: <&f><[raids_awarded]> <&7>| Should: <&f><[raids_should]> <&7>| Owed: <&a><[raids_owed]>"

    - define emeralds_count <[target].flag[heracles.emeralds.count].if_null[0]>
    - define emeralds_awarded <[target].flag[heracles.emeralds.keys_awarded].if_null[0]>
    - define emeralds_should <[emeralds_count].div[100].round_down>
    - define emeralds_owed <[emeralds_should].sub[<[emeralds_awarded]>].max[0]>
    - narrate "<&7>  Emeralds: <&f><[emeralds_count]> <&7>| Awarded: <&f><[emeralds_awarded]> <&7>| Should: <&f><[emeralds_should]> <&7>| Owed: <&a><[emeralds_owed]>"

    # Hephaestus
    - narrate "<&7>HEPHAESTUS:"
    - define iron_count <[target].flag[hephaestus.iron.count].if_null[0]>
    - define iron_awarded <[target].flag[hephaestus.iron.keys_awarded].if_null[0]>
    - define iron_should <[iron_count].div[50].round_down>
    - define iron_owed <[iron_should].sub[<[iron_awarded]>].max[0]>
    - narrate "<&7>  Iron: <&f><[iron_count]> <&7>| Awarded: <&f><[iron_awarded]> <&7>| Should: <&f><[iron_should]> <&7>| Owed: <&a><[iron_owed]>"

    - define smelting_count <[target].flag[hephaestus.smelting.count].if_null[0]>
    - define smelting_awarded <[target].flag[hephaestus.smelting.keys_awarded].if_null[0]>
    - define smelting_should <[smelting_count].div[50].round_down>
    - define smelting_owed <[smelting_should].sub[<[smelting_awarded]>].max[0]>
    - narrate "<&7>  Smelting: <&f><[smelting_count]> <&7>| Awarded: <&f><[smelting_awarded]> <&7>| Should: <&f><[smelting_should]> <&7>| Owed: <&a><[smelting_owed]>"

    - define golems_count <[target].flag[hephaestus.golems.count].if_null[0]>
    - define golems_awarded <[target].flag[hephaestus.golems.keys_awarded].if_null[0]>
    - define golems_should <[golems_count]>
    - define golems_owed <[golems_should].sub[<[golems_awarded]>].max[0]>
    - narrate "<&7>  Golems: <&f><[golems_count]> <&7>| Awarded: <&f><[golems_awarded]> <&7>| Should: <&f><[golems_should]> <&7>| Owed: <&a><[golems_owed]>"

    - narrate "<&6>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ============================================
# TEST ROLL COMMANDS
# ============================================

testroll_command:
    type: command
    name: testroll
    description: Simulate crate roll without consuming key
    usage: /testroll (demeter|ceres|heracles|mars|hephaestus|vulcan)
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 1:
        - narrate "<&c>Usage: /testroll <demeter|ceres|heracles|mars|hephaestus|vulcan>"
        - stop

    - define crate <context.args.get[1].to_lowercase>

    - choose <[crate]>:
        - case demeter:
            - narrate "<&e>Simulating Demeter crate roll..."
            - define tier_result <proc[roll_demeter_tier]>
            - define tier <[tier_result].get[1]>
            - define tier_color <[tier_result].get[2]>
            - define loot <proc[roll_demeter_loot].context[<[tier]>]>
            - run demeter_crate_animation def.tier:<[tier]> def.tier_color:<[tier_color]> def.loot:<[loot]>

        - case ceres:
            - narrate "<&b>Simulating Ceres crate roll..."
            - define result <proc[roll_ceres_outcome]>
            - run ceres_crate_animation def.result:<[result]>

        - case heracles:
            - narrate "<&c>Simulating Heracles crate roll..."
            - define tier_result <proc[roll_heracles_tier]>
            - define tier <[tier_result].get[1]>
            - define tier_color <[tier_result].get[2]>
            - define loot <proc[roll_heracles_loot].context[<[tier]>]>
            - run heracles_crate_animation def.tier:<[tier]> def.tier_color:<[tier_color]> def.loot:<[loot]>

        - case mars:
            - narrate "<&4>Simulating Mars crate roll..."
            - define result <proc[roll_mars_outcome]>
            - run mars_crate_animation def.result:<[result]>

        - case hephaestus:
            - narrate "<&7>Simulating Hephaestus crate roll..."
            - define tier_result <proc[roll_hephaestus_tier]>
            - define tier <[tier_result].get[1]>
            - define tier_color <[tier_result].get[2]>
            - define loot <proc[roll_hephaestus_loot].context[<[tier]>]>
            - run hephaestus_crate_animation def.tier:<[tier]> def.tier_color:<[tier_color]> def.loot:<[loot]>

        - case vulcan:
            - narrate "<&7>Simulating Vulcan crate roll..."
            - define result <proc[roll_vulcan_outcome]>
            - run vulcan_crate_animation def.result:<[result]>

        - default:
            - narrate "<&c>Invalid crate. Use: demeter, ceres, heracles, mars, hephaestus, or vulcan"

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
