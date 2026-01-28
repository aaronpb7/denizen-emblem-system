# ============================================
# DEMETER EVENTS - Activity Tracking & XP
# ============================================
#
# XP-based progression with activity counters for components
# 1. Wheat harvesting → 2 XP, component at 15,000
# 2. Cow breeding → 10 XP, component at 2,000
# 3. Cake crafting → 12 XP, component at 500
#
# All other crops, animals, and foods also award XP (see farming_xp_rates)
# Only tracks when player role = FARMING
#

# ============================================
# CROP HARVESTING
# ============================================

farming_crop_harvest:
    type: world
    debug: false
    events:
        after player breaks wheat|carrots|potatoes|beetroots|nether_wart|cocoa|pumpkin|melon|sugar_cane|cactus|kelp|bamboo:
        # Role gate - only FARMING role counts
        - if <player.flag[role.active]> != FARMING:
            - stop

        # Get material name
        - define crop <context.material.name>

        # Age check for crops that have growth stages
        - if <list[wheat|carrots|potatoes|beetroots|nether_wart|cocoa].contains[<[crop]>]>:
            - if !<context.material.has_age>:
                - stop
            # Get max age for each crop type
            - define max_age 7
            - if <[crop]> == nether_wart:
                - define max_age 3
            - else if <[crop]> == cocoa:
                - define max_age 2
            # Only award XP for fully grown crops
            - if <context.material.age> != <[max_age]>:
                - stop

        # Award XP based on crop type
        - define xp_amount <script[farming_xp_rates].data_key[crops.<[crop]>].if_null[0]>
        - if <[xp_amount]> > 0:
            - proc[award_farming_xp].context[<player>|<[xp_amount]>|<[crop]>]

        # Track wheat specifically for component milestone
        - if <[crop]> == wheat:
            - flag player demeter.wheat.count:++
            - define count <player.flag[demeter.wheat.count]>

            # Check for component milestone (15,000)
            - if <[count]> >= 15000 && !<player.has_flag[demeter.component.wheat]>:
                - flag player demeter.component.wheat:true
                - flag player demeter.component.wheat_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Wheat Component obtained! <&7>(15,000 wheat)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&e>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&6>Wheat Component<&7>!"

# ============================================
# ANIMAL BREEDING
# ============================================

farming_animal_breeding:
    type: world
    debug: false
    events:
        after cow|sheep|pig|chicken|rabbit|horse|llama|bee|turtle|hoglin breeds:
        # Extract breeder
        - define breeder <context.breeder>
        - if <[breeder]> == null || !<[breeder].is_player>:
            - stop

        # Role gate
        - if <[breeder].flag[role.active]> != FARMING:
            - stop

        # Get animal type
        - define animal <context.entity.entity_type.name>

        # Award XP based on animal type
        - define xp_amount <script[farming_xp_rates].data_key[animals.<[animal]>].if_null[0]>
        - if <[xp_amount]> > 0:
            - proc[award_farming_xp].context[<[breeder]>|<[xp_amount]>|<[animal]>]

        # Track cows specifically for component milestone
        - if <[animal]> == cow:
            - flag <[breeder]> demeter.cows.count:++
            - define count <[breeder].flag[demeter.cows.count]>

            # Check for component milestone (2,000)
            - if <[count]> >= 2000 && !<[breeder].has_flag[demeter.component.cow]>:
                - flag <[breeder]> demeter.component.cow:true
                - flag <[breeder]> demeter.component.cow_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Cow Component obtained! <&7>(2,000 cows)" targets:<[breeder]>
                - playsound <[breeder]> sound:ui_toast_challenge_complete
                - announce "<&e>[Promachos]<&r> <&f><[breeder].name> <&7>has obtained the <&6>Cow Component<&7>!"

# ============================================
# FOOD CRAFTING
# ============================================

farming_food_crafting:
    type: world
    debug: false
    events:
        after player crafts bread|cookie|cake|pumpkin_pie|mushroom_stew|rabbit_stew|beetroot_soup|honey_bottle|suspicious_stew:
        # Role gate
        - if <player.flag[role.active]> != FARMING:
            - stop

        # Get food name
        - define food <context.item.material.name>
        - define craft_amount <context.item.quantity>

        # Award XP based on food type (multiply by quantity for bulk crafts)
        - define xp_per_item <script[farming_xp_rates].data_key[foods.<[food]>].if_null[0]>
        - if <[xp_per_item]> > 0:
            - define total_xp <[xp_per_item].mul[<[craft_amount]>]>
            - proc[award_farming_xp].context[<player>|<[total_xp]>|<[food]>]

        # Track cakes specifically for component milestone
        - if <[food]> == cake:
            - flag player demeter.cakes.count:+:<[craft_amount]>
            - define count <player.flag[demeter.cakes.count]>

            # Check for component milestone (500)
            - if <[count]> >= 500 && !<player.has_flag[demeter.component.cake]>:
                - flag player demeter.component.cake:true
                - flag player demeter.component.cake_date:<util.time_now.format>
                - narrate "<&6><&l>MILESTONE!<&r> <&e>Cake Component obtained! <&7>(500 cakes)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&e>[Promachos]<&r> <&f><player.name> <&7>has obtained the <&6>Cake Component<&7>!"
