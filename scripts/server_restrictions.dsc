# Server Restrictions
# Global gameplay restrictions

# ==================== NETHERITE BAN ====================
# Prevents upgrading diamond gear to netherite via smithing table

netherite_restriction:
    type: world
    debug: false
    events:
        on player smiths item:
        # Check if result is a netherite item
        - if <context.result.material.name.contains[netherite]>:
            - narrate "<&c>Netherite upgrades are disabled on this server."
            - playsound <player> sound:entity_villager_no
            - determine cancelled
