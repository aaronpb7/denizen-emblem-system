# ============================================
# HEPHAESTUS DIVINE ARMOR - Quest & Items
# ============================================
#
# Rite of Investiture for Hephaestus:
# - 3-stage riddle quest (nether portal, repair iron golem, anvil repair)
# - Divine gift: Embers of the Forge
# - Infusion ceremony: diamond armor + gift → divine armor
# - Full set bonus: pity timer (guaranteed OLYMPIAN every 50 crates)
#

# ============================================
# DIVINE GIFT ITEM
# ============================================

hephaestus_divine_gift:
    type: item
    material: magma_cream
    display name: <&8>Embers of the Forge
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>Embers from the divine forge,
    - <&7>still burning with the heat of
    - <&7>a god who refused to stop working.
    - <empty>
    - <&8>Combine with diamond armor
    - <&8>at Hephaestus' anvil.
    - <empty>
    - <&b><&l>DIVINE GIFT

# ============================================
# DIVINE ARMOR ITEMS
# ============================================

hephaestus_divine_helm:
    type: item
    material: diamond_helmet
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&8>Visage of the Eternal Forge
    lore:
    - <&7>Forged with the last heat of
    - <&7>Hephaestus' divine anvil.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Undying Flame
    - <&7>Guaranteed Vulcan Key every 50 keys
    - <empty>
    - <&8><&l><&k>|||<&r> <&8><&l>OLYMPIAN ARMOR<&r> <&8><&l><&k>|||

hephaestus_divine_chestplate:
    type: item
    material: diamond_chestplate
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&8>Anvil-Born Cuirass
    lore:
    - <&7>Forged with the last heat of
    - <&7>Hephaestus' divine anvil.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Undying Flame
    - <&7>Guaranteed Vulcan Key every 50 keys
    - <empty>
    - <&8><&l><&k>|||<&r> <&8><&l>OLYMPIAN ARMOR<&r> <&8><&l><&k>|||

hephaestus_divine_leggings:
    type: item
    material: diamond_leggings
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&8>Cinderguard Greaves
    lore:
    - <&7>Forged with the last heat of
    - <&7>Hephaestus' divine anvil.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Undying Flame
    - <&7>Guaranteed Vulcan Key every 50 keys
    - <empty>
    - <&8><&l><&k>|||<&r> <&8><&l>OLYMPIAN ARMOR<&r> <&8><&l><&k>|||

hephaestus_divine_boots:
    type: item
    material: diamond_boots
    allow in material recipes: true
    mechanisms:
        unbreakable: true
    display name: <&8>Emberstep Sabatons
    lore:
    - <&7>Forged with the last heat of
    - <&7>Hephaestus' divine anvil.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Undying Flame
    - <&7>Guaranteed Vulcan Key every 50 keys
    - <empty>
    - <&8><&l><&k>|||<&r> <&8><&l>OLYMPIAN ARMOR<&r> <&8><&l><&k>|||

# ============================================
# QUEST EVENT TRACKING
# ============================================

hephaestus_armor_quest_events:
    type: world
    debug: false
    events:
        # Stage 1: Light a nether portal
        after portal created because fire:
        - if !<player.has_flag[hephaestus.armor.quest_offered]>:
            - stop
        - if <player.flag[hephaestus.armor.stage].if_null[0]> != 1:
            - stop
        - if <player.has_flag[hephaestus.armor.stage1_complete]>:
            - stop
        - flag player hephaestus.armor.stage1_complete:true
        - flag player hephaestus.armor.stage:2
        - narrate "<&8><&l>Hephaestus<&r><&7>: <&o>I was the first god to be thrown from Olympus. Did you know that? My own mother threw me..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&8><&l>[Hephaestus]<&r> <&f><player.name> <&7>has completed Stage 1 of the <&8>Rite of Investiture<&7>!"

        # Stage 2: Repair an iron golem (right-click with iron ingot)
        after player right clicks iron_golem with:iron_ingot:
        - if !<player.has_flag[hephaestus.armor.quest_offered]>:
            - stop
        - if <player.flag[hephaestus.armor.stage].if_null[0]> != 2:
            - stop
        - if <player.has_flag[hephaestus.armor.stage2_complete]>:
            - stop
        - flag player hephaestus.armor.stage2_complete:true
        - flag player hephaestus.armor.stage:3
        - narrate "<&8><&l>Hephaestus<&r><&7>: <&o>I built the chains that held Prometheus. I built the box that Pandora opened..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&8><&l>[Hephaestus]<&r> <&f><player.name> <&7>has completed Stage 2 of the <&8>Rite of Investiture<&7>!"

        # Stage 3: Repair an item on an anvil
        after player prepares anvil craft item:
        - if !<player.has_flag[hephaestus.armor.quest_offered]>:
            - stop
        - if <player.flag[hephaestus.armor.stage].if_null[0]> != 3:
            - stop
        - if <player.has_flag[hephaestus.armor.stage3_complete]>:
            - stop
        - flag player hephaestus.armor.stage3_complete:true
        - narrate "<&8><&l>Hephaestus<&r><&7>: <&o>The locks I built for the vaults — they were not just physical. They were conceptual..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&8><&l>[Hephaestus]<&r> <&f><player.name> <&7>has completed all stages of the <&8>Rite of Investiture<&7>!"

# ============================================
# QUEST HANDLER
# ============================================

