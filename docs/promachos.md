# Promachos NPC - Complete Specification

## Role & Purpose

**Promachos** (Προμαχός) means "champion" or "defender who fights in the front line."

In V2, Promachos is the **system anchor** and **ceremony master**:
- Introduces the emblem system on first meeting
- Forces role selection (cannot proceed without choosing)
- Allows role switching at any time
- Checks component completion and unlocks emblems
- Congratulates players on emblem unlocks
- Gates the next emblem line in each role path

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

3. **Roles Explained**
   ```
   <&e><&l>Promachos<&r><&7>: You must choose a path: <&6>Georgos<&7> (farmer), <&6>Metallourgos<&7> (miner), or <&6>Hoplites<&7> (warrior). Only one path may be walked at a time.
   ```

4. **Emblems Explained**
   ```
   <&e><&l>Promachos<&r><&7>: Each path leads to divine emblems—symbols of mastery. Collect components through your labors, and I shall unlock the emblem when you are ready.
   ```

5. **Call to Action**
   ```
   <&e><&l>Promachos<&r><&7>: Choose wisely. Your path begins now.
   ```

**After dialogue**:
- Flag `met_promachos: true`
- Open role selection GUI (see below)

---

### Returning Interaction (Existing Player)

**Trigger**: Player right-clicks Promachos, `met_promachos` flag is true

**GUI Opens**: Promachos Main Menu

```
╔═══════════════════════════════╗
║   Promachos - Herald Menu     ║
╠═══════════════════════════════╣
║                               ║
║   [Role]  [Emblems]  [Info]   ║
║                               ║
╚═══════════════════════════════╝
```

**Slots** (27-slot inventory):
- Slot 11: **Change Role** (compass icon)
- Slot 13: **Check Emblems** (nether star icon)
- Slot 15: **System Info** (book icon)

**Click Handlers**:
- **Change Role**: Opens role selection GUI
- **Check Emblems**: Opens emblem status GUI (shows all gods, progress, completion)
- **System Info**: Message explaining the system + closes GUI

---

## Role Selection GUI

**Title**: `Promachos - Choose Your Path`

**Size**: 27 slots (3 rows)

**Layout**:
```
╔═══════════════════════════════╗
║                               ║
║   [Georgos] [Metallourgos]    ║
║             [Hoplites]        ║
║                               ║
║           [Cancel]            ║
╚═══════════════════════════════╝
```

**Items**:
- **Slot 11: Georgos (Farming)**
  - Material: Golden Hoe (or Wheat)
  - Display: `<&6><&l>Georgos<&r> <&7>(Farmer)`
  - Lore:
    ```
    <&7>Path of agriculture and abundance.
    <&7>Serve <&e>Demeter<&7>, goddess of harvest.

    <&8>Activities: Wheat, Cows, Cakes
    ```

- **Slot 13: Metallourgos (Mining)**
  - Material: Diamond Pickaxe (or Iron Ore)
  - Display: `<&6><&l>Metallourgos<&r> <&7>(Miner)`
  - Lore:
    ```
    <&7>Path of stone and metal.
    <&7>Serve <&e>Hephaestus<&7>, god of the forge.

    <&8>Activities: <&8><&o>To be revealed...
    ```

- **Slot 15: Hoplites (Combat)**
  - Material: Diamond Sword (or Shield)
  - Display: `<&6><&l>Hoplites<&r> <&7>(Warrior)`
  - Lore:
    ```
    <&7>Path of strength and valor.
    <&7>Serve <&e>Heracles<&7>, hero of might.

    <&8>Activities: <&8><&o>To be revealed...
    ```

- **Slot 22: Cancel**
  - Material: Barrier
  - Display: `<&c>Cancel`
  - Lore: `<&7>Close this menu.`

**Click Handlers**:
- **Georgos**: Set `role.active: FARMING`, narrate confirmation, close GUI
- **Metallourgos**: Set `role.active: MINING`, narrate confirmation, close GUI
- **Hoplites**: Set `role.active: COMBAT`, narrate confirmation, close GUI
- **Cancel**: Close GUI

