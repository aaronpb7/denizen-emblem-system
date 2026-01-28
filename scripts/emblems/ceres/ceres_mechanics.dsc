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
        - if <context.item.script.name.if_null[null]> != ceres_hoe:
            - stop

        # Check if fully grown
        - define material <context.location.material.name>
        - define age <context.location.material.age>

        # Nether wart max age is 3, others are 7
        - if <[material]> == nether_wart:
            - if <[age]> != 3:
                - stop
        - else:
            - if <[age]> != 7:
                - stop

        # Replant after block break completes
        - wait 1t
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
        - flag player ceres.wand_cooldown expire:3m

        # Summon 6 bees
        - repeat 6:
            - define offset <location[0,0,0].random_offset[2,1,2]>
            - define spawn_loc <player.location.add[<[offset]>]>
            - spawn bee[angry=true] <[spawn_loc]> save:bee_<[value]>
            - define bee <entry[bee_<[value]>].spawned_entity>

            # Flag bee as temporary and link to player
            - flag <[bee]> ceres.temporary expire:20s
            - flag <[bee]> ceres.owner:<player.uuid>

            # Target nearest hostile (if any)
            - define hostiles <[spawn_loc].find_entities[monster].within[16].filter_tag[<[filter_value].entity_type.is_monster>]>
            - if <[hostiles].size> > 0:
                - attack <[bee]> target:<[hostiles].random>

        # Feedback
        - narrate "<&e>Ceres' bees swarm to your defense!"
        - playsound <player> sound:entity_bee_loop_aggressive volume:1.0
        - playeffect effect:villager_happy at:<player.location> quantity:30 offset:2.0

# Redirect bees when player attacks an entity
ceres_bee_redirect:
    type: world
    debug: false
    events:
        after player damages entity:
        # Don't target other players
        - if <context.entity.is_player.if_null[false]>:
            - stop

        # Find all bees owned by this player
        - define player_bees <player.location.find_entities[bee].within[32].filter[has_flag[ceres.owner]].filter[flag[ceres.owner].equals[<player.uuid>]]>
        - if <[player_bees].size> == 0:
            - stop

        # Redirect all bees to attack the damaged entity
        - foreach <[player_bees]> as:bee:
            - if <[bee].is_spawned.if_null[false]>:
                - attack <[bee]> target:<context.entity>

# Bee cleanup task
ceres_bee_cleanup:
    type: world
    debug: false
    events:
        # Despawn temporary bees after expiration
        on system time secondly every:1:
        - define all_bees <server.worlds.parse[entities].combine.filter_tag[<[filter_value].entity_type.equals[bee]>]>
        - foreach <[all_bees]>:
            - if <[value].has_flag[ceres.temporary]> && !<[value].has_flag_expiration[ceres.temporary]>:
                - remove <[value]>

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
