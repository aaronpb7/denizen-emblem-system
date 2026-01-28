# ============================================
# CERES MECHANICS - Title System
# ============================================
#
# Special mechanics for Ceres items:
# - Ceres Hoe: Auto-replant crops when broken (consumes seeds)
# - Ceres Wand: Summon 6 angry bees that follow and attack
# - Ceres Title: Chat prefix for title holders
#

# ============================================
# CERES HOE - AUTO-REPLANT
# ============================================

ceres_hoe_replant:
    type: world
    debug: false
    events:
        after player breaks wheat|carrots|potatoes|beetroots|nether_wart:
        # Check if holding Ceres Hoe
        - if <player.item_in_hand.script.name.if_null[null]> != ceres_hoe:
            - stop

        # Get material and age from the broken block (context.material stores what was broken)
        - define material <context.material.name>
        - define age <context.material.age>

        # Check if fully grown (nether_wart max age is 3, others are 7)
        - if <[material]> == nether_wart:
            - if <[age]> != 3:
                - stop
        - else:
            - if <[age]> != 7:
                - stop

        # Determine which seed item is needed
        - choose <[material]>:
            - case wheat:
                - define seed_item wheat_seeds
            - case carrots:
                - define seed_item carrot
            - case potatoes:
                - define seed_item potato
            - case beetroots:
                - define seed_item beetroot_seeds
            - case nether_wart:
                - define seed_item nether_wart

        # Check if player has seeds in inventory
        - if !<player.inventory.contains_item[<[seed_item]>]>:
            - stop

        # Take 1 seed from inventory
        - take <[seed_item]> qty:1

        # Wait for block break to complete, then replant at age 0
        - wait 1t
        - modifyblock <context.location> <[material]>[age=0]

        # Particle effect
        - playeffect effect:VILLAGER_HAPPY at:<context.location> quantity:5 offset:0.3

# ============================================
# CERES WAND - BEE SUMMON
# ============================================

ceres_wand_use:
    type: world
    debug: false
    events:
        on player right clicks block with:ceres_wand:
        - determine cancelled passively
        - run ceres_wand_activate

        on player right clicks air with:ceres_wand:
        - determine cancelled passively
        - run ceres_wand_activate

ceres_wand_activate:
    type: task
    debug: false
    script:
        # Check cooldown
        - if <player.has_flag[ceres.wand_cooldown]>:
            - define remaining <player.flag_expiration[ceres.wand_cooldown].from_now.formatted>
            - narrate "<&c>Wand on cooldown: <[remaining]>"
            - playsound <player> sound:ENTITY_VILLAGER_NO
            - stop

        # Set cooldown
        - flag player ceres.wand_cooldown expire:30s

        # Clear previous bees list (old bees will be cleaned up by cleanup task)
        - flag player ceres.wand_bees:!

        # Summon 6 bees
        - repeat 6:
            - define offset <location[0,0,0].random_offset[2,1,2]>
            - define spawn_loc <player.location.add[<[offset]>]>
            - spawn bee[angry=true] <[spawn_loc]> save:spawned_bee
            - define bee <entry[spawned_bee].spawned_entity>

            # Flag bee with persistent marker and temporary expiry
            - flag <[bee]> ceres.managed:true
            - flag <[bee]> ceres.temporary:true expire:30s
            - flag <[bee]> ceres.owner:<player.uuid> expire:30s

            # Add to player's bee list
            - flag player ceres.wand_bees:->:<[bee]> expire:30s

        # Feedback
        - narrate "<&e>Ceres' bees swarm to your aid!"
        - playsound <player> sound:ENTITY_BEE_LOOP_AGGRESSIVE volume:1.0
        - playeffect effect:VILLAGER_HAPPY at:<player.location> quantity:30 offset:2.0

# Bees attack what their owner attacks
ceres_bee_attack_assist:
    type: world
    debug: false
    events:
        after player damages entity:
        # Only target monsters
        - if !<context.entity.is_monster>:
            - stop

        # Check if player has active bees
        - if !<player.has_flag[ceres.wand_bees]>:
            - stop

        # Command all valid bees to attack the target
        - foreach <player.flag[ceres.wand_bees]> as:bee:
            # Check bee is spawned, has managed flag, and owner matches
            - if !<[bee].is_spawned.if_null[false]>:
                - foreach next
            - if !<[bee].has_flag[ceres.managed]>:
                - foreach next
            - if <[bee].flag[ceres.owner].if_null[none]> != <player.uuid>:
                - foreach next
            # Command bee to attack
            - attack <[bee]> target:<context.entity>

# Prevent Ceres bees from targeting players
ceres_bee_no_player_target:
    type: world
    debug: false
    events:
        on bee targets player:
        - if <context.entity.has_flag[ceres.managed]>:
            - determine cancelled

# Bee follow and cleanup loop
ceres_bee_management:
    type: world
    debug: false
    events:
        on system time secondly every:1:
        # Follow logic - teleport distant bees to their owner
        - foreach <server.online_players> as:p:
            - if !<[p].has_flag[ceres.wand_bees]>:
                - foreach next
            - foreach <[p].flag[ceres.wand_bees]> as:bee:
                - if !<[bee].is_spawned.if_null[false]>:
                    - foreach next
                - if !<[bee].has_flag[ceres.managed]>:
                    - foreach next
                - if <[bee].flag[ceres.owner].if_null[none]> != <[p].uuid>:
                    - foreach next
                # Teleport if too far from owner
                - if <[bee].location.distance[<[p].location>]> > 10:
                    - define offset <location[0,0,0].random_offset[2,1,2]>
                    - teleport <[bee]> <[p].location.add[<[offset]>]>

        # Cleanup logic - remove expired bees
        - foreach <server.worlds> as:world:
            - foreach <[world].entities[bee]> as:bee:
                # Only manage our bees
                - if !<[bee].has_flag[ceres.managed]>:
                    - foreach next
                # If managed but temporary flag expired, remove the bee
                - if !<[bee].has_flag[ceres.temporary]>:
                    - remove <[bee]>

# ============================================
# CERES TITLE - CHAT PREFIX
# ============================================

title_chat_handler:
    type: world
    debug: false
    events:
        on player chats:
        # Check if player has any title active
        - if !<player.has_flag[cosmetic.title.active]>:
            - stop

        - define active_title <player.flag[cosmetic.title.active]>

        # Apply the appropriate title prefix
        - determine passively cancelled
        - choose <[active_title]>:
            - case ceres:
                - announce "<&6>[Ceres' Chosen]<&r> <player.display_name><&7>: <context.message>"
            - case demeter:
                - announce "<&6>[Harvest Queen]<&r> <player.display_name><&7>: <context.message>"
            - case heracles:
                - announce "<&c>[The Unconquered]<&r> <player.display_name><&7>: <context.message>"
