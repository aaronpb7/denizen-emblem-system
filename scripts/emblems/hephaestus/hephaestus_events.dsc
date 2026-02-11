# ============================================
# HEPHAESTUS EVENTS - Activity Tracking
# ============================================
#
# Activity tracking for component milestones
# 1. Iron ore mining → component at 5,000
# 2. Blast furnace smelting → component at 5,000
# 3. Iron golem creation → component at 100
#
# Only tracks when player emblem = HEPHAESTUS
#

# ============================================
# ORE MINING
# ============================================

mining_ore_break:
    type: world
    debug: false
    events:
        after player breaks coal_ore|deepslate_coal_ore|copper_ore|deepslate_copper_ore|iron_ore|deepslate_iron_ore|gold_ore|deepslate_gold_ore|nether_gold_ore|lapis_ore|deepslate_lapis_ore|redstone_ore|deepslate_redstone_ore|diamond_ore|deepslate_diamond_ore|emerald_ore|deepslate_emerald_ore|nether_quartz_ore|ancient_debris:
        # Emblem gate - only HEPHAESTUS emblem counts
        - if <player.flag[emblem.active].if_null[NONE]> != HEPHAESTUS:
            - stop

        # Get ore type (normalize deepslate variants)
        - define ore <context.material.name>
        - define ore_base <[ore].replace[deepslate_].with[]>

        # Track iron ore specifically for component milestone
        - if <[ore_base]> == iron_ore:
            - flag player hephaestus.iron.count:++
            - define count <player.flag[hephaestus.iron.count]>

            # Key award logic (every 50)
            - define keys_awarded <player.flag[hephaestus.iron.keys_awarded].if_null[0]>
            - define keys_should_have <[count].div[50].round_down>
            - if <[keys_should_have]> > <[keys_awarded]>:
                - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
                - give hephaestus_key quantity:<[keys_to_give]>
                - flag player hephaestus.iron.keys_awarded:<[keys_should_have]>
                - narrate "<&8><&l>HEPHAESTUS KEY!<&r> <&7>Iron Ore: <&f><[count]><&7>/5,000"
                - playsound <player> sound:entity_experience_orb_pickup

            # Check for component milestone (5,000)
            - if <[count]> >= 5000 && !<player.has_flag[hephaestus.component.iron]>:
                - flag player hephaestus.component.iron:true
                - flag player hephaestus.component.iron_date:<util.time_now.format>
                - narrate "<&8><&l>MILESTONE!<&r> <&f>Iron Component obtained! <&8>(5,000 iron ore)"
                - playsound <player> sound:ui_toast_challenge_complete
                - announce "<&e>[Promachos]<&r> <&f><player.name> <&8>has obtained the <&7>Iron Component<&8>!"

# ============================================
# BLAST FURNACE SMELTING
# ============================================

mining_blast_furnace_smelt:
    type: world
    debug: false
    events:
        after player takes item from furnace:
        # Only count blast furnace, not regular furnace
        - if <context.location.material.name> != blast_furnace:
            - stop

        # Emblem gate - only HEPHAESTUS emblem counts
        - if <player.flag[emblem.active].if_null[NONE]> != HEPHAESTUS:
            - stop

        # Get amount taken
        - define amount <context.item.quantity>

        # Track smelts for component milestone
        - flag player hephaestus.smelting.count:+:<[amount]>
        - define count <player.flag[hephaestus.smelting.count]>

        # Key award logic (every 50)
        - define keys_awarded <player.flag[hephaestus.smelting.keys_awarded].if_null[0]>
        - define keys_should_have <[count].div[50].round_down>
        - if <[keys_should_have]> > <[keys_awarded]>:
            - define keys_to_give <[keys_should_have].sub[<[keys_awarded]>]>
            - give hephaestus_key quantity:<[keys_to_give]>
            - flag player hephaestus.smelting.keys_awarded:<[keys_should_have]>
            - narrate "<&8><&l>HEPHAESTUS KEY!<&r> <&7>Smelting: <&f><[count]><&7>/5,000"
            - playsound <player> sound:entity_experience_orb_pickup

        # Check for component milestone (5,000)
        - if <[count]> >= 5000 && !<player.has_flag[hephaestus.component.smelting]>:
            - flag player hephaestus.component.smelting:true
            - flag player hephaestus.component.smelting_date:<util.time_now.format>
            - narrate "<&8><&l>MILESTONE!<&r> <&f>Smelting Component obtained! <&8>(5,000 smelts)"
            - playsound <player> sound:ui_toast_challenge_complete
            - announce "<&e>[Promachos]<&r> <&f><player.name> <&8>has obtained the <&7>Smelting Component<&8>!"

# ============================================
# IRON GOLEM CREATION
# ============================================

mining_golem_creation:
    type: world
    debug: false
    events:
        after iron_golem spawns because BUILD_IRONGOLEM:
        # Find nearest player who likely built it (within 5 blocks)
        - define builder <context.entity.location.find_players_within[5].first.if_null[null]>
        - if <[builder]> == null:
            - stop

        # Emblem gate - only HEPHAESTUS emblem counts
        - if <[builder].flag[emblem.active].if_null[NONE]> != HEPHAESTUS:
            - stop

        # Track golems for component milestone
        - flag <[builder]> hephaestus.golems.count:++
        - define count <[builder].flag[hephaestus.golems.count]>

        # Key award logic (every 1 golem = 1 key)
        - define keys_awarded <[builder].flag[hephaestus.golems.keys_awarded].if_null[0]>
        - if <[count]> > <[keys_awarded]>:
            - give hephaestus_key quantity:1 player:<[builder]>
            - flag <[builder]> hephaestus.golems.keys_awarded:<[count]>
            - narrate "<&8><&l>HEPHAESTUS KEY!<&r> <&7>Golems: <&f><[count]><&7>/100" targets:<[builder]>
            - playsound <[builder]> sound:entity_experience_orb_pickup

        # Check for component milestone (100)
        - if <[count]> >= 100 && !<[builder].has_flag[hephaestus.component.golem]>:
            - flag <[builder]> hephaestus.component.golem:true
            - flag <[builder]> hephaestus.component.golem_date:<util.time_now.format>
            - narrate "<&8><&l>MILESTONE!<&r> <&f>Golem Component obtained! <&8>(100 golems)" targets:<[builder]>
            - playsound <[builder]> sound:ui_toast_challenge_complete
            - announce "<&e>[Promachos]<&r> <&f><[builder].name> <&8>has obtained the <&7>Golem Component<&8>!"

