# ============================================
# DEMETER DIVINE ARMOR - Quest & Items
# ============================================
#
# Rite of Investiture for Demeter:
# - 3-stage riddle quest (cherry tree, golden apple, suspicious stew)
# - Divine gift: Golden Seeds
# - Infusion ceremony: diamond armor + gift → divine armor
# - Full set bonus: pity timer (guaranteed OLYMPIAN every 50 crates)
#

# ============================================
# DIVINE GIFT ITEM
# ============================================

demeter_divine_gift:
    type: item
    material: wheat_seeds
    display name: <&6>Golden Seeds
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Seeds blessed by Demeter herself,
    - <&7>carrying the warmth of a goddess
    - <&7>who remembers the first harvest.
    - <empty>
    - <&8>Combine with diamond armor
    - <&8>at Demeter's altar.
    - <empty>
    - <&b><&l>DIVINE GIFT

# ============================================
# DIVINE ARMOR ITEMS
# ============================================

demeter_divine_helm:
    type: item
    material: diamond_helmet
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&6>Crown of the Last Harvest
    lore:
    - <&7>Forged from the warmth of
    - <&7>Demeter's last harvest.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Eternal Harvest
    - <&7>Guaranteed Ceres Key every 50 keys
    - <empty>
    - <&6><&l><&k>|||<&r> <&6><&l>OLYMPIAN ARMOR<&r> <&6><&l><&k>|||

demeter_divine_chestplate:
    type: item
    material: diamond_chestplate
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&6>Mantle of Eternal Spring
    lore:
    - <&7>Forged from the warmth of
    - <&7>Demeter's last harvest.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Eternal Harvest
    - <&7>Guaranteed Ceres Key every 50 keys
    - <empty>
    - <&6><&l><&k>|||<&r> <&6><&l>OLYMPIAN ARMOR<&r> <&6><&l><&k>|||

demeter_divine_leggings:
    type: item
    material: diamond_leggings
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&6>Greaves of the Golden Field
    lore:
    - <&7>Forged from the warmth of
    - <&7>Demeter's last harvest.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Eternal Harvest
    - <&7>Guaranteed Ceres Key every 50 keys
    - <empty>
    - <&6><&l><&k>|||<&r> <&6><&l>OLYMPIAN ARMOR<&r> <&6><&l><&k>|||

demeter_divine_boots:
    type: item
    material: diamond_boots
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&6>Rootwalker Treads
    lore:
    - <&7>Forged from the warmth of
    - <&7>Demeter's last harvest.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Eternal Harvest
    - <&7>Guaranteed Ceres Key every 50 keys
    - <empty>
    - <&6><&l><&k>|||<&r> <&6><&l>OLYMPIAN ARMOR<&r> <&6><&l><&k>|||

# ============================================
# QUEST EVENT TRACKING
# ============================================

demeter_armor_quest_events:
    type: world
    debug: false
    events:
        # Stage 1: Grow a cherry tree
        after cherry grows from bonemeal:
        - if !<player.has_flag[demeter.armor.quest_offered]>:
            - stop
        - if <player.flag[demeter.armor.stage].if_null[0]> != 1:
            - stop
        - if <player.has_flag[demeter.armor.stage1_complete]>:
            - stop
        - flag player demeter.armor.stage1_complete:true
        - flag player demeter.armor.stage:2
        - narrate "<&6><&l>Demeter<&r><&7>: <&o>The other gods think I am naive. Perhaps I am. But I remember the first wheat that ever grew..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&6>[Demeter]<&r> <&f><player.name> <&7>has completed Stage 1 of the <&6>Rite of Investiture<&7>!"

        # Stage 2: Consume a golden apple
        after player consumes golden_apple:
        - if !<player.has_flag[demeter.armor.quest_offered]>:
            - stop
        - if <player.flag[demeter.armor.stage].if_null[0]> != 2:
            - stop
        - if <player.has_flag[demeter.armor.stage2_complete]>:
            - stop
        - flag player demeter.armor.stage2_complete:true
        - flag player demeter.armor.stage:3
        - narrate "<&6><&l>Demeter<&r><&7>: <&o>Persephone... she was in the underworld when it happened. Charon will not speak to me about it..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&6>[Demeter]<&r> <&f><player.name> <&7>has completed Stage 2 of the <&6>Rite of Investiture<&7>!"

        # Stage 3: Craft a suspicious stew
        after player crafts suspicious_stew:
        - if !<player.has_flag[demeter.armor.quest_offered]>:
            - stop
        - if <player.flag[demeter.armor.stage].if_null[0]> != 3:
            - stop
        - if <player.has_flag[demeter.armor.stage3_complete]>:
            - stop
        - flag player demeter.armor.stage3_complete:true
        - narrate "<&6><&l>Demeter<&r><&7>: <&o>The ground shook before the sky fell. I felt it in every root, every stem..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&6>[Demeter]<&r> <&f><player.name> <&7>has completed all stages of the <&6>Rite of Investiture<&7>!"

# ============================================
# QUEST HANDLER
# ============================================
# Called from demeter_npc.dsc interact chain when:
# - Player has demeter.emblem.unlocked
# - Player does NOT have demeter.armor.crafted

