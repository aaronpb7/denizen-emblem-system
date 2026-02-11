# ============================================
# ADMIN COMMANDS - Demeter
# ============================================
#
# Testing and administration commands for the emblem system
#

# ============================================
# EMBLEM ADMIN COMMAND
# ============================================

emblemadmin_command:
    type: command
    name: emblemadmin
    description: Set player's active emblem
    usage: /emblemadmin (player) (DEMETER|HEPHAESTUS|HERACLES|TRITON)
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /emblemadmin <player> <DEMETER|HEPHAESTUS|HERACLES|TRITON>"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found: <context.args.get[1]>"
        - stop

    - define emblem <context.args.get[2].to_uppercase>
    - if !<proc[is_valid_emblem].context[<[emblem]>]>:
        - narrate "<&c>Invalid emblem. Use: DEMETER, HEPHAESTUS, HERACLES, or TRITON"
        - stop

    - flag <[target]> emblem.active:<[emblem]>
    - narrate "<&a>Set <[target].name>'s emblem to <[emblem]>"
    - narrate "<&a>Your emblem has been set to <[emblem]> by an admin." targets:<[target]>

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
        - narrate "<&c>Usage: /demeteradmin <player> <keys|set|component|max|reset> [args...]"
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
                - case cows:
                    - flag <[target]> demeter.cows.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s cows count to <[count]>"
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

        # Max out emblem (all components + unlock)
        - case max:
            - flag <[target]> demeter.component.wheat:true
            - flag <[target]> demeter.component.cow:true
            - flag <[target]> demeter.component.cake:true
            - flag <[target]> demeter.emblem.unlocked:true
            - flag <[target]> demeter.emblem.unlock_date:<util.time_now>
            - flag <[target]> emblem.rank:+:1
            - narrate "<&a>Maxed out Demeter emblem for <[target].name>"
            - narrate "<&7>All components + emblem unlocked. Rank incremented."

        # Reset all Demeter flags
        - case reset:
            - flag <[target]> demeter:!
            - narrate "<&a>Reset all Demeter flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, set, component, max, or reset"

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
        - narrate "<&c>Usage: /ceresadmin <player> <keys|give|item|reset> [args...]"
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

        # Give item + flag + announcement (mirrors crate drop)
        - case give:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /ceresadmin <player> give <title|shulker|wand|head>"
                - stop
            - define item <context.args.get[3].to_lowercase>
            - choose <[item]>:
                - case title:
                    - flag <[target]> ceres.item.title:true
                    - define "display:Ceres Title"
                - case shulker:
                    - flag <[target]> ceres.item.shulker:true
                    - give yellow_shulker_box player:<[target]>
                    - define "display:Yellow Shulker Box"
                - case wand:
                    - flag <[target]> ceres.item.wand:true
                    - give ceres_wand_blueprint player:<[target]>
                    - define "display:Ceres Wand Blueprint"
                - case head:
                    - flag <[target]> ceres.item.head:true
                    - give demeter_head player:<[target]>
                    - define "display:Head of Demeter"
                - default:
                    - narrate "<&c>Invalid item. Use: title, shulker, wand, or head"
                    - stop
            - playsound <[target]> sound:ui_toast_challenge_complete volume:1.0
            - playsound <[target]> sound:block_beacon_activate volume:0.5
            - title "title:<&b><&l>OLYMPIAN DROP" "subtitle:<&d><[display]>" fade_in:5t stay:40t fade_out:10t targets:<[target]>
            - announce "<&b><&l>OLYMPIAN DROP!<&r> <&f><[target].name> <&7>obtained a unique Ceres item<&co> <&d><[display]><&7>!"
            - flag <[target]> ceres.unique_items:++
            - if <[target].has_flag[ceres.item.title]> && <[target].has_flag[ceres.item.shulker]> && <[target].has_flag[ceres.item.wand]> && <[target].has_flag[ceres.item.head]>:
                - announce "<&b><&l>COLLECTION COMPLETE!<&r> <&f><[target].name> <&7>has collected every unique <&b>Ceres<&7> item!"
                - playsound <[target]> sound:entity_ender_dragon_growl volume:0.5
            - narrate "<&a>Gave Ceres <[item]> to <[target].name>"

        # Toggle item obtained
        - case item:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /ceresadmin <player> item <title|shulker|wand|head> <true|false>"
                - stop
            - define item <context.args.get[3].to_lowercase>
            - define value <context.args.get[4].to_lowercase>
            - if <[value]> != true && <[value]> != false:
                - narrate "<&c>Value must be true or false"
                - stop
            - choose <[item]>:
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
                - case head:
                    - if <[value]> == true:
                        - flag <[target]> ceres.item.head:true
                        - narrate "<&a>Set Head of Demeter obtained for <[target].name>"
                    - else:
                        - flag <[target]> ceres.item.head:!
                        - narrate "<&a>Removed Head of Demeter for <[target].name>"
                - default:
                    - narrate "<&c>Invalid item. Use: title, shulker, wand, or head"

        # Reset all Ceres flags
        - case reset:
            - flag <[target]> ceres:!
            - narrate "<&a>Reset all Ceres flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, give, item, or reset"

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
        - narrate "<&c>Usage: /heraclesadmin <player> <keys|set|component|raid|max|reset> [args...]"
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

        # Award raid completion (with keys)
        - case raid:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /heraclesadmin <player> raid <level>"
                - narrate "<&7>Level 1-5 (Bad Omen I-V)"
                - stop
            - define level <context.args.get[3]>
            - if !<list[1|2|3|4|5].contains[<[level]>]>:
                - narrate "<&c>Level must be 1, 2, 3, 4, or 5"
                - stop
            # Award 2 keys
            - give heracles_key quantity:2 player:<[target]>
            # Increment raid count
            - flag <[target]> heracles.raids.count:++
            - define count <[target].flag[heracles.raids.count]>
            - narrate "<&a>Awarded raid completion to <[target].name>:"
            - narrate "<&7>  Level: <[level]> | Keys: +2 | Total raids: <[count]>/50"
            - narrate "<&7>Player notified." targets:<player>
            - narrate "<&c><&l>ADMIN RAID AWARD<&r> <&7>Level <[level]> raid completion" targets:<[target]>
            - narrate "<&7>+2 Heracles Keys" targets:<[target]>
            - narrate "<&7>Raids: <&a><[count]><&7>/50" targets:<[target]>

        # Max out emblem (all components + unlock)
        - case max:
            - flag <[target]> heracles.component.pillagers:true
            - flag <[target]> heracles.component.raids:true
            - flag <[target]> heracles.component.emeralds:true
            - flag <[target]> heracles.emblem.unlocked:true
            - flag <[target]> heracles.emblem.unlock_date:<util.time_now>
            - flag <[target]> emblem.rank:+:1
            - narrate "<&a>Maxed out Heracles emblem for <[target].name>"
            - narrate "<&7>All components + emblem unlocked. Rank incremented."

        # Reset all Heracles flags
        - case reset:
            - flag <[target]> heracles:!
            - narrate "<&a>Reset all Heracles flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, set, component, raid, max, or reset"

