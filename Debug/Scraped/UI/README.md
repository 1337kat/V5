# 🎮 ClientUIController
The central UI control layer for the game client.  
Handles all on-screen interfaces, map rendering, HUD logic, and player input.

## ✨ Features
- Modular UI system for FPS-style HUD and menus
- Radial menu with mouse + controller support
- In-game map with zoom, pan, and clan markers
- Smooth transitions between gameplay, spawn, and death screens
- Network-linked prompts and text input
- Supports cinematic and developer modes

## 🧩 Dependencies
- `_G.NEXT`, `_G.classes`
- Roblox services: `RunService`, `UserInputService`, `ReplicatedStorage`, etc.
- Class modules: `NetClient`, `SendCodes`, `InputManager`, `Sound`, `FPS`

## 🧱 Architecture Overview
```text
ClientUIController
│
├── Core HUD
│   ├── Health / Energy / Crosshair
│   └── Cinematic & MidText Info
│
├── Inventory Interfaces
│   ├── Hotbar
│   ├── Armor
│   └── Containers
│
├── Map System
│   ├── Compass
│   ├── Zoom / Pan Controls
│   └── Clan Marker Sync
│
├── Menus
│   ├── Radial Menu
│   ├── Spawn / Death Screens
│   └── Lobby / Serverlist
│
└── Prompts & Inputs
    ├── Text Prompts
    └── TCP Input Submissions
```

    # 🎮 ClientUIController.lua
**Unified Front-End Controller for Game Interfaces and Systems**

This module is the **central client-side controller** responsible for managing every major aspect of the in-game interface — from the FPS HUD and radial menus to map rendering, input prompts, and UI state transitions.  
It acts as the connective layer between user input, on-screen elements, and network communication.

---

## 🧠 Core Identity
Defines a global interface module (`_G.NEXT = u1`) that inherits multiple class controls:

- `InventoryUIControls`  
- `LobbyUIControls`  
- `ClanUIControls`

Together, these form a **unified front-end controller** that manages the entire visual and interactive layer of the game client.  
Every UI component — HUD, menus, map, prompts — is initialized and updated through this module.

---

## 🎯 Core UI Systems

### 🩸 FPS UI & HUD
- Displays and updates player vitals: **Health**, **Energy**, and **Crosshair**.  
- Dynamically reflects health ratio, damage feedback, and headshot indicators.  
- Integrates **blood splatter visuals** and hit sound effects for combat feedback.  
- Supports cinematic mode toggling, temporarily hiding the HUD for immersion.  
- Smooth fade transitions using `RenderStepped` interpolation.

### 🎒 Inventory & Equipment
- Controls visibility and behavior of:
  - **Hotbar**
  - **Armor**
  - **Inventory**
  - **Container** interfaces  
- Automatically suspends input or mouse lock when these menus are active.  
- Provides clean API accessors:  
  `GetHotbar()`, `GetArmor()`, `GetInventory()`, and `GetContainer()`.

### 🕹️ Radial Menu System
- Full radial layout generated dynamically using polar coordinates (`math.cos`, `math.sin`).  
- Menu options are spawned from a template (`u13`) and arranged evenly in a circular pattern.  
- Hover detection updates center labels and subtext in real time.  
- Integrates callback logic:  
  - `OpenRadialMenu(options, title, callback)`  
  - `CloseRadialMenu()`  
- Supports both **mouse and gamepad** inputs, with intuitive selection based on proximity.

### 💬 Text & Input Prompts
- `PromptTextInput()` creates an interactive textbox overlay for quick input.  
- Input automatically sends to the server via TCP using `NetClient` and `SendCodes`.  
- `Prompt()` creates **fade-in/fade-out floating text prompts** with timed transparency decay via `RenderStepped`.

### 🪦 Spawn & Death UI
- Generates context-sensitive spawn buttons, including:
  - **Random spawn**
  - **Totem spawn** with cooldown display  
- Displays death information (killer name, weapon, quip) after elimination.  
- Handles smooth **ease-spawning transitions**, fading between death, respawn, and gameplay screens.  

---

