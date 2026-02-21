# ============================================
# EMBLEM SYSTEM
# ============================================
#
# Core emblem data and procedures for the emblem system
#
# Tier 1 Emblems:
# - DEMETER → Goddess of Harvest
# - HEPHAESTUS → God of the Forge
# - HERACLES → Hero of Strength
#
# Tier 2 Emblems:
# - TRITON → God of the Sea (requires 2 Tier 1 completions)
# - CHARON → Ferryman of the Dead (requires 2 Tier 1 completions)
#
# Tier system gates future content:
# - Tier 1: Available immediately
# - Tier 2: Requires 2 Tier 1 emblem completions
#

# ============================================
# EMBLEM DATA CONTAINER
# ============================================

emblem_data:
    type: data
    # Valid emblem identifiers
    emblems:
        - DEMETER
        - HEPHAESTUS
        - HERACLES
        - TRITON
        - CHARON

    # Tier assignments
    tiers:
        DEMETER: 1
        HEPHAESTUS: 1
        HERACLES: 1
        TRITON: 2
        CHARON: 2

    # Tier requirements (number of completed emblems from previous tier)
    tier_requirements:
        1: 0
        2: 2

    # Display names (god names)
    display_names:
        DEMETER: Demeter
        HEPHAESTUS: Hephaestus
        HERACLES: Heracles
        TRITON: Triton
        CHARON: Charon

    # Emblem colors
    colors:
        DEMETER: <&6>
        HEPHAESTUS: <&8>
        HERACLES: <&4>
        TRITON: <&3>
        CHARON: <&5>

    # Emblem icons (materials for GUI)
    icons:
        DEMETER: golden_hoe
        HEPHAESTUS: iron_pickaxe
        HERACLES: diamond_sword
        TRITON: trident
        CHARON: soul_lantern

# ============================================
# PROCEDURES
# ============================================

# Get display name for emblem (god name)
# Usage: <proc[get_emblem_display_name].context[DEMETER]>
# Returns: "Demeter"
get_emblem_display_name:
    type: procedure
    debug: false
    definitions: emblem
    script:
    - determine <script[emblem_data].data_key[display_names.<[emblem]>]>

# Get god name for emblem
# Usage: <proc[get_god_for_emblem].context[DEMETER]>
# Returns: "Demeter"
get_god_for_emblem:
    type: procedure
    debug: false
    definitions: emblem
    script:
    - determine <script[emblem_data].data_key[display_names.<[emblem]>]>

# Get emblem color
# Usage: <proc[get_emblem_color].context[DEMETER]>
# Returns: "<&6>"
get_emblem_color:
    type: procedure
    debug: false
    definitions: emblem
    script:
    - determine <script[emblem_data].data_key[colors.<[emblem]>]>

# Get emblem icon material
# Usage: <proc[get_emblem_icon].context[DEMETER]>
# Returns: "golden_hoe"
get_emblem_icon:
    type: procedure
    debug: false
    definitions: emblem
    script:
    - determine <script[emblem_data].data_key[icons.<[emblem]>]>

# Check if player has an emblem set
# Usage: <proc[player_has_emblem].context[<player>]>
# Returns: true/false
player_has_emblem:
    type: procedure
    debug: false
    definitions: player
    script:
    - if <[player].has_flag[emblem.active]>:
        - determine true
    - determine false

# Get player's current emblem
# Usage: <proc[get_player_emblem].context[<player>]>
# Returns: "DEMETER", "HEPHAESTUS", "HERACLES", or null if no emblem
get_player_emblem:
    type: procedure
    debug: false
    definitions: player
    script:
    - determine <[player].flag[emblem.active]>

# Validate emblem string
# Usage: <proc[is_valid_emblem].context[DEMETER]>
# Returns: true/false
is_valid_emblem:
    type: procedure
    debug: false
    definitions: emblem
    script:
    - determine <script[emblem_data].data_key[emblems].contains[<[emblem]>]>