# ============================================
# MARS ADMIN COMMAND
# ============================================

marsadmin_command:
    type: command
    name: marsadmin
    description: Manage Mars progression
    usage: /marsadmin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /marsadmin <player> <keys|give|item|reset> [args...]"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found"
        - stop

    - define action <context.args.get[2].to_lowercase>

    - choose <[action]>:
        # Give Mars keys
        - case keys:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /marsadmin <player> keys <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - give mars_key quantity:<[amount]> player:<[target]>
            - narrate "<&a>Gave <[target].name> <[amount]> Mars Keys"

        # Give item + flag + announcement (mirrors crate drop)
        - case give:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /marsadmin <player> give <title|shulker|shield|head>"
                - stop
            - define item <context.args.get[3].to_lowercase>
            - choose <[item]>:
                - case title:
                    - flag <[target]> mars.item.title:true
                    - define "display:Mars Title"
                - case shulker:
                    - flag <[target]> mars.item.shulker:true
                    - give red_shulker_box player:<[target]>
                    - define "display:Red Shulker Box"
                - case shield:
                    - flag <[target]> mars.item.shield:true
                    - give mars_shield_blueprint player:<[target]>
                    - define "display:Mars Shield Blueprint"
                - case head:
                    - flag <[target]> mars.item.head:true
                    - give heracles_head player:<[target]>
                    - define "display:Head of Heracles"
                - default:
                    - narrate "<&c>Invalid item. Use: title, shulker, shield, or head"
                    - stop
            - playsound <[target]> sound:ui_toast_challenge_complete volume:1.0
            - playsound <[target]> sound:block_beacon_activate volume:0.5
            - title "title:<&4><&l>OLYMPIAN DROP" "subtitle:<&d><[display]>" fade_in:5t stay:40t fade_out:10t targets:<[target]>
            - announce "<&4><&l>OLYMPIAN DROP!<&r> <&f><[target].name> <&7>obtained a unique Mars item<&co> <&d><[display]><&7>!"
            - flag <[target]> mars.unique_items:++
            - if <[target].has_flag[mars.item.title]> && <[target].has_flag[mars.item.shulker]> && <[target].has_flag[mars.item.shield]> && <[target].has_flag[mars.item.head]>:
                - announce "<&4><&l>COLLECTION COMPLETE!<&r> <&f><[target].name> <&7>has collected every unique <&4>Mars<&7> item!"
                - playsound <[target]> sound:entity_ender_dragon_growl volume:0.5
            - narrate "<&a>Gave Mars <[item]> to <[target].name>"

        # Toggle item obtained
        - case item:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /marsadmin <player> item <title|shulker|shield|head> <true|false>"
                - stop
            - define item <context.args.get[3].to_lowercase>
            - define value <context.args.get[4].to_lowercase>
            - if <[value]> != true && <[value]> != false:
                - narrate "<&c>Value must be true or false"
                - stop
            - choose <[item]>:
                - case title:
                    - if <[value]> == true:
                        - flag <[target]> mars.item.title:true
                        - narrate "<&a>Set Mars Title obtained for <[target].name>"
                    - else:
                        - flag <[target]> mars.item.title:!
                        - narrate "<&a>Removed Mars Title for <[target].name>"
                - case shulker:
                    - if <[value]> == true:
                        - flag <[target]> mars.item.shulker:true
                        - narrate "<&a>Set Red Shulker obtained for <[target].name>"
                    - else:
                        - flag <[target]> mars.item.shulker:!
                        - narrate "<&a>Removed Red Shulker for <[target].name>"
                - case shield:
                    - if <[value]> == true:
                        - flag <[target]> mars.item.shield:true
                        - narrate "<&a>Set Mars Shield obtained for <[target].name>"
                    - else:
                        - flag <[target]> mars.item.shield:!
                        - narrate "<&a>Removed Mars Shield for <[target].name>"
                - case head:
                    - if <[value]> == true:
                        - flag <[target]> mars.item.head:true
                        - narrate "<&a>Set Head of Heracles obtained for <[target].name>"
                    - else:
                        - flag <[target]> mars.item.head:!
                        - narrate "<&a>Removed Head of Heracles for <[target].name>"
                - default:
                    - narrate "<&c>Invalid item. Use: title, shulker, shield, or head"

        # Reset all Mars flags
        - case reset:
            - flag <[target]> mars:!
            - narrate "<&a>Reset all Mars flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, give, item, or reset"

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
        - narrate "<&c>Usage: /hephaestusadmin <player> <keys|set|component|max|reset> [args...]"
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

        # Max out emblem (all components + unlock)
        - case max:
            - flag <[target]> hephaestus.component.iron:true
            - flag <[target]> hephaestus.component.smelting:true
            - flag <[target]> hephaestus.component.golem:true
            - flag <[target]> hephaestus.emblem.unlocked:true
            - flag <[target]> hephaestus.emblem.unlock_date:<util.time_now>
            - flag <[target]> emblem.rank:+:1
            - narrate "<&a>Maxed out Hephaestus emblem for <[target].name>"
            - narrate "<&7>All components + emblem unlocked. Rank incremented."

        # Reset all Hephaestus flags
        - case reset:
            - flag <[target]> hephaestus:!
            - narrate "<&a>Reset all Hephaestus flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, set, component, max, or reset"

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
        - narrate "<&c>Usage: /vulcanadmin <player> <keys|give|item|reset> [args...]"
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

        # Give item + flag + announcement (mirrors crate drop)
        - case give:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /vulcanadmin <player> give <pickaxe|title|shulker|head>"
                - stop
            - define item <context.args.get[3].to_lowercase>
            - choose <[item]>:
                - case pickaxe:
                    - flag <[target]> vulcan.item.pickaxe:true
                    - give vulcan_pickaxe_blueprint player:<[target]>
                    - define "display:Vulcan Pickaxe Blueprint"
                - case title:
                    - flag <[target]> vulcan.item.title:true
                    - define "display:Vulcan Title"
                - case shulker:
                    - flag <[target]> vulcan.item.shulker:true
                    - give gray_shulker_box player:<[target]>
                    - define "display:Gray Shulker Box"
                - case head:
                    - flag <[target]> vulcan.item.head:true
                    - give hephaestus_head player:<[target]>
                    - define "display:Head of Hephaestus"
                - default:
                    - narrate "<&c>Invalid item. Use: pickaxe, title, shulker, or head"
                    - stop
            - playsound <[target]> sound:ui_toast_challenge_complete volume:1.0
            - playsound <[target]> sound:block_anvil_use volume:0.5
            - title "title:<&b><&l>OLYMPIAN DROP" "subtitle:<&d><[display]>" fade_in:5t stay:40t fade_out:10t targets:<[target]>
            - announce "<&b><&l>OLYMPIAN DROP!<&r> <&f><[target].name> <&7>obtained a unique Vulcan item<&co> <&d><[display]><&7>!"
            - flag <[target]> vulcan.unique_items:++
            - if <[target].has_flag[vulcan.item.pickaxe]> && <[target].has_flag[vulcan.item.title]> && <[target].has_flag[vulcan.item.shulker]> && <[target].has_flag[vulcan.item.head]>:
                - announce "<&b><&l>COLLECTION COMPLETE!<&r> <&f><[target].name> <&7>has collected every unique <&b>Vulcan<&7> item!"
                - playsound <[target]> sound:entity_ender_dragon_growl volume:0.5
            - narrate "<&a>Gave Vulcan <[item]> to <[target].name>"

        # Toggle item obtained
        - case item:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /vulcanadmin <player> item <pickaxe|title|shulker|head> <true|false>"
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
                - case head:
                    - if <[value]> == true:
                        - flag <[target]> vulcan.item.head:true
                        - narrate "<&a>Set Head of Hephaestus obtained for <[target].name>"
                    - else:
                        - flag <[target]> vulcan.item.head:!
                        - narrate "<&a>Removed Head of Hephaestus for <[target].name>"
                - default:
                    - narrate "<&c>Invalid item. Use: pickaxe, title, shulker, or head"

        # Reset all Vulcan flags
        - case reset:
            - flag <[target]> vulcan:!
            - narrate "<&a>Reset all Vulcan flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, give, item, or reset"

