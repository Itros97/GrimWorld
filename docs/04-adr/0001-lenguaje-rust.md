# 0001 - Rust como lenguaje del motor
---

**Estado**: Reemplazado por [0002 - Go como lenguaje del motor](0002-lenguaje-go.md)

## Contexto
El motor es un núcleo de lógica pura: estado + acciones como eventos, con guardado,
deshacer y replays, y juegos definidos por datos. Debe ser determinista y ejecutarse
en varios frontends: terminal (v1), web vía WebAssembly (v2) y 2D con sprites (v3).
Además es un proyecto de portfolio y de aprendizaje: debe demostrar diseño de
arquitectura en un segundo lenguaje distinto a mi stack habitual (Kotlin/Spring).

## Opciones
1. **Rust**
   - + `enum` con datos y `match` exhaustivo: modelo de eventos natural y verificado por el compilador.
   - + WebAssembly de primera clase, binarios pequeños.
   - + Ecosistema adecuado: `serde` + `ron` (datos), `ratatui` (terminal), `macroquad` (2D).
   - + Ownership desincentiva el estado mutable compartido, alineado con event sourcing.
   - + Lenguaje con mucha proyección; señal fuerte en portfolio.
   - − Curva de aprendizaje alta; no conozco el lenguaje.
   - − Invita a sobreingeniería (traits genéricos, macros, ECS).
2. **Kotlin**
   - + Lo domino; desarrollo rápido.
   - + `sealed class` permite modelar eventos bien.
   - − Kotlin/Wasm y frontends de terminal/2D menos maduros.
   - − No aporta un segundo lenguaje al portfolio.
3. **Go**
   - + Curva baja; código explícito y fácil de revisar.
   - + `bubbletea` (terminal) y Ebitengine (2D + Wasm) muy buenos.
   - − Sin tipos suma: eventos con interfaces + `switch` no exhaustivo.
   - − Binarios Wasm más pesados.

## Decisión
Rust.

## Consecuencias
+ Modelo de eventos y estado expresado con tipos y comprobado en compilación.
+ Un mismo núcleo sirve a terminal, web y 2D.
+ Aprendo un segundo lenguaje con mucha proyección.
- Arranque más lento: Rust Book (cap. 1-10) y Rustlings antes del `core`.
- Mientras aprendo, el código del `core` lo escribo yo o lo reviso línea a línea antes de aceptarlo.
- Disciplina contra la sobreingeniería: structs, enums y funciones en v1; nada que no justifique en una frase.