# Get tier number for an emblem
# Usage: <proc[get_emblem_tier].context[DEMETER]>
# Returns: 1
get_emblem_tier:
    type: procedure
    debug: false
    definitions: emblem
    script:
    - determine <script[emblem_data].data_key[tiers.<[emblem]>]>

# Count how many emblems a player has unlocked in a given tier
# Usage: <proc[count_completed_tier_emblems].context[<player>|1]>
# Returns: integer
count_completed_tier_emblems:
    type: procedure
    debug: false
    definitions: player|tier
    script:
    - define count 0
    - foreach <script[emblem_data].data_key[emblems]> as:emb:
        - if <script[emblem_data].data_key[tiers.<[emb]>]> == <[tier]>:
            - define god <script[emblem_data].data_key[display_names.<[emb]>].to_lowercase>
            - if <[player].has_flag[<[god]>.emblem.unlocked]>:
                - define count <[count].add[1]>
    - determine <[count]>

# Check if player can access a given tier
# Usage: <proc[can_access_tier].context[<player>|2]>
# Returns: true/false
can_access_tier:
    type: procedure
    debug: false
    definitions: player|tier
    script:
    - if <[tier]> <= 1:
        - determine true
    - define required_tier <[tier].sub[1]>
    - define required_count <script[emblem_data].data_key[tier_requirements.<[tier]>]>
    - define completed <proc[count_completed_tier_emblems].context[<[player]>|<[required_tier]>]>
    - if <[completed]> >= <[required_count]>:
        - determine true
    - determine false

# Get player's emblem rank (increments each time an emblem is unlocked)
# Usage: <proc[get_player_emblem_rank].context[<player>]>
# Returns: integer
get_player_emblem_rank:
    type: procedure
    debug: false
    definitions: player
    script:
    - determine <[player].flag[emblem.rank].if_null[0]>

# ============================================
# SET PLAYER EMBLEM
# ============================================
# Shared task called by all god NPCs to set the player's active emblem
# Uses neutral messages — each god's NPC handles its own dialogue context

set_player_emblem:
    type: task
    debug: false
    definitions: emblem
    script:
    # Check if already active
    - if <player.flag[emblem.active].if_null[NONE]> == <[emblem]>:
        - inventory close
        - define display <proc[get_emblem_display_name].context[<[emblem]>]>
        - narrate "<&7>You are already pursuing <&e><[display]><&7>'s emblem."
        - playsound <player> sound:entity_villager_no
        - stop

    # Set new emblem
    - flag player emblem.active:<[emblem]>
    - inventory close

    # Confirmation message
    - define display <proc[get_emblem_display_name].context[<[emblem]>]>

    - if <player.has_flag[emblem.changed_before]>:
        - narrate "<&7>You have switched to <&e><[display]><&7>'s emblem. Your previous progress is preserved."
    - else:
        - narrate "<&7>You have accepted <&e><[display]><&7>'s emblem. Your journey begins."
        - flag player emblem.changed_before:true

    - playsound <player> sound:block_enchantment_table_use

# ============================================
# DIVINE ARMOR CHECK
# ============================================
# Check if player is wearing full divine armor set for a god
# Usage: <proc[is_wearing_divine_armor].context[<player>|demeter]>
# Returns: true/false

is_wearing_divine_armor:
    type: procedure
    debug: false
    definitions: player|god
    script:
    - if <[player].equipment_map.get[helmet].script.name.if_null[null]> != <[god]>_divine_helm:
        - determine false
    - if <[player].equipment_map.get[chestplate].script.name.if_null[null]> != <[god]>_divine_chestplate:
        - determine false
    - if <[player].equipment_map.get[leggings].script.name.if_null[null]> != <[god]>_divine_leggings:
        - determine false
    - if <[player].equipment_map.get[boots].script.name.if_null[null]> != <[god]>_divine_boots:
        - determine false
    - determine true

# ============================================
# DIVINE ARMOR TRIM HANDLER
# ============================================
# Allows players to apply armor trims to divine armor
# at a smithing table without losing custom item data.

