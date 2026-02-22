# ============================================
# HERACLES DIVINE ARMOR - Quest & Items
# ============================================
#
# Rite of Investiture for Heracles:
# - 3-stage riddle quest (tame wolf, kill ravager, reflect ghast fireball)
# - Divine gift: Sigil of Heracles
# - Infusion ceremony: diamond armor + gift → divine armor
# - Full set bonus: pity timer (guaranteed OLYMPIAN every 50 crates)
#

# ============================================
# DIVINE GIFT ITEM
# ============================================

heracles_divine_gift:
    type: item
    material: paper
    display name: <&c>Sigil of Heracles
    enchantments:
    - mending:1
    mechanisms:
        hides: ENCHANTS
    lore:
    - <&7>A sigil bearing the mark of
    - <&7>Heracles, drawn in the blood
    - <&7>of a demi-god who never quit.
    - <empty>
    - <&8>Combine with diamond armor
    - <&8>at Heracles' altar.
    - <empty>
    - <&b><&l>DIVINE GIFT

# ============================================
# DIVINE ARMOR ITEMS
# ============================================

heracles_divine_helm:
    type: item
    material: diamond_helmet
    allow in material recipes: true
    display name: <&c>Nemean Crown
    lore:
    - <&7>Bearing the strength of every
    - <&7>labor Heracles endured.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Thirteenth Labor
    - <&7>Guaranteed Mars Key every 50 keys
    - <empty>
    - <&c><&l><&k>|||<&r> <&c><&l>OLYMPIAN ARMOR<&r> <&c><&l><&k>|||

heracles_divine_chestplate:
    type: item
    material: diamond_chestplate
    allow in material recipes: true
    display name: <&c>Plate of the Twelve Labors
    lore:
    - <&7>Bearing the strength of every
    - <&7>labor Heracles endured.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Thirteenth Labor
    - <&7>Guaranteed Mars Key every 50 keys
    - <empty>
    - <&c><&l><&k>|||<&r> <&c><&l>OLYMPIAN ARMOR<&r> <&c><&l><&k>|||

heracles_divine_leggings:
    type: item
    material: diamond_leggings
    allow in material recipes: true
    display name: <&c>Greaves of the Last Stand
    lore:
    - <&7>Bearing the strength of every
    - <&7>labor Heracles endured.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Thirteenth Labor
    - <&7>Guaranteed Mars Key every 50 keys
    - <empty>
    - <&c><&l><&k>|||<&r> <&c><&l>OLYMPIAN ARMOR<&r> <&c><&l><&k>|||

heracles_divine_boots:
    type: item
    material: diamond_boots
    allow in material recipes: true
    display name: <&c>Titan's Stride
    lore:
    - <&7>Bearing the strength of every
    - <&7>labor Heracles endured.
    - <empty>
    - <&e>Full Set Bonus<&co> <&6>The Thirteenth Labor
    - <&7>Guaranteed Mars Key every 50 keys
    - <empty>
    - <&c><&l><&k>|||<&r> <&c><&l>OLYMPIAN ARMOR<&r> <&c><&l><&k>|||

# ============================================
# QUEST EVENT TRACKING
# ============================================

