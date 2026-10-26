<div align="center">

# GrimWorld

**A narrative idle game where you wake up in the dark, at the top of an unfinished skyscraper.**
This is the Godot 4.7 prototype that validates the design before the engine is extracted. It needs only Godot.

![Godot](https://img.shields.io/badge/Godot-4.7-478CBF?logo=godotengine&logoColor=white)
![Status](https://img.shields.io/badge/status-in%20development-orange)
![Licence](https://img.shields.io/badge/licence-MIT-blue)

</div>

> **Note:** written with an AI assistant and pending thorough review. See the [AI disclosure](#-ai-disclosure).

## 🤖 AI disclosure

I write most of my code by hand, so I want to be clear about this project: **it was written by an
AI assistant (Claude, by Anthropic) under my direction, in October 2026.** I decided what to build
and how it should behave; the AI wrote the project skeleton, the code, the tests and the docs.
The audio is by other people, see [Licence](#licence).
Every commit made this way carries a `Co-Authored-By: Claude` line.

**Status: pending thorough review.** Phase 1 (lighting the lighter) runs in Godot 4.7.2 and its 34 engine,
data, credits and sound cue tests pass.
I have not yet reviewed it line by line. Treat it as a working draft, not as code I vouch for.

> ⚠️ **Warning:** an early experiment, **not ready to play**. Everything will change.

---

## 🚀 Quick start

```bash
git clone https://github.com/Itros97/GrimWorld.git
cd GrimWorld
godot --editor --path .    # open the project in the Godot editor
godot --path .             # run the game with a random seed
godot --path . -- --seed=42    # run the game with a fixed seed
godot --headless --import && godot --headless -s tests/run_tests.gd    # run the tests
```

[More on the architecture →](docs/01-overview.md)

## 📚 Documentation

| | |
|---|---|
| [Overview](docs/01-overview.md) | What GrimWorld is, its architecture and how the project is laid out. |
| [Game design](docs/02-game-design.md) | Setting, progression, sanity, hidden backgrounds and failure modes (Spanish). |
| [Domain model](docs/03-domain.md) | Engine state, events and the flow of an action (Spanish). |
| [Decision records](docs/04-adr/0002-lenguaje-go.md) | Why the engine will be written in Go (Spanish). |

[Read the docs online →](https://itros97.github.io/GrimWorld/)

## Licence

MIT, see [LICENSE](LICENSE).

Third-party audio, also credited in the game (*Créditos*). The files are not in the repository:
download them and save them with these names to hear the game; without them it runs silent.

| File | Work | Author | Licence |
|---|---|---|---|
| `assets/music/main_screen.ogg` | [Granular organic glitches over an electromagnetic drone background](https://freesound.org/s/869606/) | bassimat | CC0 |
| `assets/sounds/lit_ambience.mp3` | [Space drone ambience 01](https://freesound.org/s/425984/) | magmisoundtracks | CC0 |
| `assets/sounds/zippo_open.wav`, `zippo_close.wav` | [Zippo lighter open close 2](https://freesound.org/s/838151/), split in two | RSSC | CC0 |
