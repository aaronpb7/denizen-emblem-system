# Promachos NPC - Complete Specification

## Purpose

**Promachos** (Προμαχός) means "champion" or "defender who fights in the front line."

In V2, Promachos is the **system anchor** and **ceremony master**:
- Introduces the emblem system on first meeting
- Forces emblem selection (cannot proceed without choosing)
- Allows emblem switching at any time
- Checks component completion and unlocks emblems
- Congratulates players on emblem unlocks
- Gates the next emblem line in each emblem path

**No longer a trader.** All trading removed in V2.

---

## NPC Details

- **NPC ID**: `0` (existing)
- **Location**: (server-specific, not hardcoded)
- **Name**: Promachos
- **Type**: Human villager or player NPC
- **Skin**: Warrior/champion themed

---

## Interaction Flow

### First Interaction (New Player)

**Trigger**: Player right-clicks Promachos, `met_promachos` flag is false or absent

**Dialogue Sequence** (5 parts, 3s delay between):

1. **Introduction**
   ```
   <&e><&l>Promachos<&r><&7>: Greetings, <player.name>. I am Promachos, Herald of the Gods.
   ```

2. **Purpose**
   ```
   <&e><&l>Promachos<&r><&7>: The Olympians watch your deeds. Through your labors, you may earn their favor—and their gifts.
   ```

3. **Emblems Explained**
   ```
   <&e><&l>Promachos<&r><&7>: You must choose an emblem to pursue: <&6>Demeter<&7> (farming), <&6>Hephaestus<&7> (mining), or <&6>Heracles<&7> (combat). Only one emblem may be pursued at a time.
   ```

4. **Components Explained**
   ```
   <&e><&l>Promachos<&r><&7>: Each emblem requires divine components—symbols of mastery. Collect components through your labors, and I shall unlock the emblem when you are ready.
   ```

5. **Call to Action**
   ```
   <&e><&l>Promachos<&r><&7>: Choose wisely. Your journey begins now.
   ```

**After dialogue**:
- Flag `met_promachos: true`
- Open emblem selection GUI (see below)

---

### Returning Interaction (Existing Player)

**Trigger**: Player right-clicks Promachos, `met_promachos` flag is true

**GUI Opens**: Promachos Main Menu

```
╔═══════════════════════════════╗
║   Promachos - Herald Menu     ║
╠═══════════════════════════════╣
║                               ║
║  [Emblem]  [Progress]  [Info] ║
║                               ║
╚═══════════════════════════════╝
```

**Slots** (27-slot inventory):
- Slot 11: **Change Emblem** (compass icon)
- Slot 13: **Check Progress** (nether star icon)
- Slot 15: **System Info** (book icon)

**Click Handlers**:
- **Change Emblem**: Opens emblem selection GUI
- **Check Progress**: Opens emblem status GUI (shows all gods, progress, completion)
- **System Info**: Message explaining the system + closes GUI

---

## Emblem Selection GUI

**Title**: `Promachos - Choose Your Emblem`

**Size**: 27 slots (3 rows)

**Layout**:
```
╔═══════════════════════════════╗
║                               ║
║  [Demeter] [Hephaestus]       ║
║           [Heracles]          ║
║                               ║
║           [Cancel]            ║
╚═══════════════════════════════╝
```

**Items**:
- **Slot 12: Demeter**
  - Material: Wheat (procedural - shows progress status)
  - Display: `<&6><&l>Demeter's Emblem`
  - Activities: Wheat, Cows, Cakes

- **Slot 14: Hephaestus**
  - Material: Iron Pickaxe (procedural - shows progress status)
  - Display: `<&8><&l>Hephaestus' Emblem`
  - Activities: Iron Ore, Smelting, Golems

