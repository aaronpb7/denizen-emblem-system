# ============================================
# EMBLEM SYSTEM V2 - DEMETER EVENTS
# ============================================
#
# Activity tracking for Demeter progression:
# 1. Wheat harvesting (every 150 → key, 15,000 → component)
# 2. Cow breeding (every 20 → key, 2,000 → component)
# 3. Cake crafting (every 3 → key, 300 → component)
#
# Only tracks when player role = FARMING
#

# ============================================
# WHEAT HARVESTING
# ============================================

demeter_wheat_tracking:
    type: world
    debug: false
    events:
        after player breaks wheat:
        # Role gate - only FARMING role counts
        - if <player.flag[role.active]> != FARMING:
            - stop

        # Only fully grown wheat (age 7)
        - if <context.material.age> != 7:
            - stop

        # Increment counter
        - flag player demeter.wheat.count:++
        - define count <player.flag[demeter.wheat.count]>

        # Check for rank-up
        - run demeter_check_rank def.player:<player>

        # Check for key award (every 150)
        - define keys_awarded <player.flag[demeter.wheat.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[150].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give demeter_key quantity:<[keys_to_give]>
            - flag player demeter.wheat.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>DEMETER KEY!<&r> <&7>Wheat: <&a><[count]><&7>/15000"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (15,000)
        - if <[count]> >= 15000 && !<player.has_flag[demeter.component.wheat]>:
            - flag player demeter.component.wheat:true
            - flag player demeter.component.wheat_date:<util.time_now.format>
            # Optional: Give physical component item
            # - give wheat_component
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Wheat Component obtained! <&7>(15,000 wheat)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&e>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&6>Wheat Component<&7>!"

# ============================================
# COW BREEDING
# ============================================

demeter_cow_tracking:
    type: world
    debug: false
    events:
        after cow breeds:
        # Extract breeder
        - define breeder <context.breeder>
        - if <[breeder]> == null || !<[breeder].is_player>:
            - stop

        # Role gate
        - if <[breeder].flag[role.active]> != FARMING:
            - stop

        # Increment counter
        - flag <[breeder]> demeter.cows.count:++
        - define count <[breeder].flag[demeter.cows.count]>

        # Check for rank-up
        - run demeter_check_rank def.player:<[breeder]>

        # Check for key award (every 20)
        - define keys_awarded <[breeder].flag[demeter.cows.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[20].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - run give_item_to_player def:<[breeder]>|demeter_key|<[keys_to_give]>
            - flag <[breeder]> demeter.cows.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>DEMETER KEY!<&r> <&7>Cows: <&a><[count]><&7>/2000" targets:<[breeder]>
            - playsound <[breeder]> sound:entity_experience_orb_pickup

        # Check for component milestone (2,000)
        - if <[count]> >= 2000 && !<[breeder].has_flag[demeter.component.cow]>:
            - flag <[breeder]> demeter.component.cow:true
            - flag <[breeder]> demeter.component.cow_date:<util.time_now.format>
            # Optional: Give physical component item
            # - give <[breeder]> cow_component
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Cow Component obtained! <&7>(2,000 cows)" targets:<[breeder]>
            - playsound <[breeder]> sound:ui_toast_challenge_complete
            - announce "<&e>[Promachos]<&r> <&f><[breeder].name> <&7>has obtained the <&6>Cow Component<&7>!"

# ============================================
# CAKE CRAFTING
# ============================================

demeter_cake_tracking:
    type: world
    debug: false
    events:
        after player crafts cake:
        # Role gate
        - if <player.flag[role.active]> != FARMING:
            - stop

        # Increment counter (context.item.quantity for bulk crafts)
        - define craft_amount <context.item.quantity>
        - flag player demeter.cakes.count:+:<[craft_amount]>
        - define count <player.flag[demeter.cakes.count]>

        # Check for key award (every 3)
        - define keys_awarded <player.flag[demeter.cakes.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[3].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give demeter_key quantity:<[keys_to_give]>
            - flag player demeter.cakes.keys_awarded:<[keys_should_have]>
            - narrate "<&e><&l>DEMETER KEY!<&r> <&7>Cakes: <&a><[count]><&7>/300"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (300)
        - if <[count]> >= 300 && !<player.has_flag[demeter.component.cake]>:
            - flag player demeter.component.cake:true
            - flag player demeter.component.cake_date:<util.time_now.format>
            # Optional: Give physical component item
            # - give cake_component
            - narrate "<&6><&l>MILESTONE!<&r> <&e>Cake Component obtained! <&7>(300 cakes)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&e>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&6>Cake Component<&7>!"
