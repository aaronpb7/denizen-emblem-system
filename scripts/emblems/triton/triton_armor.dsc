# ============================================
# TRITON DIVINE ARMOR - Quest & Items
# ============================================
#
# Rite of Investiture for Triton:
# - 3-stage riddle quest (throw trident, place conduit, catch fish)
# - Divine gift: Pearl of the Deep
# - Infusion ceremony: diamond armor + gift → divine armor
# - Full set bonus: pity timer (guaranteed OLYMPIAN every 50 crates)
#

# ============================================
# DIVINE GIFT ITEM
# ============================================

triton_divine_gift:
    type: item
    material: heart_of_the_sea
    display name: <&3>Pearl of the Deep
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A pearl from the deepest trench,
    - <&7>resonating with the authority of
    - <&7>a god whose ocean forgot his name.
    - <empty>
    - <&8>Combine with diamond armor
    - <&8>at Triton's altar.
    - <empty>
    - <&b><&l>DIVINE GIFT

# ============================================
# DIVINE ARMOR ITEMS
# ============================================

triton_divine_helm:
    type: item
    material: diamond_helmet
    allow in material recipes: true
    display name: <&3>Tidecrown of the Abyss
    lore:
    - <&7>Infused with the weight of
    - <&7>Triton's forgotten ocean.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Abyssal Current
    - <&7>Guaranteed Neptune Key every 50 keys
    - <empty>
    - <&3><&l><&k>|||<&r> <&3><&l>OLYMPIAN ARMOR<&r> <&3><&l><&k>|||

triton_divine_chestplate:
    type: item
    material: diamond_chestplate
    allow in material recipes: true
    display name: <&3>Depthguard Cuirass
    lore:
    - <&7>Infused with the weight of
    - <&7>Triton's forgotten ocean.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Abyssal Current
    - <&7>Guaranteed Neptune Key every 50 keys
    - <empty>
    - <&3><&l><&k>|||<&r> <&3><&l>OLYMPIAN ARMOR<&r> <&3><&l><&k>|||

triton_divine_leggings:
    type: item
    material: diamond_leggings
    allow in material recipes: true
    display name: <&3>Riptide Greaves
    lore:
    - <&7>Infused with the weight of
    - <&7>Triton's forgotten ocean.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Abyssal Current
    - <&7>Guaranteed Neptune Key every 50 keys
    - <empty>
    - <&3><&l><&k>|||<&r> <&3><&l>OLYMPIAN ARMOR<&r> <&3><&l><&k>|||

triton_divine_boots:
    type: item
    material: diamond_boots
    allow in material recipes: true
    display name: <&3>Abyssal Striders
    lore:
    - <&7>Infused with the weight of
    - <&7>Triton's forgotten ocean.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Abyssal Current
    - <&7>Guaranteed Neptune Key every 50 keys
    - <empty>
    - <&3><&l><&k>|||<&r> <&3><&l>OLYMPIAN ARMOR<&r> <&3><&l><&k>|||

# ============================================
# QUEST EVENT TRACKING
# ============================================

triton_armor_quest_events:
    type: world
    debug: false
    events:
        # Stage 1: Throw a trident
        after projectile launched:
        - if <context.projectile.entity_type> != TRIDENT:
            - stop
        - define shooter <context.shooter.if_null[null]>
        - if <[shooter]> == null:
            - stop
        - if !<[shooter].is_player>:
            - stop
        - define player <[shooter]>
        - if !<[player].has_flag[triton.armor.quest_offered]>:
            - stop
        - if <[player].flag[triton.armor.stage].if_null[0]> != 1:
            - stop
        - if <[player].has_flag[triton.armor.stage1_complete]>:
            - stop
        - flag <[player]> triton.armor.stage1_complete:true
        - flag <[player]> triton.armor.stage:2
        - narrate "<&3><&l>Triton<&r><&7>: <&o>My father built the oceans. Every wave was his design..." targets:<[player]>
        - playsound <[player]> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&3><&l>[Triton]<&r> <&f><[player].name> <&7>has completed Stage 1 of the <&3>Rite of Investiture<&7>!"

        # Stage 2: Place a conduit
        after player places conduit:
        - if !<player.has_flag[triton.armor.quest_offered]>:
            - stop
        - if <player.flag[triton.armor.stage].if_null[0]> != 2:
            - stop
        - if <player.has_flag[triton.armor.stage2_complete]>:
            - stop
        - flag player triton.armor.stage2_complete:true
        - flag player triton.armor.stage:3
        - narrate "<&3><&l>Triton<&r><&7>: <&o>The other gods pity me. I can see it. 'Poor Triton, playing king in an empty sea'..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&3><&l>[Triton]<&r> <&f><player.name> <&7>has completed Stage 2 of the <&3>Rite of Investiture<&7>!"

        # Stage 3: Catch a fish
        after player fishes while caught_fish:
        - if !<player.has_flag[triton.armor.quest_offered]>:
            - stop
        - if <player.flag[triton.armor.stage].if_null[0]> != 3:
            - stop
        - if <player.has_flag[triton.armor.stage3_complete]>:
            - stop
        - flag player triton.armor.stage3_complete:true
        - narrate "<&3><&l>Triton<&r><&7>: <&o>I found something in the deepest trench. A sound. Not a creature — a sound without a source..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&3><&l>[Triton]<&r> <&f><player.name> <&7>has completed all stages of the <&3>Rite of Investiture<&7>!"

# ============================================
# QUEST HANDLER
# ============================================