heracles_armor_quest_events:
    type: world
    debug: false
    events:
        # Stage 1: Tame a wolf
        after player tames wolf:
        - if !<player.has_flag[heracles.armor.quest_offered]>:
            - stop
        - if <player.flag[heracles.armor.stage].if_null[0]> != 1:
            - stop
        - if <player.has_flag[heracles.armor.stage1_complete]>:
            - stop
        - flag player heracles.armor.stage1_complete:true
        - flag player heracles.armor.stage:2
        - narrate "<&c><&l>Heracles<&r><&7>: <&o>The songs say I was fearless. The songs are wrong. I was afraid every single time..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&c><&l>[Heracles]<&r> <&f><player.name> <&7>has completed Stage 1 of the <&c>Rite of Investiture<&7>!"

        # Stage 2: Kill a ravager
        after player kills ravager:
        - if !<player.has_flag[heracles.armor.quest_offered]>:
            - stop
        - if <player.flag[heracles.armor.stage].if_null[0]> != 2:
            - stop
        - if <player.has_flag[heracles.armor.stage2_complete]>:
            - stop
        - flag player heracles.armor.stage2_complete:true
        - flag player heracles.armor.stage:3
        - adjust <player> revoke_advancement:minecraft:nether/return_to_sender
        - narrate "<&c><&l>Heracles<&r><&7>: <&o>My father is Zeus. Was Zeus. I don't know what he is now..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&c><&l>[Heracles]<&r> <&f><player.name> <&7>has completed Stage 2 of the <&c>Rite of Investiture<&7>!"

        # Stage 3: Kill a ghast with its own fireball
        # Bukkit doesn't expose reflected fireball shooter as player, but MC advancements do track it
        # So we revoke "Return to Sender" when stage 3 starts, then listen for re-completion
        after player completes advancement:
        - if !<context.advancement.ends_with[nether/return_to_sender]>:
            - stop
        - if !<player.has_flag[heracles.armor.quest_offered]>:
            - stop
        - if <player.flag[heracles.armor.stage].if_null[0]> != 3:
            - stop
        - if <player.has_flag[heracles.armor.stage3_complete]>:
            - stop
        - flag player heracles.armor.stage3_complete:true
        - narrate "<&c><&l>Heracles<&r><&7>: <&o>I stayed to fight. I was the last one on the mountain..."
        - playsound <player> sound:ui_toast_challenge_complete volume:0.8
        - announce "<&c><&l>[Heracles]<&r> <&f><player.name> <&7>has completed all stages of the <&c>Rite of Investiture<&7>!"

# ============================================
# QUEST HANDLER
# ============================================

heracles_armor_quest_handler:
    type: task
    debug: false
    script:
    - if <player.has_flag[heracles.armor.gifts_received]>:
        - define has_helm <player.inventory.contains_item[diamond_helmet].quantity[1]>
        - define has_chest <player.inventory.contains_item[diamond_chestplate].quantity[1]>
        - define has_legs <player.inventory.contains_item[diamond_leggings].quantity[1]>
        - define has_boots <player.inventory.contains_item[diamond_boots].quantity[1]>
        - define has_gifts <player.inventory.contains_item[heracles_divine_gift].quantity[1]>
        - if <[has_helm]> && <[has_chest]> && <[has_legs]> && <[has_boots]> && <[has_gifts]>:
            - run heracles_infusion_ceremony
        - else:
            - narrate "<&c><&l>Heracles<&r><&7>: You have my sigils, but you're not ready yet."
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
                - narrate "<&c>  ✗ <&7>Sigil of Heracles"
            - else:
                - narrate "<&a>  ✓ <&7>Sigil of Heracles"
            - playsound <player> sound:entity_iron_golem_hurt volume:0.3
            - inventory open d:heracles_info_gui
        - stop

    - if <player.has_flag[heracles.armor.stage3_complete]>:
        - run heracles_bestow_gifts
        - stop

    - if <player.has_flag[heracles.armor.quest_offered]>:
        - define stage <player.flag[heracles.armor.stage].if_null[1]>
        - choose <[stage]>:
            - case 1:
                - narrate "<&c><&l>Heracles<&r><&7>: <&o>There is a beast that answers to no one. It runs in packs, it bites without warning. Kneel before it with bone in hand, and see if it respects you."
            - case 2:
                - narrate "<&c><&l>Heracles<&r><&7>: <&o>A grey monster charges with the raiders. Horns like stone, hide like iron. Most run. You will not."
            - case 3:
                - adjust <player> revoke_advancement:minecraft:nether/return_to_sender
                - narrate "<&c><&l>Heracles<&r><&7>: <&o>In the burning lands, a creature weeps and spits fire. Catch its fury and send it back. Let it taste its own flame."
        - playsound <player> sound:entity_iron_golem_hurt volume:0.3
        - inventory open d:heracles_info_gui
        - stop

    - run heracles_offer_quest

