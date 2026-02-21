# Server Restrictions
# Global gameplay restrictions

# ==================== NETHERITE BAN ====================
# Prevents upgrading diamond gear to netherite via smithing table

netherite_restriction:
    type: world
    debug: false
    events:
        on player smiths netherite_*:
            - narrate "<&c>Netherite upgrades are disabled on this server."
            - playsound <player> sound:entity_villager_no
            - determine cancelled