triton_armor_quest_handler:
    type: task
    debug: false
    script:
    - if <player.has_flag[triton.armor.gifts_received]>:
        - define has_helm <player.inventory.contains_item[diamond_helmet].quantity[1]>
        - define has_chest <player.inventory.contains_item[diamond_chestplate].quantity[1]>
        - define has_legs <player.inventory.contains_item[diamond_leggings].quantity[1]>
        - define has_boots <player.inventory.contains_item[diamond_boots].quantity[1]>
        - define has_gifts <player.inventory.contains_item[triton_divine_gift].quantity[1]>
        - if <[has_helm]> && <[has_chest]> && <[has_legs]> && <[has_boots]> && <[has_gifts]>:
            - run triton_infusion_ceremony
        - else:
            - narrate "<&3><&l>Triton<&r><&7>: You have my pearls, but the infusion requires more."
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
                - narrate "<&c>  ✗ <&7>Pearl of the Deep"
            - else:
                - narrate "<&a>  ✓ <&7>Pearl of the Deep"
            - playsound <player> sound:entity_elder_guardian_ambient volume:0.3
            - inventory open d:triton_info_gui
        - stop

    - if <player.has_flag[triton.armor.stage3_complete]>:
        - run triton_bestow_gifts
        - stop

    - if <player.has_flag[triton.armor.quest_offered]>:
        - define stage <player.flag[triton.armor.stage].if_null[1]>
        - choose <[stage]>:
            - case 1:
                - narrate "<&3><&l>Triton<&r><&7>: <&o>My father carried a weapon that split the waves. You will find its echo in the hands of the drowned. Take it. Hurl it. Let the sea remember what authority feels like."
            - case 2:
                - narrate "<&3><&l>Triton<&r><&7>: <&o>There is a heart that beats only when surrounded by the bones of the ocean. Build its frame. Wake it. Let its pulse reach every corner of the deep."
            - case 3:
                - narrate "<&3><&l>Triton<&r><&7>: <&o>The patient hunter does not chase — they wait. Cast a line into my waters and let the sea decide what you deserve."
        - playsound <player> sound:entity_elder_guardian_ambient volume:0.3
        - inventory open d:triton_info_gui
        - stop

    - run triton_offer_quest

triton_offer_quest:
    type: task
    debug: false
    script:
    - narrate "<&3><&l>Triton<&r><&7>: You proved yourself worthy of the emblem. But the ocean demands more."
    - wait 5s
    - narrate "<&3><&l>Triton<&r><&7>: The drowned infest my waters. The temples are ruins. The deep is dark and silent where it was once alive. I need you to reclaim it."
    - wait 5s
    - narrate "<&3><&l>Triton<&r><&7>: Complete my <&3>Rite of Investiture<&7>, and I will forge you armor that the sea itself will respect. I will speak in riddles — the ocean does not give its secrets freely."
    - wait 5s
    - narrate "<&3><&l>Triton<&r><&7>: <&o>My father carried a weapon that split the waves. You will find its echo in the hands of the drowned. Take it. Hurl it. Let the sea remember what authority feels like."
    - playsound <player> sound:entity_elder_guardian_ambient volume:0.5

    - flag player triton.armor.quest_offered:true
    - flag player triton.armor.stage:1

triton_bestow_gifts:
    type: task
    debug: false
    script:
    - narrate "<&3><&l>Triton<&r><&7>: The ocean stirs again. I felt it — a current, where there was none."
    - wait 5s
    - narrate "<&3><&l>Triton<&r><&7>: These pearls... they are from the deepest trench. Where the sound lives. I dove for them myself, in a time when the ocean still obeyed."
    - wait 5s
    - narrate "<&3><&l>Triton<&r><&7>: Bring them back with diamond armor. The sea will do the rest."
    - wait 4s

    - give triton_divine_gift quantity:1
    - flag player triton.armor.gifts_received:true

    - narrate "<&a>Received: <&3>Pearl of the Deep"
    - narrate "<&7>Bring a <&f>full diamond armor set<&7> and the <&3>Pearls<&7> to Triton for the infusion."
    - playsound <player> sound:entity_elder_guardian_ambient volume:0.8

triton_infusion_ceremony:
    type: task
    debug: false
    script:
    - take diamond_helmet quantity:1
    - take diamond_chestplate quantity:1
    - take diamond_leggings quantity:1
    - take diamond_boots quantity:1
    - take triton_divine_gift quantity:1

    - narrate "<&3><&l>Triton<&r><&7>: Give me the armor. And the pearls. Do not speak."
    - playsound <player> sound:block_enchantment_table_use volume:1.0
    - wait 5s

    - narrate "<&3><&l>Triton<&r><&7>: ...The ocean remembers. I can feel it now — every wave, every current, flowing through the steel. This armor carries the weight of the deep."
    - playsound <player> sound:block_beacon_activate volume:0.8
    - wait 5s

    - give triton_divine_helm
    - give triton_divine_chestplate
    - give triton_divine_leggings
    - give triton_divine_boots

    - flag player triton.armor.crafted:true

    - title "title:<&3><&l>OLYMPIAN ARMOR FORGED" "subtitle:<&b>Triton's Investiture" fade_in:10t stay:50t fade_out:10t
    - playeffect effect:bubble_pop at:<player.location> quantity:100 offset:2.0
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:entity_ender_dragon_growl volume:0.3

    - wait 4s
    - narrate "<&3><&l>Triton<&r><&7>: The ocean bows to you now, champion. Wear this armor, and the deep will never forget your name."

    - announce "<&3><&l>[Triton]<&r> <&f><player.name> <&7>has received the <&3><&l>Olympian Armor of Triton<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5