divine_armor_trim_handler:
    type: world
    debug: false
    events:
        on player prepares smithing item:
        - inject divine_armor_trim_check

        on player smiths item:
        - inject divine_armor_trim_check

divine_armor_trim_check:
    type: task
    debug: false
    script:
    - define divine_items <list[demeter_divine_helm|demeter_divine_chestplate|demeter_divine_leggings|demeter_divine_boots|hephaestus_divine_helm|hephaestus_divine_chestplate|hephaestus_divine_leggings|hephaestus_divine_boots|heracles_divine_helm|heracles_divine_chestplate|heracles_divine_leggings|heracles_divine_boots|triton_divine_helm|triton_divine_chestplate|triton_divine_leggings|triton_divine_boots|charon_divine_helm|charon_divine_chestplate|charon_divine_leggings|charon_divine_boots]>
    # Find divine armor in smithing table
    - define base_script null
    - foreach <list[1|2|3]> as:slot_num:
        - define slot_item <context.inventory.slot[<[slot_num]>]>
        - define sname <[slot_item].script.name.if_null[null]>
        - if <[sname]> != null && <[divine_items].contains[<[sname]>]>:
            - define base_script <[sname]>
    - if <[base_script]> == null:
        - stop
    # If vanilla produced a result with trim data, copy it onto our scripted item
    - define result <context.item>
    - if <[result].material.name> != AIR:
        - define trim_data <[result].trim.if_null[null]>
        - if <[trim_data]> != null:
            - determine <item[<[base_script]>].with[trim=<[trim_data]>]>
    # Fallback: manually construct trim from template + material slots
    - define template <context.inventory.slot[1]>
    - define material <context.inventory.slot[3]>
    - if <[template].material.name> == AIR || <[material].material.name> == AIR:
        - stop
    - define tname <[template].material.name>
    - if !<[tname].contains_text[ARMOR_TRIM]>:
        - stop
    - define pattern <[tname].before[_ARMOR_TRIM_SMITHING_TEMPLATE].to_lowercase>
    - define trim_materials <map[IRON_INGOT=iron|COPPER_INGOT=copper|GOLD_INGOT=gold|DIAMOND=diamond|EMERALD=emerald|LAPIS_LAZULI=lapis|NETHERITE_INGOT=netherite|REDSTONE=redstone|AMETHYST_SHARD=amethyst|QUARTZ=quartz]>
    - define trim_mat <[trim_materials].get[<[material].material.name>].if_null[null]>
    - if <[trim_mat]> == null:
        - stop
    - determine <item[<[base_script]>].with[trim=<map[pattern=<[pattern]>;material=<[trim_mat]>]>]>

# ============================================
# DIVINE ARMOR SET EFFECTS
# ============================================
# Ambient particle effects while wearing a full divine armor set:
# - Demeter: Green sparkles (happy_villager)
# - Hephaestus: Forge embers (flame)
# - Heracles: Combat sparks (crit)
# - Triton: Water bubbles (bubble_pop)
# - Charon: Soul fire (soul_fire_flame)

divine_armor_set_effects:
    type: world
    debug: false
    events:
        on system time secondly every:2:
        - foreach <server.online_players> as:p:
            - if <proc[is_wearing_divine_armor].context[<[p]>|demeter]>:
                - playeffect effect:happy_villager at:<[p].location> quantity:8 offset:0.6
            - else if <proc[is_wearing_divine_armor].context[<[p]>|hephaestus]>:
                - playeffect effect:flame at:<[p].location> quantity:8 offset:0.6
            - else if <proc[is_wearing_divine_armor].context[<[p]>|heracles]>:
                - playeffect effect:crit at:<[p].location> quantity:8 offset:0.6
            - else if <proc[is_wearing_divine_armor].context[<[p]>|triton]>:
                - playeffect effect:bubble_pop at:<[p].location> quantity:8 offset:0.6
            - else if <proc[is_wearing_divine_armor].context[<[p]>|charon]>:
                - playeffect effect:soul_fire_flame at:<[p].location> quantity:8 offset:0.6
