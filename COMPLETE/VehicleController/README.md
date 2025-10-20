# VehicleController System

## Overview
**VehicleController** is a unified, modular Lua framework that manages advanced vehicle flight, hover, and ground-mode control in Roblox.  
It merges multiple subsystems into a single orchestrated script with full priority logic:
- **Y Key → Elite Hover Mode (Main King)**
- **Z / F / H Keys → Car/Drive Modes (Secondary)**
- **B / T Keys → Utility Toggles (Cycle & Collision)**
  
When the Elite Hover mode is active, all other systems are automatically suspended for stable operation.  
Switching to a drive mode (Z/F/H) instantly disables hover and gives driving full control.

---

## Features
✅ **Priority-based control** — Only one system can be active at a time.  
✅ **Terrain-adaptive hover system** — Smooth uphill flight and ground proximity effect.  
✅ **Car mode integration** — Multiple speed profiles for different driving experiences.  
✅ **Straightener / Collision modes** — Optional vehicle orientation and collision toggles.  
✅ **Clean modular design** — Each major system runs in its own file for easy maintenance.

---

## Folder Structure