# ============================================
# TRITON ADMIN COMMAND
# ============================================

tritonadmin_command:
    type: command
    name: tritonadmin
    description: Manage Triton progression
    usage: /tritonadmin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /tritonadmin <player> <keys|set|component|max|reset> [args...]"
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
                - narrate "<&c>Usage: /tritonadmin <player> keys <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - run give_item_to_player def:<[target]>|triton_key|<[amount]>
            - narrate "<&a>Gave <[target].name> <[amount]> Triton Keys"

        # Set activity counter
        - case set:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /tritonadmin <player> set <lanterns|guardians|conduits> <count>"
                - stop
            - define activity <context.args.get[3].to_lowercase>
            - define count <context.args.get[4]>
            - if !<[count].is_integer>:
                - narrate "<&c>Count must be a number"
                - stop
            - choose <[activity]>:
                - case lanterns:
                    - flag <[target]> triton.lanterns.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s lanterns count to <[count]>"
                - case guardians:
                    - flag <[target]> triton.guardians.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s guardians count to <[count]>"
                - case conduits:
                    - flag <[target]> triton.conduits.count:<[count]>
                    - narrate "<&a>Set <[target].name>'s conduits count to <[count]>"
                - default:
                    - narrate "<&c>Invalid activity. Use: lanterns, guardians, or conduits"

        # Toggle component
        - case component:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /tritonadmin <player> component <lanterns|guardians|conduits> <true|false>"
                - stop
            - define component <context.args.get[3].to_lowercase>
            - define value <context.args.get[4].to_lowercase>
            - if <[value]> != true && <[value]> != false:
                - narrate "<&c>Value must be true or false"
                - stop
            - choose <[component]>:
                - case lanterns:
                    - if <[value]> == true:
                        - flag <[target]> triton.component.lanterns:true
                        - narrate "<&a>Set lanterns component to true for <[target].name>"
                    - else:
                        - flag <[target]> triton.component.lanterns:!
                        - narrate "<&a>Removed lanterns component for <[target].name>"
                - case guardians:
                    - if <[value]> == true:
                        - flag <[target]> triton.component.guardians:true
                        - narrate "<&a>Set guardians component to true for <[target].name>"
                    - else:
                        - flag <[target]> triton.component.guardians:!
                        - narrate "<&a>Removed guardians component for <[target].name>"
                - case conduits:
                    - if <[value]> == true:
                        - flag <[target]> triton.component.conduits:true
                        - narrate "<&a>Set conduits component to true for <[target].name>"
                    - else:
                        - flag <[target]> triton.component.conduits:!
                        - narrate "<&a>Removed conduits component for <[target].name>"
                - default:
                    - narrate "<&c>Invalid component. Use: lanterns, guardians, or conduits"

        # Max out emblem (all components + unlock)
        - case max:
            - flag <[target]> triton.component.lanterns:true
            - flag <[target]> triton.component.guardians:true
            - flag <[target]> triton.component.conduits:true
            - flag <[target]> triton.emblem.unlocked:true
            - flag <[target]> triton.emblem.unlock_date:<util.time_now>
            - flag <[target]> emblem.rank:+:1
            - narrate "<&a>Maxed out Triton emblem for <[target].name>"
            - narrate "<&7>All components + emblem unlocked. Rank incremented."

        # Reset all Triton flags
        - case reset:
            - flag <[target]> triton:!
            - flag <[target]> met_triton:!
            - narrate "<&a>Reset all Triton flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, set, component, max, or reset"

