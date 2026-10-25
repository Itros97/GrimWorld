# Overview
---

GrimWorld is a narrative idle game in the style of A Dark Room. You wake up in the dark, in an empty penthouse at the top of an unfinished skyscraper, and slowly uncover a world that ended without explanation.

This repository is a prototype in Godot 4.7 used to validate the design. A standalone engine will be extracted from it later, so the prototype follows the engine architecture instead of the usual Godot style.

## Architecture
---

- `state = fold(initial_state, events)`: state only changes by applying events.
- Applying an event never uses randomness. The resolver rolls the dice first and the event stores the result, including the new position of the generator.
- The seeded generator lives in the state, so the same seed and the same actions always give the same game.
- Content lives in `data/game.json` and is validated when it is loaded.
- Godot only paints the state and emits `action_requested`; the `GameManager` autoload resolves actions and emits `STATE_CHANGED`.

## Project layout
---

| | |
|---|---|
| `engine/` | Pure game logic with no nodes: state, events, reducer, resolver. |
| `models/` | Game data classes built and validated from JSON. |
| `managers/` | The `GameManager` autoload that owns the event log. |
| `ui/` | Scenes and scripts that paint the state. |
| `data/` | Game content: texts, actions, probabilities. |
| `tests/` | Engine and data tests with fixed seeds, plus a small test runner. |
| `constants/` | Shared constants, empty for now. |

## Design documents
---

The game design, the domain model and the decision records are written in Spanish:

- [Game design](02-game-design.md)
- [Domain model](03-domain.md)
- [ADR 0001 - Rust](04-adr/0001-lenguaje-rust.md) (replaced) and [ADR 0002 - Go](04-adr/0002-lenguaje-go.md)