demeter_armor_quest_handler:
    type: task
    debug: false
    script:
    # State 1: All stages done + gifts received + has materials → INFUSION
    - if <player.has_flag[demeter.armor.gifts_received]>:
        # Check if player has diamond armor + 4 gifts
        - define has_helm <player.inventory.contains_item[diamond_helmet].quantity[1]>
        - define has_chest <player.inventory.contains_item[diamond_chestplate].quantity[1]>
        - define has_legs <player.inventory.contains_item[diamond_leggings].quantity[1]>
        - define has_boots <player.inventory.contains_item[diamond_boots].quantity[1]>
        - define has_gifts <player.inventory.contains_item[demeter_divine_gift].quantity[1]>
        - if <[has_helm]> && <[has_chest]> && <[has_legs]> && <[has_boots]> && <[has_gifts]>:
            - run demeter_infusion_ceremony
        - else:
            # Remind what they need
            - narrate "<&6><&l>Demeter<&r><&7>: You carry my gifts, but the infusion requires more."
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
                - narrate "<&c>  ✗ <&7>Golden Seeds"
            - else:
                - narrate "<&a>  ✓ <&7>Golden Seeds"
            - playsound <player> sound:entity_villager_ambient volume:0.3
            - inventory open d:demeter_info_gui
        - stop

    # State 2: All 3 stages complete → GIVE GIFTS
    - if <player.has_flag[demeter.armor.stage3_complete]>:
        - run demeter_bestow_gifts
        - stop

    # State 3: Quest active → REPEAT RIDDLE
    - if <player.has_flag[demeter.armor.quest_offered]>:
        - define stage <player.flag[demeter.armor.stage].if_null[1]>
        - choose <[stage]>:
            - case 1:
                - narrate "<&6><&l>Demeter<&r><&7>: <&o>In the eastern lands, a tree blooms pink where no other dares. Coax one from the soil, and my warmth will remember how to grow."
            - case 2:
                - narrate "<&6><&l>Demeter<&r><&7>: <&o>There is a fruit wrapped in sunlight and metal. Kings hoard it. The desperate devour it. Eat one in my name, and feel what divinity once tasted like."
            - case 3:
                - narrate "<&6><&l>Demeter<&r><&7>: <&o>Combine a bowl, a bloom, and something that grows in the dark. The result will look wrong — trust it. The strangest harvests hold the deepest power."
        - playsound <player> sound:entity_villager_ambient volume:0.3
        - inventory open d:demeter_info_gui
        - stop

    # State 4: Quest not yet offered → OFFER QUEST
    - run demeter_offer_quest

# ============================================
# OFFER QUEST
# ============================================

demeter_offer_quest:
    type: task
    debug: false
    script:
    - narrate "<&6><&l>Demeter<&r><&7>: You have proven your devotion to the harvest. But I would ask more of you."
    - wait 5s
    - narrate "<&6><&l>Demeter<&r><&7>: The land is scarred. Where gardens once bloomed, only dust remains. I need you to restore what was lost — not for keys or rewards, but because the earth <&6>needs<&7> it."
    - wait 5s
    - narrate "<&6><&l>Demeter<&r><&7>: Complete my <&6>Rite of Investiture<&7>, and I will forge you armor worthy of a champion. I will speak in riddles — prove you understand the harvest."
    - wait 5s
    - narrate "<&6><&l>Demeter<&r><&7>: <&o>In the eastern lands, a tree blooms pink where no other dares. Coax one from the soil, and my warmth will remember how to grow."
    - playsound <player> sound:block_amethyst_block_chime volume:0.5

    - flag player demeter.armor.quest_offered:true
    - flag player demeter.armor.stage:1

# ============================================
# BESTOW GIFTS
# ============================================

demeter_bestow_gifts:
    type: task
    debug: false
    script:
    - narrate "<&6><&l>Demeter<&r><&7>: You have done everything I asked. The land remembers how to grow again."
    - wait 5s
    - narrate "<&6><&l>Demeter<&r><&7>: These seeds... they are from my garden on Olympus. The last seeds. I kept them close when everything fell."
    - wait 5s
    - narrate "<&6><&l>Demeter<&r><&7>: Take them. Bring them back to me with a full suit of diamond armor, and I will infuse them with what remains of my power."
    - wait 4s

    - give demeter_divine_gift quantity:1
    - flag player demeter.armor.gifts_received:true

    - narrate "<&a>Received: <&6>Golden Seeds"
    - narrate "<&7>Bring a <&f>full diamond armor set<&7> and the <&6>Golden Seeds<&7> to Demeter for the infusion."
    - playsound <player> sound:block_amethyst_block_chime volume:0.8

# ============================================
# INFUSION CEREMONY
# ============================================

demeter_infusion_ceremony:
    type: task
    debug: false
    script:
    # Take materials
    - take item:diamond_helmet quantity:1
    - take item:diamond_chestplate quantity:1
    - take item:diamond_leggings quantity:1
    - take item:diamond_boots quantity:1
    - take item:demeter_divine_gift quantity:1

    # Ceremony dialogue
    - narrate "<&6><&l>Demeter<&r><&7>: Place the armor before me. And the seeds... yes."
    - playsound <player> sound:block_enchantment_table_use volume:1.0
    - wait 5s

    - narrate "<&6><&l>Demeter<&r><&7>: I pour what warmth I have left into this steel. It will not break. It will not falter. Like the harvest — it endures."
    - playsound <player> sound:block_beacon_activate volume:0.8
    - wait 5s

    # Give divine armor
    - give demeter_divine_helm
    - give demeter_divine_chestplate
    - give demeter_divine_leggings
    - give demeter_divine_boots

    # Set flag
    - flag player demeter.armor.crafted:true

    # Effects
    - title "title:<&6><&l>OLYMPIAN ARMOR FORGED" "subtitle:<&e>Demeter's Investiture" fade_in:10t stay:50t fade_out:10t
    - playeffect effect:totem at:<player.location> quantity:100 offset:2.0
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:entity_ender_dragon_growl volume:0.3

    - wait 4s
    - narrate "<&6><&l>Demeter<&r><&7>: Wear it with pride, champion. You carry the last warmth of Olympus."

    # Server announcement
    - announce "<&6><&l>[Demeter]<&r> <&f><player.name> <&7>has received the <&6><&l>Olympian Armor of Demeter<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5
