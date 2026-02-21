# ============================================
# DIS MECHANICS
# ============================================
#
# Passive effects and mechanics for Dis meta items:
# - Fire Charm: Grants fire resistance while in inventory
#

# ============================================
# DIS FIRE CHARM - PASSIVE FIRE IMMUNITY
# ============================================

dis_fire_charm_effect:
    type: world
    debug: false
    events:
        on system time secondly every:1:
        - foreach <server.online_players> as:p:
            - if <[p].inventory.contains_item[dis_fire_charm]>:
                - cast fire_resistance duration:3s player:<[p]>
                - playeffect effect:soul_fire_flame at:<[p].location> quantity:3 offset:0.3

# ============================================
# DIS TITLE - CHAT PREFIX
# ============================================
# Handled in ceres_mechanics.dsc title_chat_handler (case dis)