**Confirmation Messages**:
```
<&e><&l>Promachos<&r><&7>: You have chosen the path of <&6>Georgos<&7>. May Demeter bless your fields.
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

- If **locked** (role never selected or no progress):
  - Material: Gray Dye
  - Display: `<&8>???`
  - Lore:
    ```
    <&8><&o>Select the Georgos role to begin.
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
   - XP: 1000 levels (or experience points)

7. **Announce to server**:
   ```
   <&e><&l>[Promachos]<&r> <&f><player.name> <&7>has unlocked the <&6><&l>Emblem of Demeter<&7>!
   ```
   - Sound: All online players hear `ui_toast_challenge_complete`

8. **Unlock next emblem line**:
   - Flag: `farming.next_emblem.unlocked: true`
   - Message:
     ```
     <&e><&l>Promachos<&r><&7>: A new path has been revealed to you, Georgos. Return when you are ready to pursue the next emblem.
     ```

9. **Re-open emblem check GUI** (now showing Demeter as unlocked)

**If invalid** (components not complete):
- Close GUI
- Message: `<&e><&l>Promachos<&r><&c>You are not yet ready. Complete all components first.`
- Sound: `villager_no`

---

## Role Switching Logic

**Rules**:
- Players may switch at any time
- No cooldown
- No cost
- No data loss

**Process**:
1. Player clicks "Change Role" in Promachos main menu
2. Opens role selection GUI (same as first-time)
3. Player clicks new role
4. Script checks if `role.active` is already set to that role:
   - If same: Message `<&7>You are already a <&6>Georgos<&7>.`, close GUI
   - If different:
     - Set `role.active: <new_role>`
     - Narrate:
       ```
       <&e><&l>Promachos<&r><&7>: You have changed your path to <&6>Metallourgos<&7>. Your previous progress as <&6>Georgos<&7> is preserved.
       ```
     - Sound: `block_enchantment_table_use`
     - Close GUI

**Effects of Role Switch**:
- Immediately stops tracking for old role
- Immediately starts tracking for new role
- All counters, keys, components preserved (no reset)
- Keys can still be used regardless of role

---

## System Info Message

**Trigger**: Player clicks "System Info" in Promachos main menu

**Message**:
```
<&7><&m>                                        <&r>
<&e><&l>Emblem System Overview<&r>

<&6>Roles:<&7> Choose one path to pursue at a time.
<&7>Only your active role earns progress and keys.

<&6>Activities:<&7> Perform tasks related to your role.
<&7>Earn keys frequently, unlock components at milestones.

<&6>Emblems:<&7> Collect all components, then return to me.
<&7>I will unlock the emblem and reveal the next path.

<&6>Keys:<&7> Use keys anytime to open crates.
<&7>Keys can be traded or saved regardless of your role.

<&8>Type <&e>/profile<&8> to view your progress.
<&7><&m>                                        <&r>
```

**GUI closes automatically**

---

## Procedures (For Script Implementation)

### `get_role_display_name`
- Input: `<[role]>` (e.g., `FARMING`)
- Output: Greek name (e.g., `Georgos`)

### `get_god_for_role`
- Input: `<[role]>` (e.g., `FARMING`)
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
- Route to role selection, emblem check, or info

### `on player clicks in role_selection_gui`
- Set role flag, narrate confirmation, close

### `on player clicks in emblem_check_gui`
- If "READY!" emblem clicked: Run unlock ceremony
- If locked/in-progress: Inform player

---

## Dialogue Tone Guidelines

- **Formal but warm**: Promachos is a herald, not a friend, but respects the player
- **Encouraging**: Congratulates milestones, uses positive language
- **Mythologically consistent**: References gods by role, uses "path" metaphor
- **Clear instructions**: No ambiguity in what to do next
- **Celebratory**: Emblem unlocks feel epic and rewarding

---

## Implementation Notes

- Use `wait 3s` between dialogue lines (readable pace)
- All GUIs close on role/emblem action (no lingering menus)
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
