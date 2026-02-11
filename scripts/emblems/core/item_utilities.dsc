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
    debug: false
    definitions: player|item|quantity
    script:
    - inventory add d:<[player].inventory> o:<[item]> quantity:<[quantity]>

# Give items to player in context (shorthand)
# Usage: - run give_item def:<item>|<quantity>
give_item:
    type: task
    debug: false
    definitions: item|quantity
    script:
    - give <[item]> quantity:<[quantity]>

# ============================================
# GOD HEAD LIGHTNING - Placement Effect
# ============================================

god_head_placement:
    type: world
    debug: false
    events:
        after player places demeter_head|heracles_head|hephaestus_head:
        - flag <context.location> god_head:<context.item_in_hand.script.name>
        - strike <context.location>

        on player right clicks player_head:
        - if !<context.location.has_flag[god_head]>:
            - stop
        - define head_type <context.location.flag[god_head]>
        - flag <context.location> god_head:!
        - modifyblock <context.location> air
        - give <item[<[head_type]>]>
        - playsound <player> sound:entity_item_pickup volume:0.5
