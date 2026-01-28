# ============================================
# EMBLEM SYSTEM V2 - CERES MECHANICS
# ============================================
#
# Special mechanics for Ceres items:
# - Ceres Hoe: Auto-replant crops when broken (consumes seeds)
# - Ceres Wand: Summon 6 angry bees that follow and attack hostiles
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
        - if <context.item.script.name.if_null[null]> != ceres_hoe:
            - stop

        # Get crop material and age
        - define material <context.location.material.name>
        - define age <context.location.material.age>

        # Check if fully grown (nether_wart max is 3, others are 7)
        - if <[material]> == nether_wart:
            - if <[age]> != 3:
                - stop
        - else:
            - if <[age]> != 7:
                - stop

        # Determine required seed item
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

        # Check if player has the required seed
        - if !<player.inventory.contains_item[<[seed_item]>]>:
            - stop

        # Take 1 seed from player
        - take <[seed_item]> qty:1

        # Replant after block break completes (age 0)
        - wait 1t
        - modifyblock <context.location> <[material]>[age=0]

        # Particle effect
        - playeffect effect:villager_happy at:<context.location> quantity:5 offset:0.3

# ============================================
# CERES WAND - BEE SUMMON
# ============================================

ceres_wand_use:
    type: world
    debug: false
    events:
        on player right clicks block with:ceres_wand:
        - determine cancelled passively

        # Check cooldown
        - if <player.has_flag[ceres.wand_cooldown]>:
            - define remaining <player.flag_expiration[ceres.wand_cooldown].from_now.formatted>
            - narrate "<&c>Wand on cooldown: <[remaining]>"
            - playsound <player> sound:entity_villager_no
            - stop

        # Set cooldown
        - flag player ceres.wand_cooldown expire:3m

        # Clear old bee list and start fresh
        - flag player ceres.wand_bees:!

        # Summon 6 bees
        - repeat 6:
            - define offset <location[0,0,0].random_offset[2,1,2]>
            - define spawn_loc <player.location.add[<[offset]>]>
            - spawn bee[angry=true] <[spawn_loc]> save:bee_<[value]>
            - define bee <entry[bee_<[value]>].spawned_entity>

            # Flag bee with persistent marker and temporary expiration
            - flag <[bee]> ceres.managed:true
            - flag <[bee]> ceres.temporary expire:20s
            - flag <[bee]> ceres.owner:<player.uuid> expire:20s

            # Add bee to player's bee list
            - flag player ceres.wand_bees:->:<[bee]> expire:20s

            # Target nearest hostile (if any)
            - define hostiles <[spawn_loc].find_entities[monster].within[16]>
            - if <[hostiles].size> > 0:
                - attack <[bee]> target:<[hostiles].random>

        # Feedback
        - narrate "<&e>Ceres' bees swarm to your defense!"
        - playsound <player> sound:entity_bee_loop_aggressive volume:1.0
        - playeffect effect:villager_happy at:<player.location> quantity:30 offset:2.0

# Redirect bees when player attacks a monster
ceres_bee_redirect:
    type: world
    debug: false
    events:
        after player damages entity:
        # Only redirect for monsters
        - if !<context.entity.entity_type.is_monster.if_null[false]>:
            - stop

        # Check if player has active bees
        - if !<player.has_flag[ceres.wand_bees]>:
            - stop

        # Loop through player's bees and command them to attack
        - foreach <player.flag[ceres.wand_bees]> as:bee:
            - if !<[bee].is_spawned.if_null[false]>:
                - foreach next
            - if !<[bee].has_flag[ceres.managed].if_null[false]>:
                - foreach next
            - if <[bee].flag[ceres.owner].if_null[null]> != <player.uuid>:
                - foreach next
            - attack <[bee]> target:<context.entity>

# Bee follow and cleanup loop
ceres_bee_management:
    type: world
    debug: false
    events:
        on system time secondly every:1:
        # Follow loop - keep bees near their owner
        - foreach <server.online_players> as:owner:
            - if !<[owner].has_flag[ceres.wand_bees]>:
                - foreach next
            - foreach <[owner].flag[ceres.wand_bees]> as:bee:
                - if !<[bee].is_spawned.if_null[false]>:
                    - foreach next
                - if !<[bee].has_flag[ceres.managed].if_null[false]>:
                    - foreach next
                - if <[bee].flag[ceres.owner].if_null[null]> != <[owner].uuid>:
                    - foreach next
                # Teleport bee if too far from owner
                - if <[bee].location.distance[<[owner].location>]> > 10:
                    - define offset <location[0,0,0].random_offset[2,1,2]>
                    - teleport <[bee]> <[owner].location.add[<[offset]>]>

        # Cleanup loop - remove bees whose temporary flag expired
        - define all_bees <server.worlds.parse[entities].combine.filter[entity_type.equals[bee]]>
        - foreach <[all_bees]> as:bee:
            - if <[bee].has_flag[ceres.managed].if_null[false]>:
                - if !<[bee].has_flag[ceres.temporary]>:
                    - remove <[bee]>

# ============================================
# CERES TITLE - CHAT PREFIX
# ============================================

ceres_title_chat:
    type: world
    debug: false
    events:
        on player chats:
        # Check if player has Ceres title unlocked
        - if !<player.has_flag[ceres.item.title]>:
            - stop

        # Cancel default chat and send custom
        - determine passively cancelled
        - announce "<&6>[Ceres' Chosen]<&r> <player.display_name><&7>: <context.message>"