- **Slot 16: Heracles**
  - Material: Diamond Sword (procedural - shows progress status)
  - Display: `<&c><&l>Heracles' Emblem`
  - Activities: Pillagers, Raids, Emeralds
    ```

- **Slot 22: Cancel**
  - Material: Barrier
  - Display: `<&c>Cancel`
  - Lore: `<&7>Close this menu.`

**Click Handlers**:
- **Demeter**: Set `emblem.active: DEMETER`, narrate confirmation, close GUI
- **Hephaestus**: Set `emblem.active: HEPHAESTUS`, narrate confirmation, close GUI
- **Heracles**: Set `emblem.active: HERACLES`, narrate confirmation, close GUI
- **Cancel**: Close GUI

**Confirmation Messages**:
```
<&e><&l>Promachos<&r><&7>: You have chosen to pursue the emblem of <&6>Demeter<&7>. May the goddess bless your fields.
```

---

## Emblem Check GUI

**Title**: `Promachos - Emblem Progress`

**Size**: 45 slots (5 rows)

**Layout**:
```
╔═══════════════════════════════════════════╗
║                                           ║
║   [Demeter]    [Hephaestus]  [Heracles]   ║
║   [Status]     [Status]      [Status]     ║
║                                           ║
║   [Ceres]      [Vulcan]      [Mars]       ║
║   [Status]     [Status]      [Status]     ║
║                                           ║
║                 [Back]                    ║
╚═══════════════════════════════════════════╝
```

**Row 1 (Primary Gods)**:
- Slot 11: Demeter emblem status
- Slot 13: Hephaestus emblem status (placeholder)
- Slot 15: Heracles emblem status (placeholder)

**Row 2 (Component Status)**:
- Slot 20: Demeter components (wheat/cow/cake) with progress
- Slot 22: Hephaestus components (placeholder)
- Slot 24: Heracles components (placeholder)

**Row 3 (Meta Gods)**:
- Slot 29: Ceres status (unlocked if Demeter emblem owned)
- Slot 31: Vulcan status (placeholder)
- Slot 33: Mars status (placeholder)

**Row 4**:
- Slot 40: Back button

**Demeter Emblem Item** (example):
- If **unlocked**:
  - Material: Enchanted Golden Apple (or wheat with glint)
  - Display: `<&6><&l>Demeter's Emblem<&r> <&a>✓ UNLOCKED`
  - Lore:
    ```
    <&7>Symbol of agricultural mastery.
    <&7>Unlocked: <&a><player.flag[demeter.emblem.unlock_date].format>
    ```
  - **Clickable**: Opens Ceres progression GUI (if Ceres items not all obtained)

- If **ready to unlock** (all components obtained, not yet unlocked):
  - Material: Nether Star (pulsing glint)
  - Display: `<&e><&l>Demeter's Emblem<&r> <&e>⚠ READY!`
  - Lore:
    ```
    <&7>All components obtained!
    <&a>Click to unlock this emblem.
    ```
  - **Clickable**: Triggers emblem unlock ceremony (see below)

- If **in progress**:
  - Material: Wheat
  - Display: `<&6><&l>Demeter's Emblem<&r> <&7>In Progress`
  - Lore:
    ```
    <&7>Components:
    <&a>✓ Wheat Component <&7>(<player.flag[demeter.wheat.count]>/15000)
    <&c>✗ Cow Component <&7>(<player.flag[demeter.cows.count]>/2000)
    <&c>✗ Cake Component <&7>(<player.flag[demeter.cakes.count]>/300)
    ```

- If **locked** (emblem never selected or no progress):
  - Material: Gray Dye
  - Display: `<&8>???`
  - Lore:
    ```
    <&8><&o>Select the Demeter emblem to begin.
    ```

**Component Status Item**:
- Shows real-time progress for all 3 components
- Dynamic lore generation via procedure
- Not clickable (informational only)

---

## Emblem Unlock Ceremony

**Trigger**: Player clicks "READY!" emblem item in emblem check GUI

**Validation**:
1. Check all component flags are true:
   - `demeter.component.wheat`
   - `demeter.component.cow`
   - `demeter.component.cake`
2. Check emblem not already unlocked: `demeter.emblem.unlocked` is false

**If valid**:

1. **Close GUI**

2. **Play sound**: `ui_toast_challenge_complete` at volume 1.0

3. **Dialogue sequence** (3s delay between):
   ```
   <&e><&l>Promachos<&r><&7>: You have gathered the sacred offerings of <&e>Demeter<&7>.

   <&e><&l>Promachos<&r><&7>: The goddess of harvest smiles upon you. Receive her emblem!

   <&e><&l>Promachos<&r><&a>You have unlocked the <&6><&l>Emblem of Demeter<&a>!
   ```

4. **Set flags**:
   - `demeter.emblem.unlocked: true`
   - `demeter.emblem.unlock_date: <util.time_now>`

5. **Optional: Consume component items** (if they are physical items):
   - Remove from inventory or mark as consumed

6. **Optional: Grant rewards**:
   - Title: `title:<player> title:<&6><&l>EMBLEM UNLOCKED! subtitle:<&e>Demeter's Blessing times:10,40,10 fade_in:10 stay:40 fade_out:10`
   - Particles: `playeffect effect:totem at:<player.location> quantity:50 offset:1.5`

7. **Announce to server**:
   ```
   <&e><&l>[Promachos]<&r> <&f><player.name> <&7>has unlocked the <&6><&l>Emblem of Demeter<&7>!
   ```
   - Sound: All online players hear `ui_toast_challenge_complete`

