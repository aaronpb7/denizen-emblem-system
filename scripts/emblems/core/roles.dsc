# ============================================
# ROLE SYSTEM
# ============================================
#
# Core role data and procedures for the emblem system
#
# Roles:
# - FARMING (Georgos) → Demeter progression
# - MINING (Metallourgos) → Hephaestus progression (TBD)
# - COMBAT (Hoplites) → Heracles progression (TBD)
#

# ============================================
# ROLE DATA CONTAINER
# ============================================

role_data:
    type: data
    # Valid role identifiers
    roles:
        - FARMING
        - MINING
        - COMBAT

    # Greek display names
    greek_names:
        FARMING: Georgos
        MINING: Metallourgos
        COMBAT: Hoplites

    # Associated gods
    gods:
        FARMING: Demeter
        MINING: Hephaestus
        COMBAT: Heracles

    # Role colors
    colors:
        FARMING: <&6>
        MINING: <&c>
        COMBAT: <&4>

    # Role icons (materials for GUI)
    icons:
        FARMING: golden_hoe
        MINING: diamond_pickaxe
        COMBAT: diamond_sword

# ============================================
# PROCEDURES
# ============================================

# Get Greek display name for role
# Usage: <proc[get_role_display_name].context[FARMING]>
# Returns: "Georgos"
get_role_display_name:
    type: procedure
    debug: false
    definitions: role
    script:
    - determine <script[role_data].data_key[greek_names.<[role]>]>

# Get god name for role
# Usage: <proc[get_god_for_role].context[FARMING]>
# Returns: "Demeter"
get_god_for_role:
    type: procedure
    debug: false
    definitions: role
    script:
    - determine <script[role_data].data_key[gods.<[role]>]>

# Get role color
# Usage: <proc[get_role_color].context[FARMING]>
# Returns: "<&6>"
get_role_color:
    type: procedure
    debug: false
    definitions: role
    script:
    - determine <script[role_data].data_key[colors.<[role]>]>

# Get role icon material
# Usage: <proc[get_role_icon].context[FARMING]>
# Returns: "golden_hoe"
get_role_icon:
    type: procedure
    debug: false
    definitions: role
    script:
    - determine <script[role_data].data_key[icons.<[role]>]>

# Check if player has a role set
# Usage: <proc[player_has_role].context[<player>]>
# Returns: true/false
player_has_role:
    type: procedure
    debug: false
    definitions: player
    script:
    - if <[player].has_flag[role.active]>:
        - determine true
    - determine false

# Get player's current role
# Usage: <proc[get_player_role].context[<player>]>
# Returns: "FARMING", "MINING", "COMBAT", or null if no role
get_player_role:
    type: procedure
    debug: false
    definitions: player
    script:
    - determine <[player].flag[role.active]>

# Validate role string
# Usage: <proc[is_valid_role].context[FARMING]>
# Returns: true/false
is_valid_role:
    type: procedure
    debug: false
    definitions: role
    script:
    - determine <script[role_data].data_key[roles].contains[<[role]>]>
