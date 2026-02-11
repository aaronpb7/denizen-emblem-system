# ============================================
# DATA MIGRATION - Role to Emblem System
# ============================================
#
# One-time migration that runs on player join
# Converts old role-based flags to new emblem-based flags
# Safe to re-run (checks emblem.migrated flag)
#

emblem_migration_handler:
    type: world
    debug: false
    events:
        on player joins:
        # Always recalculate emblem.rank from unlocked emblems
        - define rank 0
        - if <player.has_flag[demeter.emblem.unlocked]>:
            - define rank <[rank].add[1]>
        - if <player.has_flag[hephaestus.emblem.unlocked]>:
            - define rank <[rank].add[1]>
        - if <player.has_flag[heracles.emblem.unlocked]>:
            - define rank <[rank].add[1]>
        - flag player emblem.rank:<[rank]>

        # One-time: reset crafted item flags so players can use Mythic Crafting
        # Also cleans up removed item flags (hoe, sword, charm no longer exist)
        - if !<player.has_flag[emblem.crafting_migrated]>:
            # Clear craftable item flags (allow re-earning via Mythic Forge)
            - flag player ceres.item.wand:!
            - flag player mars.item.shield:!
            - flag player vulcan.item.pickaxe:!
            # Clear removed item flags (items no longer in the system)
            - flag player ceres.item.hoe:!
            - flag player mars.item.sword:!
            - flag player vulcan.item.charm:!
            - flag player emblem.crafting_migrated:true

        # One-time: remove base god title flags (titles now meta-crate only)
        - if !<player.has_flag[emblem.titles_migrated]>:
            - flag player demeter.item.title:!
            - flag player hephaestus.item.title:!
            - flag player heracles.item.title:!
            - if <player.has_flag[cosmetic.title.active]>:
                - define active <player.flag[cosmetic.title.active]>
                - if <[active]> == demeter || <[active]> == hephaestus || <[active]> == heracles:
                    - flag player cosmetic.title.active:!
            - flag player emblem.titles_migrated:true

        # Skip rest if already migrated
        - if <player.has_flag[emblem.migrated]>:
            - stop

        # Check if player has any old data to migrate
        - if !<player.has_flag[role.active]> && !<player.has_flag[role.changed_before]> && !<player.has_flag[farming.xp]> && !<player.has_flag[mining.xp]> && !<player.has_flag[heracles.xp]>:
            # No old data — mark as migrated and skip
            - flag player emblem.migrated:true
            - stop

        # === Step 1: Migrate role.active → emblem.active ===
        - if <player.has_flag[role.active]>:
            - define old_role <player.flag[role.active]>
            - choose <[old_role]>:
                - case FARMING:
                    - flag player emblem.active:DEMETER
                - case MINING:
                    - flag player emblem.active:HEPHAESTUS
                - case COMBAT:
                    - flag player emblem.active:HERACLES

        # === Step 2: Migrate role.changed_before → emblem.changed_before ===
        - if <player.has_flag[role.changed_before]>:
            - flag player emblem.changed_before:true

        # (Step 3 rank counting moved to Step 0 above)

        # === Step 3: Remove old flags ===
        - flag player role.active:!
        - flag player role.changed_before:!
        - flag player farming.xp:!
        - flag player farming.rank:!
        - flag player mining.xp:!
        - flag player mining.rank:!
        - flag player heracles.xp:!
        - flag player farming.next_emblem.unlocked:!
        - flag player combat.next_emblem.unlocked:!
        - flag player mining.next_emblem.unlocked:!

        # === Step 4: Mark as migrated ===
        - flag player emblem.migrated:true

        # Log
        - announce to_console "Emblem migration completed for player: <player.name>"
