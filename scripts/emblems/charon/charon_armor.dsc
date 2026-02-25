# ============================================
# CHARON DIVINE ARMOR - Quest & Items
# ============================================
#
# Rite of Investiture for Charon:
# - 3-stage riddle quest (craft beacon, brew potion of harming, kill piglin brute)
# - Divine gift: Obol of Passage
# - Infusion ceremony: diamond armor + gift → divine armor
# - Full set bonus: pity timer (guaranteed OLYMPIAN every 50 crates)
#

# ============================================
# DIVINE GIFT ITEM
# ============================================

charon_divine_gift:
    type: item
    material: gold_nugget
    display name: <&5>Obol of Passage
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A coin placed on the eyes of
    - <&7>the dead, minted by a ferryman
    - <&7>older than death itself.
    - <empty>
    - <&8>Combine with diamond armor
    - <&8>at Charon's altar.
    - <empty>
    - <&b><&l>DIVINE GIFT

# ============================================
# DIVINE ARMOR ITEMS
# ============================================

charon_divine_helm:
    type: item
    material: diamond_helmet
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&5>Ferryman's Cowl
    lore:
    - <&7>Woven from the currents of
    - <&7>the river Styx itself.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Ferryman's Toll
    - <&7>Guaranteed Dis Key every 50 keys
    - <empty>
    - <&5><&l><&k>|||<&r> <&5><&l>OLYMPIAN ARMOR<&r> <&5><&l><&k>|||

charon_divine_chestplate:
    type: item
    material: diamond_chestplate
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&5>Shroud of the Styx
    lore:
    - <&7>Woven from the currents of
    - <&7>the river Styx itself.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Ferryman's Toll
    - <&7>Guaranteed Dis Key every 50 keys
    - <empty>
    - <&5><&l><&k>|||<&r> <&5><&l>OLYMPIAN ARMOR<&r> <&5><&l><&k>|||

charon_divine_leggings:
    type: item
    material: diamond_leggings
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&5>Deathwalker Greaves
    lore:
    - <&7>Woven from the currents of
    - <&7>the river Styx itself.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Ferryman's Toll
    - <&7>Guaranteed Dis Key every 50 keys
    - <empty>
    - <&5><&l><&k>|||<&r> <&5><&l>OLYMPIAN ARMOR<&r> <&5><&l><&k>|||

charon_divine_boots:
    type: item
    material: diamond_boots
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&5>Stygian Sabatons
    lore:
    - <&7>Woven from the currents of
    - <&7>the river Styx itself.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Ferryman's Toll
    - <&7>Guaranteed Dis Key every 50 keys
    - <empty>
    - <&5><&l><&k>|||<&r> <&5><&l>OLYMPIAN ARMOR<&r> <&5><&l><&k>|||

# ============================================
# QUEST EVENT TRACKING
# ============================================