# ============================================
# NEPTUNE ADMIN COMMAND
# ============================================

neptuneadmin_command:
    type: command
    name: neptuneadmin
    description: Manage Neptune progression
    usage: /neptuneadmin (player) (action) [args...]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 2:
        - narrate "<&c>Usage: /neptuneadmin <player> <keys|give|item|reset> [args...]"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found"
        - stop

    - define action <context.args.get[2].to_lowercase>

    - choose <[action]>:
        # Give Neptune keys
        - case keys:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /neptuneadmin <player> keys <amount>"
                - stop
            - define amount <context.args.get[3]>
            - if !<[amount].is_integer>:
                - narrate "<&c>Amount must be a number"
                - stop
            - give neptune_key quantity:<[amount]> player:<[target]>
            - narrate "<&a>Gave <[target].name> <[amount]> Neptune Keys"

        # Give item + flag + announcement (mirrors crate drop)
        - case give:
            - if <context.args.size> < 3:
                - narrate "<&c>Usage: /neptuneadmin <player> give <title|shulker|trident|head>"
                - stop
            - define item <context.args.get[3].to_lowercase>
            - choose <[item]>:
                - case title:
                    - flag <[target]> neptune.item.title:true
                    - define "display:Neptune Title"
                - case shulker:
                    - flag <[target]> neptune.item.shulker:true
                    - give cyan_shulker_box player:<[target]>
                    - define "display:Cyan Shulker Box"
                - case trident:
                    - flag <[target]> neptune.item.trident_blueprint:true
                    - give neptune_trident_blueprint player:<[target]>
                    - define "display:Neptune Trident Blueprint"
                - case head:
                    - flag <[target]> neptune.item.head:true
                    - give triton_head player:<[target]>
                    - define "display:Head of Triton"
                - default:
                    - narrate "<&c>Invalid item. Use: title, shulker, trident, or head"
                    - stop
            - playsound <[target]> sound:ui_toast_challenge_complete volume:1.0
            - playsound <[target]> sound:block_beacon_activate volume:0.5
            - title "title:<&b><&l>OLYMPIAN DROP" "subtitle:<&d><[display]>" fade_in:5t stay:40t fade_out:10t targets:<[target]>
            - announce "<&b><&l>OLYMPIAN DROP!<&r> <&f><[target].name> <&7>obtained a unique Neptune item<&co> <&d><[display]><&7>!"
            - flag <[target]> neptune.unique_items:++
            - if <[target].has_flag[neptune.item.title]> && <[target].has_flag[neptune.item.shulker]> && <[target].has_flag[neptune.item.trident_blueprint]> && <[target].has_flag[neptune.item.head]>:
                - announce "<&b><&l>COLLECTION COMPLETE!<&r> <&f><[target].name> <&7>has collected every unique <&3>Neptune<&7> item!"
                - playsound <[target]> sound:entity_ender_dragon_growl volume:0.5
            - narrate "<&a>Gave Neptune <[item]> to <[target].name>"

        # Toggle item obtained
        - case item:
            - if <context.args.size> < 4:
                - narrate "<&c>Usage: /neptuneadmin <player> item <title|shulker|trident|head> <true|false>"
                - stop
            - define item <context.args.get[3].to_lowercase>
            - define value <context.args.get[4].to_lowercase>
            - if <[value]> != true && <[value]> != false:
                - narrate "<&c>Value must be true or false"
                - stop
            - choose <[item]>:
                - case title:
                    - if <[value]> == true:
                        - flag <[target]> neptune.item.title:true
                        - narrate "<&a>Set Neptune Title obtained for <[target].name>"
                    - else:
                        - flag <[target]> neptune.item.title:!
                        - narrate "<&a>Removed Neptune Title for <[target].name>"
                - case shulker:
                    - if <[value]> == true:
                        - flag <[target]> neptune.item.shulker:true
                        - narrate "<&a>Set Neptune's Chest obtained for <[target].name>"
                    - else:
                        - flag <[target]> neptune.item.shulker:!
                        - narrate "<&a>Removed Neptune's Chest for <[target].name>"
                - case trident:
                    - if <[value]> == true:
                        - flag <[target]> neptune.item.trident_blueprint:true
                        - narrate "<&a>Set Neptune Trident Blueprint obtained for <[target].name>"
                    - else:
                        - flag <[target]> neptune.item.trident_blueprint:!
                        - narrate "<&a>Removed Neptune Trident Blueprint for <[target].name>"
                - case head:
                    - if <[value]> == true:
                        - flag <[target]> neptune.item.head:true
                        - narrate "<&a>Set Head of Triton obtained for <[target].name>"
                    - else:
                        - flag <[target]> neptune.item.head:!
                        - narrate "<&a>Removed Head of Triton for <[target].name>"
                - default:
                    - narrate "<&c>Invalid item. Use: title, shulker, trident, or head"

        # Reset all Neptune flags
        - case reset:
            - flag <[target]> neptune:!
            - narrate "<&a>Reset all Neptune flags for <[target].name>"

        - default:
            - narrate "<&c>Invalid action. Use: keys, give, item, or reset"

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

    # Triton
    - narrate "<&3>TRITON:"
    - define lanterns_count <[target].flag[triton.lanterns.count].if_null[0]>
    - define lanterns_awarded <[target].flag[triton.lanterns.keys_awarded].if_null[0]>
    - define lanterns_should <[lanterns_count].div[10].round_down>
    - define lanterns_owed <[lanterns_should].sub[<[lanterns_awarded]>].max[0]>
    - narrate "<&7>  Lanterns: <&f><[lanterns_count]> <&7>| Awarded: <&f><[lanterns_awarded]> <&7>| Should: <&f><[lanterns_should]> <&7>| Owed: <&a><[lanterns_owed]>"

    - define guardians_count <[target].flag[triton.guardians.count].if_null[0]>
    - define guardians_awarded <[target].flag[triton.guardians.keys_awarded].if_null[0]>
    - define guardians_should <[guardians_count].div[15].round_down>
    - define guardians_owed <[guardians_should].sub[<[guardians_awarded]>].max[0]>
    - narrate "<&7>  Guardians: <&f><[guardians_count]> <&7>| Awarded: <&f><[guardians_awarded]> <&7>| Should: <&f><[guardians_should]> <&7>| Owed: <&a><[guardians_owed]>"

    - define conduits_count <[target].flag[triton.conduits.count].if_null[0]>
    - define conduits_awarded <[target].flag[triton.conduits.keys_awarded].if_null[0]>
    - define conduits_should <[conduits_count].mul[4]>
    - define conduits_owed <[conduits_should].sub[<[conduits_awarded]>].max[0]>
    - narrate "<&7>  Conduits: <&f><[conduits_count]> <&7>| Awarded: <&f><[conduits_awarded]> <&7>| Should: <&f><[conduits_should]> <&7>| Owed: <&a><[conduits_owed]>"

    - narrate "<&6>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ============================================
