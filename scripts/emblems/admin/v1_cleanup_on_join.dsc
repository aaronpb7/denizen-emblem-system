# ============================================
# V1 FLAG CLEANUP - ONE-TIME ON JOIN
# ============================================
#
# Automatically wipes all V1 emblem flags when players join
# Self-disables after cleanup is complete
#
# To re-enable: /ex flag server v1.cleanup_complete:!
#

v1_flag_cleanup_on_join:
    type: world
    debug: false
    events:
        on player joins:
        # Check if global cleanup already complete
        - if <server.has_flag[v1.cleanup_complete]>:
            - stop

        # Check if this player already cleaned
        - if <player.has_flag[v1.cleanup_done]>:
            - stop

        # Wait 2 seconds for player to fully load
        - wait 2s

        # Wipe all old V1 emblem flags
        - flag player emblem:!

        # Mark this player as cleaned
        - flag player v1.cleanup_done:true

        # Notify player
        - narrate "<&e>[System]<&r> <&7>Welcome! Your emblem progress has been reset for the new V2 system."
        - narrate "<&7>Speak to <&e>Promachos<&7> to begin your journey!"

        # Log to console
        - announce to_console "V1 flags wiped for player: <player.name>"

# Manual command to mark cleanup complete server-wide
# Run this after all players have joined at least once
v1_cleanup_complete_command:
    type: command
    name: v1cleanupcomplete
    description: Marks V1 cleanup as complete server-wide
    usage: /v1cleanupcomplete
    permission: emblems.admin
    script:
    - flag server v1.cleanup_complete:true
    - narrate "<&a>V1 cleanup marked as complete server-wide. No more automatic cleanups will run."
    - announce to_console "V1 cleanup marked complete by <player.name>"

# Manual command to wipe V1 flags for a specific player
v1_cleanup_player_command:
    type: command
    name: v1cleanup
    description: Manually wipe V1 flags for a player
    usage: /v1cleanup (player)
    permission: emblems.admin
    script:
    - if <context.args.size> < 1:
        - narrate "<&c>Usage: /v1cleanup <player>"
        - stop

    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> == null:
        - narrate "<&c>Player not found: <context.args.get[1]>"
        - stop

    # Wipe emblem flags
    - flag <[target]> emblem:!

    # Mark as cleaned
    - flag <[target]> v1.cleanup_done:true

    - narrate "<&a>Wiped V1 emblem flags for <[target].name>"
    - narrate "<&e>[System]<&r> <&7>Your emblem progress has been reset for V2." targets:<[target]>
