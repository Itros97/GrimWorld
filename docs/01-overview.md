# Overview
---

GrimWorld is a game made with Godot 4.7. This page will describe the game once its design is written.

## Project layout
---

| | |
|---|---|
| `managers/` | Central managers that own game state and emit signals. |
| `models/` | Data classes with static `from(...)` factories. |
| `constants/` | Shared constants and enums. |
| `engine/` | Pure game logic, independent from scenes and nodes. |