charon_armor_quest_events:
    type: world
    debug: false
    events:
        # Stage 1: Craft a beacon
        after player crafts beacon:
        - if !<player.has_flag[charon.armor.quest_offered]>:
            - stop
        - if <player.flag[charon.armor.stage].if_null[0]> != 1:
            - stop
        - if <player.has_flag[charon.armor.stage1_complete]>:
            - stop
        - flag player charon.armor.stage1_complete:true
        - flag player charon.armor.stage:2
        - narrate "<&5><&l>Charon<&r><&7>: <&o>Mortals fear death. I have never understood this. Death was a crossing. A quiet boat ride..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&5><&l>[Charon]<&r> <&f><player.name> <&7>has completed Stage 1 of the <&5>Rite of Investiture<&7>!"

        # Stage 2: Brew a potion of harming
        after brewing stand brews:
        - define found_harming false
        - foreach <context.result> as:item:
            - if <[item].material.name> == POTION || <[item].material.name> == SPLASH_POTION || <[item].material.name> == LINGERING_POTION:
                - define ptype <[item].effects_data.first.get[base_type].if_null[null]>
                - if <[ptype]> == harming || <[ptype]> == strong_harming:
                    - define found_harming true
        - if !<[found_harming]>:
            - stop
        - define loc <context.location>
        - define player <[loc].find_players_within[10].first.if_null[null]>
        - if <[player]> == null:
            - stop
        - if !<[player].has_flag[charon.armor.quest_offered]>:
            - stop
        - if <[player].flag[charon.armor.stage].if_null[0]> != 2:
            - stop
        - if <[player].has_flag[charon.armor.stage2_complete]>:
            - stop
        - flag <[player]> charon.armor.stage2_complete:true
        - flag <[player]> charon.armor.stage:3
        - narrate "<&5><&l>Charon<&r><&7>: <&o>The river began flowing backwards. Do you understand what that means?..." targets:<[player]>
        - playsound <[player]> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&5><&l>[Charon]<&r> <&f><[player].name> <&7>has completed Stage 2 of the <&5>Rite of Investiture<&7>!"

        # Stage 3: Kill a piglin brute
        after player kills piglin_brute:
        - if !<player.has_flag[charon.armor.quest_offered]>:
            - stop
        - if <player.flag[charon.armor.stage].if_null[0]> != 3:
            - stop
        - if <player.has_flag[charon.armor.stage3_complete]>:
            - stop
        - flag player charon.armor.stage3_complete:true
        - narrate "<&5><&l>Charon<&r><&7>: <&o>I will tell you something I have told no one. When the underworld fractured, I heard a voice..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&5><&l>[Charon]<&r> <&f><player.name> <&7>has completed all stages of the <&5>Rite of Investiture<&7>!"

# ============================================
# QUEST HANDLER
# ============================================

charon_armor_quest_handler:
    type: task
    debug: false
    script:
    - if <player.has_flag[charon.armor.gifts_received]>:
        - define has_helm <player.inventory.contains_item[diamond_helmet].quantity[1]>
        - define has_chest <player.inventory.contains_item[diamond_chestplate].quantity[1]>
        - define has_legs <player.inventory.contains_item[diamond_leggings].quantity[1]>
        - define has_boots <player.inventory.contains_item[diamond_boots].quantity[1]>
        - define has_gifts <player.inventory.contains_item[charon_divine_gift].quantity[1]>
        - if <[has_helm]> && <[has_chest]> && <[has_legs]> && <[has_boots]> && <[has_gifts]>:
            - run charon_infusion_ceremony
        - else:
            - narrate "<&5><&l>Charon<&r><&7>: You have my obols, but the crossing is not yet complete."
            - narrate "<&7>You need:"
            - if !<[has_helm]>:
                - narrate "<&c>  ✗ <&7>Diamond Helmet"
            - else:
                - narrate "<&a>  ✓ <&7>Diamond Helmet"
            - if !<[has_chest]>:
                - narrate "<&c>  ✗ <&7>Diamond Chestplate"
            - else:
                - narrate "<&a>  ✓ <&7>Diamond Chestplate"
            - if !<[has_legs]>:
                - narrate "<&c>  ✗ <&7>Diamond Leggings"
            - else:
                - narrate "<&a>  ✓ <&7>Diamond Leggings"
            - if !<[has_boots]>:
                - narrate "<&c>  ✗ <&7>Diamond Boots"
            - else:
                - narrate "<&a>  ✓ <&7>Diamond Boots"
            - if !<[has_gifts]>:
                - narrate "<&c>  ✗ <&7>Obol of Passage"
            - else:
                - narrate "<&a>  ✓ <&7>Obol of Passage"
            - playsound <player> sound:entity_wither_ambient volume:0.3
            - inventory open d:charon_info_gui
        - stop

    - if <player.has_flag[charon.armor.stage3_complete]>:
        - run charon_bestow_gifts
        - stop

    - if <player.has_flag[charon.armor.quest_offered]>:
        - define stage <player.flag[charon.armor.stage].if_null[1]>
        - choose <[stage]>:
            - case 1:
                - narrate "<&5><&l>Charon<&r><&7>: <&o>There is a star that fell from the sky, trapped inside three skulls and sand. Free it. Build it a throne of glass and mineral. Let it scream light into the dark."
            - case 2:
                - narrate "<&5><&l>Charon<&r><&7>: <&o>Death can be distilled. A spider's eye, twisted wrong, dropped into a bottle of breath. Brew it. Hold it. Know what you carry."
            - case 3:
                - narrate "<&5><&l>Charon<&r><&7>: <&o>In the crimson forests, a golden brute guards treasure it does not understand. It does not barter. It does not flee. End it."
        - playsound <player> sound:entity_wither_ambient volume:0.3
        - inventory open d:charon_info_gui
        - stop

    - run charon_offer_quest