# TEST ROLL COMMANDS
# ============================================

testroll_command:
    type: command
    name: testroll
    description: Simulate crate roll without consuming key
    usage: /testroll (demeter|ceres|heracles|mars|hephaestus|vulcan|triton|neptune)
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 1:
        - narrate "<&c>Usage: /testroll <demeter|ceres|heracles|mars|hephaestus|vulcan|triton|neptune>"
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

        - case triton:
            - narrate "<&3>Simulating Triton crate roll..."
            - define tier_result <proc[roll_triton_tier]>
            - define tier <[tier_result].get[1]>
            - define tier_color <[tier_result].get[2]>
            - define loot <proc[roll_triton_loot].context[<[tier]>]>
            - run triton_crate_animation def.tier:<[tier]> def.tier_color:<[tier_color]> def.loot:<[loot]>

        - case neptune:
            - narrate "<&3>Simulating Neptune crate roll..."
            - define result <proc[roll_neptune_outcome]>
            - run neptune_crate_animation def.result:<[result]>

        - default:
            - narrate "<&c>Invalid crate. Use: demeter, ceres, heracles, mars, hephaestus, vulcan, triton, or neptune"

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
        - narrate "<&7>- Emblem selection and active emblem"
        - narrate "<&7>- All Demeter progress (wheat, cows, cakes)"
        - narrate "<&7>- All Demeter components and ranks"
        - narrate "<&7>- All Ceres unlocks (title, shulker, wand, head)"
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
    - flag <[target]> emblem.active:!
    - flag <[target]> emblem.changed_before:!

    # Demeter
    - flag <[target]> demeter:!

    # Emblem rank
    - flag <[target]> emblem.rank:!
    - flag <[target]> emblem.migrated:!

    # Ceres
    - flag <[target]> ceres:!

    # Crafting system flags
    - flag <[target]> crafting.viewing_recipe:!

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

    # Triton
    - flag <[target]> triton:!
    - flag <[target]> met_triton:!

    # Neptune
    - flag <[target]> neptune:!

    # Notify target player
    - narrate "<&e>[Emblem System]<&r> <&7>Your emblem progression has been completely reset by an admin." targets:<[target]>
    - narrate "<&7>Visit <&e>Promachos<&7> to begin your journey!" targets:<[target]>

    # Log to console
    - announce to_console "Emblem reset completed for player: <[target].name>"

