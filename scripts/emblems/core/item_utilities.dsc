# ============================================
# ITEM UTILITIES - REUSABLE TASKS
# ============================================
#
# Reusable helper tasks for giving items to players
#

# Give items to any player (context or definition)
# Usage: - run give_item_to_player def:<player>|<item>|<quantity>
give_item_to_player:
    type: task
    definitions: player|item|quantity
    script:
    - inventory add d:<[player].inventory> o:<[item]> quantity:<[quantity]>

# Give items to player in context (shorthand)
# Usage: - run give_item def:<item>|<quantity>
give_item:
    type: task
    definitions: item|quantity
    script:
    - give <[item]> quantity:<[quantity]>
