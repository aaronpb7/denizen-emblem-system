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

    # Tier assignments
    tiers:
        DEMETER: 1
        HEPHAESTUS: 1
        HERACLES: 1
        TRITON: 2

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

    # Emblem colors
    colors:
        DEMETER: <&6>
        HEPHAESTUS: <&8>
        HERACLES: <&4>
        TRITON: <&3>

    # Emblem icons (materials for GUI)
    icons:
        DEMETER: golden_hoe
        HEPHAESTUS: iron_pickaxe
        HERACLES: diamond_sword
        TRITON: trident

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