# ============================================
# RANK ADMIN COMMAND
# ============================================

rankadmin_command:
    type: command
    name: rankadmin
    description: View or set player's emblem rank
    usage: /rankadmin (player) [set (number)]
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 1:
        - narrate "<&c>Usage: /rankadmin <player> [set <number>]"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found: <context.args.get[1]>"
        - stop

    - if <context.args.size> >= 3 && <context.args.get[2].to_lowercase> == set:
        - define new_rank <context.args.get[3]>
        - if !<[new_rank].is_integer>:
            - narrate "<&c>Rank must be a number"
            - stop
        - flag <[target]> emblem.rank:<[new_rank]>
        - narrate "<&a>Set <[target].name>'s emblem rank to <[new_rank]>"
    - else:
        - define rank <[target].flag[emblem.rank].if_null[0]>
        - narrate "<&e><[target].name>'s Emblem Rank: <&6><[rank]>"
        - if <[target].has_flag[demeter.emblem.unlocked]>:
            - narrate "<&2>✓ <&7>Demeter"
        - if <[target].has_flag[hephaestus.emblem.unlocked]>:
            - narrate "<&2>✓ <&7>Hephaestus"
        - if <[target].has_flag[heracles.emblem.unlocked]>:
            - narrate "<&2>✓ <&7>Heracles"
        - if <[target].has_flag[triton.emblem.unlocked]>:
            - narrate "<&2>✓ <&7>Triton"

# ============================================
# INVENTORY VIEWER COMMAND
# ============================================

invsee_command:
    type: command
    name: invsee
    description: View and edit a player's inventory (works offline)
    usage: /invsee (player)
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 1:
        - narrate "<&c>Usage: /invsee <player>"
        - stop

    - define target <server.match_offline_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found: <context.args.get[1]>"
        - stop

    - inventory open d:<[target].inventory>
    - narrate "<&a>Opened <[target].name>'s inventory"
    - if !<[target].is_online>:
        - narrate "<&7>(Player is offline - changes save automatically)"

# ============================================
# ENDER CHEST VIEWER COMMAND
# ============================================

endersee_command:
    type: command
    name: endersee
    description: View and edit a player's ender chest (works offline)
    usage: /endersee (player)
    permission: emblems.admin
    debug: false
    script:
    - if <context.args.size> < 1:
        - narrate "<&c>Usage: /endersee <player>"
        - stop

    - define target <server.match_offline_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found: <context.args.get[1]>"
        - stop

    - inventory open d:<[target].enderchest>
    - narrate "<&a>Opened <[target].name>'s ender chest"
    - if !<[target].is_online>:
        - narrate "<&7>(Player is offline - changes save automatically)"