charon_offer_quest:
    type: task
    debug: false
    script:
    - narrate "<&5><&l>Charon<&r><&7>: You earned the emblem. That means the dead accept you. That is... uncommon."
    - wait 5s
    - narrate "<&5><&l>Charon<&r><&7>: The river Styx is broken. Souls wander without direction. The boundary between life and death thins with every passing day. I need you to mend it."
    - wait 5s
    - narrate "<&5><&l>Charon<&r><&7>: Complete my <&5>Rite of Investiture<&7>, and I will give you armor forged from the river itself. I will speak in riddles — death does not explain itself to the living."
    - wait 5s
    - narrate "<&5><&l>Charon<&r><&7>: <&o>There is a star that fell from the sky, trapped inside three skulls and sand. Free it. Build it a throne of glass and mineral. Let it scream light into the dark."
    - playsound <player> sound:entity_wither_ambient volume:0.5

    - flag player charon.armor.quest_offered:true
    - flag player charon.armor.stage:1

charon_bestow_gifts:
    type: task
    debug: false
    script:
    - narrate "<&5><&l>Charon<&r><&7>: ...It is done. The river flows forward again. For now."
    - wait 5s
    - narrate "<&5><&l>Charon<&r><&7>: These coins... I have carried them since before Olympus was built. They are the first obols. The first payment for passage."
    - wait 5s
    - narrate "<&5><&l>Charon<&r><&7>: Bring them back with diamond armor. Death will do the rest."
    - wait 4s

    - give charon_divine_gift quantity:1
    - flag player charon.armor.gifts_received:true

    - narrate "<&a>Received: <&5>Obol of Passage"
    - narrate "<&7>Bring a <&f>full diamond armor set<&7> and the <&5>Obols<&7> to Charon for the infusion."
    - playsound <player> sound:entity_wither_ambient volume:0.8

charon_infusion_ceremony:
    type: task
    debug: false
    script:
    - take item:diamond_helmet quantity:1
    - take item:diamond_chestplate quantity:1
    - take item:diamond_leggings quantity:1
    - take item:diamond_boots quantity:1
    - take item:charon_divine_gift quantity:1

    - narrate "<&5><&l>Charon<&r><&7>: Place it before me. The coins... on the armor. Yes."
    - playsound <player> sound:block_enchantment_table_use volume:1.0
    - wait 5s

    - narrate "<&5><&l>Charon<&r><&7>: ...The river flows through the steel now. Can you feel it? Cold. Not the cold of winter — the cold of endings. But also beginnings."
    - playsound <player> sound:block_beacon_activate volume:0.8
    - wait 5s

    - give charon_divine_helm
    - give charon_divine_chestplate
    - give charon_divine_leggings
    - give charon_divine_boots

    - flag player charon.armor.crafted:true

    - title "title:<&5><&l>OLYMPIAN ARMOR FORGED" "subtitle:<&d>Charon's Investiture" fade_in:10t stay:50t fade_out:10t
    - playeffect effect:soul_fire_flame at:<player.location> quantity:100 offset:2.0
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:entity_ender_dragon_growl volume:0.3

    - wait 4s
    - narrate "<&5><&l>Charon<&r><&7>: You walk between worlds now, champion. The living will fear you. The dead will respect you. As they should."

    - announce "<&5><&l>[Charon]<&r> <&f><player.name> <&7>has received the <&5><&l>Olympian Armor of Charon<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5