8. **Unlock next emblem line**:
   - Increment: `emblem.rank` flag
   - Check tier progression for next emblem
   - Message:
     ```
     <&e><&l>Promachos<&r><&7>: A new path has been revealed to you. Return when you are ready to pursue the next emblem.
     ```

9. **Re-open emblem check GUI** (now showing Demeter as unlocked)

**If invalid** (components not complete):
- Close GUI
- Message: `<&e><&l>Promachos<&r><&c>You are not yet ready. Complete all components first.`
- Sound: `villager_no`

---

## Emblem Switching Logic

**Rules**:
- Players may switch at any time
- No cooldown
- No cost
- No data loss

**Process**:
1. Player clicks "Change Emblem" in Promachos main menu
2. Opens emblem selection GUI (same as first-time)
3. Player clicks new emblem
4. Script checks if `emblem.active` is already set to that emblem:
   - If same: Message `<&7>You are already pursuing <&6>Demeter<&7>.`, close GUI
   - If different:
     - Set `emblem.active: <new_emblem>`
     - Set `emblem.changed_before: true`
     - Narrate:
       ```
       <&e><&l>Promachos<&r><&7>: You have changed your emblem to <&6>Hephaestus<&7>. Your previous progress with <&6>Demeter<&7> is preserved.
       ```
     - Sound: `block_enchantment_table_use`
     - Close GUI

**Effects of Emblem Switch**:
- Immediately stops tracking for old emblem
- Immediately starts tracking for new emblem
- All counters, keys, components preserved (no reset)
- Keys can still be used regardless of active emblem

---

## System Info Message

**Trigger**: Player clicks "System Info" in Promachos main menu

**Message**:
```
<&7><&m>                                        <&r>
<&e><&l>Emblem System Overview<&r>

<&6>Emblems:<&7> Choose one emblem to pursue at a time.
<&7>Only your active emblem earns progress and keys.

<&6>Activities:<&7> Perform tasks related to your emblem.
<&7>Earn keys frequently, unlock components at milestones.

<&6>Components:<&7> Collect all components, then return to me.
<&7>I will unlock the emblem and reveal the next path.

<&6>Keys:<&7> Use keys anytime to open crates.
<&7>Keys can be traded or saved regardless of your emblem.

<&8>Type <&e>/profile<&8> to view your progress.
<&7><&m>                                        <&r>
```

**GUI closes automatically**

---

## Procedures (For Script Implementation)

### `get_emblem_display_name`
- Input: `<[emblem]>` (e.g., `DEMETER`)
- Output: Display name (e.g., `Demeter`)

### `get_god_for_emblem`
- Input: `<[emblem]>` (e.g., `DEMETER`)
- Output: God name (e.g., `Demeter`)

### `check_demeter_components_complete`
- Input: `<[player]>`
- Output: Boolean (true if all 3 components obtained)

### `get_emblem_status_item`
- Input: `<[player]>`, `<[god]>` (e.g., `demeter`)
- Output: ItemTag (status item for GUI)

---

## Event Handlers

### `on player right clicks npc` (Promachos ID 0)
- Check `met_promachos` flag
- If false: Start first-time dialogue sequence
- If true: Open main menu

### `on player clicks in promachos_main_menu`
- Route to emblem selection, emblem check, or info

### `on player clicks in emblem_selection_gui`
- Set emblem flag, narrate confirmation, close

### `on player clicks in emblem_check_gui`
- If "READY!" emblem clicked: Run unlock ceremony
- If locked/in-progress: Inform player

---

## Dialogue Tone Guidelines

- **Formal but warm**: Promachos is a herald, not a friend, but respects the player
- **Encouraging**: Congratulates milestones, uses positive language
- **Mythologically consistent**: References gods by name, uses "path" metaphor
- **Clear instructions**: No ambiguity in what to do next
- **Celebratory**: Emblem unlocks feel epic and rewarding

---

## Implementation Notes

- Use `wait 3s` between dialogue lines (readable pace)
- All GUIs close on emblem action (no lingering menus)
- Sounds reinforce feedback (success/error)
- Server announcements for emblem unlocks (social validation)
- Procedures keep code DRY (reusable status checks)
- Future-proof: Template for Hephaestus/Heracles emblem ceremonies

---

## Future Enhancements

- **Emblem showcase mode**: Special GUI showing all unlocked emblems + lore
- **Prestige system**: Reset emblems for titles/badges
- **Dialogue variations**: Random greeting lines on repeated visits
- **Quest integration**: Promachos offers special challenges for bonus keys
