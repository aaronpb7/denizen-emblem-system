# ============================================
# EMBLEM SYSTEM V2 - CERES MECHANICS
# ============================================
#
# Special mechanics for Ceres items:
# - Ceres Hoe: Auto-replant crops when broken
# - Ceres Wand: Summon 6 angry bees to attack hostiles
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

        # Check if fully grown
        - define material <context.material.name>
        - define age <context.material.age>

        # Nether wart max age is 3, others are 7
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

        # Replant after block break completes
        - wait 1t

        # Take 1 seed from inventory and replant
        - take <[seed_item]> quantity:1 from:<player.inventory>
        - modifyblock <context.location> <[material]>

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
        - flag player ceres.wand_cooldown expire:30s

        # Despawn previous bees before spawning new ones
        - if <player.has_flag[ceres.active_bees]>:
            - foreach <player.flag[ceres.active_bees]> as:old_bee:
                - if <[old_bee].is_spawned.if_null[false]>:
                    - remove <[old_bee]>
            - flag player ceres.active_bees:!

        # Get target - prioritize what player is looking at or attacking
        - define target <player.target_entity.if_null[null]>
        # Only target mobs, never players
        - if <[target]> != null:
            - if <[target].is_player>:
                - define target null
            - else if !<[target].is_living>:
                - define target null

        # If no direct target, find nearest hostile mob (not players)
        - if <[target]> == null:
            - define hostiles <player.location.find_entities.within[16].filter_tag[<[filter_value].is_monster>]>
            - if <[hostiles].size> > 0:
                - define target <[hostiles].closest_to[<player.location>]>

        # Track spawned bees
        - define bee_list <list[]>

        # Summon 6 bees
        - repeat 6:
            - define offset <location[0,0,0].random_offset[2,1,2]>
            - define spawn_loc <player.location.add[<[offset]>]>
            - spawn bee[angry=true] <[spawn_loc]> save:bee_<[value]>
            - define bee <entry[bee_<[value]>].spawned_entity>

            # Flag bee as belonging to this player
            - flag <[bee]> ceres.owner:<player>
            - flag <[bee]> ceres.temporary expire:30s

            # Add to tracking list
            - define bee_list:->:<[bee]>

            # Attack target if we have one
            - if <[target]> != null:
                - attack <[bee]> target:<[target]>

        # Store active bees on player
        - flag player ceres.active_bees:<[bee_list]>

        # Feedback
        - if <[target]> != null:
            - narrate "<&e>Ceres' bees swarm to attack!"
        - else:
            - narrate "<&e>Ceres' bees await your command!"
        - playsound <player> sound:entity_bee_loop_aggressive volume:1.0
        - playeffect effect:villager_happy at:<player.location> quantity:30 offset:2.0

# Prevent Ceres bees from targeting players
ceres_bee_no_player_target:
    type: world
    debug: false
    events:
        on bee targets player:
        - if <context.entity.has_flag[ceres.owner]>:
            - determine cancelled

# Make bees attack what their owner attacks
ceres_bee_assist:
    type: world
    debug: false
    events:
        on player damages entity:
        # Check if player has active bees
        - if !<player.has_flag[ceres.active_bees]>:
            - stop
        # Don't target players
        - if <context.entity.is_player>:
            - stop
        # Don't target non-living entities
        - if !<context.entity.is_living>:
            - stop
        # Direct all bees to attack the target
        - foreach <player.flag[ceres.active_bees]> as:bee:
            - if <[bee].is_spawned.if_null[false]>:
                - attack <[bee]> target:<context.entity>

# Bee cleanup - despawn expired bees
ceres_bee_cleanup:
    type: world
    debug: false
    events:
        on system time secondly every:5:
        - foreach <server.online_players> as:p:
            - if <[p].has_flag[ceres.active_bees]>:
                - define valid_bees <list[]>
                - foreach <[p].flag[ceres.active_bees]> as:bee:
                    - if <[bee].is_spawned.if_null[false]> && <[bee].has_flag[ceres.temporary]>:
                        - define valid_bees:->:<[bee]>
                    - else if <[bee].is_spawned.if_null[false]>:
                        - remove <[bee]>
                - flag <[p]> ceres.active_bees:<[valid_bees]>

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