## 🗺️ Map & Compass Systems

### 🧭 Mini-Map + Compass HUD
- Real-time compass updates based on **camera yaw** (`CFrame:ToOrientation()`).  
- Displays rotating cardinal points (**N, NE, E, SE, S, SW, W, NW**) that align to the player’s facing direction.  
- Dynamic map markers for:
  - Player position
  - Clan members
  - Flags and totems  
- Color-coded clan/member markers using a **15-color palette** (`u180`).  
- Rotating LocalPlayer arrow indicator animated via sinusoidal pulse (`math.sin`-based).

### 🗺️ Map Controls
- **Smooth zoom in/out** (mouse wheel or buttons) with clamped bounds.  
- **Drag-pan** using mouse or controller input.  
- Ensures map stays within visible screen boundaries.  
- Syncs with server marker updates via the `PING_CLAN_MEMBERS` TCP packet.  

### 🚩 Flag Placement
- Converts current **mouse position** to world-space coordinates via helper `u132()`.  
- Sends `PLACE_MAP_MARKER` TCP event with computed X/Z coordinates.  
- Used to mark map flags, waypoints, and team objectives.

---

## 💬 Network Integration
Integrates seamlessly with `u2.NetClient` and `u2.SendCodes` for communication.  
This module handles only client-side UI triggers — all networking is routed through your main NetClient abstraction.

**Supported TCP Calls:**
- `TEXT_SUBMIT` — from text input prompts  
- `PLAYER_SPAWN` — on respawn or new player  
- `MENU_OPEN` — toggles lobby or serverlist UI  
- `PING_CLAN_MEMBERS` — updates map/clan visibility  
- `PLACE_MAP_MARKER` — submits new map flag

---

## ⚙️ Game States & Core Handling
### `SetCore(stateName)`
Controls and transitions between major UI states:
- `"FPS"` — Main gameplay HUD  
- `"spawning"` — Spawn selection screen  
- `"loading"` — Loading screen  
- `"easeSpawning"` — Transitional fade between spawn/death  
- `"serverlist"` — Lobby or admin menu  

Transitions are fully **interpolated** with smooth fade animations for professional polish.  
`ToggleMenu()` manages switching between gameplay and lobby views.

**Initialization (`init()`)**
- Disables default Roblox CoreGui components (Health, Backpack, etc.)  
- Loads internal submodules dynamically.  
- Constructs the map grid and binds render loops for radial menus.  

---

## 🎮 Input & Control Flow
- Smart **input reservation system**:
  - `isInputReserved()` and `GetShouldMouseLock()` prevent overlapping input contexts.  
- Supports both **keyboard/mouse** and **gamepad** users.  
  - `Thumbstick2` mapped to map panning vector.  
- Handles mouse wheel for map zooming, drag for map panning.  
- Toggles:
  - Inventory
  - Map
  - Cinematic mode  

---

## 🌈 Visual Polish
- Smooth transitions via transparency lerps on every major UI element.  
- Dynamic text and background color changes for item gain/loss:
  - Green `+` for added items  
  - Red `–` for removed items  
- Clean, responsive feedback in all interactive menus.  
- Clan markers utilize an elegant, looping **color wheel system** (`u180`).

---

## 💡 In Short
This script provides:

✅ Full UI framework for gameplay and menus  
✅ Real-time map and compass visualization  
✅ Inventory, spawn, and lobby management  
✅ Smooth, polished transitions between UI states  
✅ Gamepad and mouse input integration  
✅ Abstracted server communication via TCP  
✅ Modular design with unified global access

---

## 📁 File Information
**File:** `ClientUIController.lua`  
**Folder:** `src/client/ui/`  
**Version:** 1.0.0  
**Last Updated:** 2025-10-23  
**Author:** Jay Tunez  

---

## 📖 Example Usage
```lua
-- Initialize and bind UI controller
local ClientUIController = require(ReplicatedStorage.Modules.ClientUIController)
ClientUIController.init()

-- Toggle map or HUD manually
ClientUIController.ToggleMap(true)
ClientUIController.SetCore("FPS")
```