heracles_offer_quest:
    type: task
    debug: false
    script:
    - narrate "<&c><&l>Heracles<&r><&7>: You earned the emblem. That means you can take a hit. Good."
    - wait 5s
    - narrate "<&c><&l>Heracles<&r><&7>: But earning and surviving are different things. I need to know you can fight what comes next. Things from the dark. Things that don't die easy."
    - wait 5s
    - narrate "<&c><&l>Heracles<&r><&7>: Complete my <&c>Rite of Investiture<&7>, and I'll give you armor that hits back. I will speak in riddles — a warrior who cannot think is already dead."
    - wait 5s
    - narrate "<&c><&l>Heracles<&r><&7>: <&o>There is a beast that answers to no one. It runs in packs, it bites without warning. Kneel before it with bone in hand, and see if it respects you."
    - playsound <player> sound:entity_ender_dragon_growl volume:0.3

    - flag player heracles.armor.quest_offered:true
    - flag player heracles.armor.stage:1

heracles_bestow_gifts:
    type: task
    debug: false
    script:
    - narrate "<&c><&l>Heracles<&r><&7>: Every trial. Every kill. You didn't stop."
    - wait 5s
    - narrate "<&c><&l>Heracles<&r><&7>: These sigils... I drew them after my twelfth labor. I thought I was done. I was wrong. But the marks remain."
    - wait 5s
    - narrate "<&c><&l>Heracles<&r><&7>: Take them. Bring diamond armor and come back. I'll show you what real strength looks like."
    - wait 4s

    - give heracles_divine_gift quantity:1
    - flag player heracles.armor.gifts_received:true

    - narrate "<&a>Received: <&c>Sigil of Heracles"
    - narrate "<&7>Bring a <&f>full diamond armor set<&7> and the <&c>Sigils<&7> to Heracles for the infusion."
    - playsound <player> sound:entity_ender_dragon_growl volume:0.3

heracles_infusion_ceremony:
    type: task
    debug: false
    script:
    - take diamond_helmet quantity:1
    - take diamond_chestplate quantity:1
    - take diamond_leggings quantity:1
    - take diamond_boots quantity:1
    - take heracles_divine_gift quantity:1

    - narrate "<&c><&l>Heracles<&r><&7>: Give it here. All of it."
    - playsound <player> sound:block_enchantment_table_use volume:1.0
    - wait 5s

    - narrate "<&c><&l>Heracles<&r><&7>: I'm putting everything I have into this. Every labor, every wound, every time I got up when I should have stayed down."
    - playsound <player> sound:block_beacon_activate volume:0.8
    - wait 5s

    - give heracles_divine_helm
    - give heracles_divine_chestplate
    - give heracles_divine_leggings
    - give heracles_divine_boots

    - flag player heracles.armor.crafted:true

    - title "title:<&c><&l>OLYMPIAN ARMOR FORGED" "subtitle:<&4>Heracles' Investiture" fade_in:10t stay:50t fade_out:10t
    - playeffect effect:flame at:<player.location> quantity:100 offset:2.0
    - playsound <player> sound:ui_toast_challenge_complete volume:1.0
    - playsound <player> sound:entity_ender_dragon_growl volume:0.5

    - wait 4s
    - narrate "<&c><&l>Heracles<&r><&7>: Wear it. Fight in it. And when the songs are about you — make sure they get the details right."

    - announce "<&c><&l>[Heracles]<&r> <&f><player.name> <&7>has received the <&c><&l>Olympian Armor of Heracles<&7>!"
    - playsound <server.online_players> sound:ui_toast_challenge_complete volume:0.5