hephaestus_armor_quest_handler:
    type: task
    debug: false
    script:
    # State 1: Gifts received → check for infusion or remind
    - if <player.has_flag[hephaestus.armor.gifts_received]>:
        - define has_helm <player.inventory.contains_item[diamond_helmet].quantity[1]>
        - define has_chest <player.inventory.contains_item[diamond_chestplate].quantity[1]>
        - define has_legs <player.inventory.contains_item[diamond_leggings].quantity[1]>
        - define has_boots <player.inventory.contains_item[diamond_boots].quantity[1]>
        - define has_gifts <player.inventory.contains_item[hephaestus_divine_gift].quantity[1]>
        - if <[has_helm]> && <[has_chest]> && <[has_legs]> && <[has_boots]> && <[has_gifts]>:
            - run hephaestus_infusion_ceremony
        - else:
            - narrate "<&8><&l>Hephaestus<&r><&7>: You have my embers, but the work isn't done."
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
                - narrate "<&c>  ✗ <&7>Embers of the Forge"
            - else:
                - narrate "<&a>  ✓ <&7>Embers of the Forge"
            - playsound <player> sound:block_anvil_land volume:0.3
            - inventory open d:hephaestus_info_gui
        - stop

    # State 2: All 3 stages complete → give gifts
    - if <player.has_flag[hephaestus.armor.stage3_complete]>:
        - run hephaestus_bestow_gifts
        - stop

    # State 3: Quest active → REPEAT RIDDLE
    - if <player.has_flag[hephaestus.armor.quest_offered]>:
        - define stage <player.flag[hephaestus.armor.stage].if_null[1]>
        - choose <[stage]>:
            - case 1:
                - narrate "<&8><&l>Hephaestus<&r><&7>: <&o>Obsidian weeps where lava meets water. Frame those tears into a doorway, then set it alight. The other side remembers my forge."
            - case 2:
                - narrate "<&8><&l>Hephaestus<&r><&7>: <&o>I built them to protect. Iron body, iron heart. Find one of my children — broken, wandering — and mend it with the metal it was born from."
            - case 3:
                - narrate "<&8><&l>Hephaestus<&r><&7>: <&o>The iron block sings when hammer meets steel. Bring something damaged to my anvil and make it whole. That is what a smith does."
        - playsound <player> sound:block_anvil_land volume:0.3
        - inventory open d:hephaestus_info_gui
        - stop

    # State 4: Offer quest
    - run hephaestus_offer_quest

hephaestus_offer_quest:
    type: task
    debug: false
    script:
    - narrate "<&8><&l>Hephaestus<&r><&7>: You earned the emblem. Good. But I need more from you."
    - wait 5s
    - narrate "<&8><&l>Hephaestus<&r><&7>: My forge is cold. Not just the metal — the <&8>idea<&7> of the forge is fading. I need you to reignite it. Not with words. With understanding."
    - wait 5s
    - narrate "<&8><&l>Hephaestus<&r><&7>: Complete my <&8>Rite of Investiture<&7>, and I will build you armor that even a god would envy. I will speak in riddles — a smith who cannot solve problems is no smith at all."
    - wait 5s
    - narrate "<&8><&l>Hephaestus<&r><&7>: <&o>Obsidian weeps where lava meets water. Frame those tears into a doorway, then set it alight. The other side remembers my forge."
    - playsound <player> sound:block_anvil_use volume:0.5

    - flag player hephaestus.armor.quest_offered:true
    - flag player hephaestus.armor.stage:1

hephaestus_bestow_gifts:
    type: task
    debug: false
    script:
    - narrate "<&8><&l>Hephaestus<&r><&7>: Hmph. You did it. The forge burns again."
    - wait 5s
    - narrate "<&8><&l>Hephaestus<&r><&7>: These embers... they are from the last thing I forged on Olympus. I never told anyone what it was. I still won't."
    - wait 5s
    - narrate "<&8><&l>Hephaestus<&r><&7>: Bring these back with diamond armor. I'll do the rest."
    - wait 4s

    - give hephaestus_divine_gift quantity:1
    - flag player hephaestus.armor.gifts_received:true

    - narrate "<&a>Received: <&8>Embers of the Forge"
    - narrate "<&7>Bring a <&f>full diamond armor set<&7> and the <&8>Embers<&7> to Hephaestus for the infusion."
    - playsound <player> sound:block_anvil_use volume:0.8

hephaestus_infusion_ceremony:
    type: task
    debug: false
    script:
    - take item:diamond_helmet quantity:1
    - take item:diamond_chestplate quantity:1
    - take item:diamond_leggings quantity:1
    - take item:diamond_boots quantity:1
    - take item:hephaestus_divine_gift quantity:1

    - narrate "<&8><&l>Hephaestus<&r><&7>: Set it down. All of it. Don't talk."
    - playsound <player> sound:block_anvil_use volume:1.0
    - wait 5s

    - narrate "<&8><&l>Hephaestus<&r><&7>: ...There. Feel the heat? That's not just fire. That's every weapon I ever made, every shield, every lock. All of it, poured into this steel."
    - playsound <player> sound:block_beacon_activate volume:0.8
    - wait 5s

    - give hephaestus_divine_helm
    - give hephaestus_divine_chestplate
    - give hephaestus_divine_leggings
    - give hephaestus_divine_boots

    - flag player hephaestus.armor.crafted:true

    - title "title:<&8><&l>OLYMPIAN ARMOR FORGED" "subtitle:<&f>Hephaestus' Investiture" fade_in:10t stay:50t fade_out:10t
    - playeffect effect:lava at:<player.location> quantity:100 offset:2.0
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:entity_ender_dragon_growl volume:0.3

    - wait 4s
    - narrate "<&8><&l>Hephaestus<&r><&7>: Don't thank me. Just don't break it. ...You can't break it. I made sure."

    - announce "<&8><&l>[Hephaestus]<&r> <&f><player.name> <&7>has received the <&8><&l>Olympian Armor of Hephaestus<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5
