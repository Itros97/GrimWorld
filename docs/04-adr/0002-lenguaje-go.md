# 0002 - Go como lenguaje del motor
---

**Estado**: Aceptado. Reemplaza a [0001 - Rust como lenguaje del motor](0001-lenguaje-rust.md)

## Contexto
En 0001 elegí Rust. Al empezar a diseñar el dominio vi que construir un motor y aprender
Rust a la vez mezcla dos riesgos: no sé distinguir si un problema viene de mi diseño o de
pelearme con el lenguaje (ownership, borrow checker). El riesgo es acabar deformando el
diseño para que compile, o no terminar el motor.

El diseño (estado + eventos + `fold`, azar resuelto antes de emitir eventos, juego en datos)
no depende del lenguaje; está en [el modelo de dominio](../03-domain.md).

## Opciones
1. **Seguir con Rust**
   - + `enum` + `match` exhaustivo para los eventos.
   - − Curva alta; avance lento y riesgo de no terminar.
2. **Go**
   - + Lo aprendo en poco tiempo; el código hace lo que se lee y puedo revisarlo y defenderlo.
   - + `bubbletea` (terminal) y Ebitengine (2D + WebAssembly) cubren v1-v3.
   - − Sin tipos suma: eventos como interfaz + `struct` por evento + type switch, sin exhaustividad del compilador.
   - − Binarios WebAssembly más grandes (mitigable con TinyGo).
3. **Kotlin**
   - + Lo domino.
   - − No aporta un segundo lenguaje al portfolio; frontends terminal/2D/Wasm menos maduros.

## Decisión
Go.

## Consecuencias
+ Puedo empezar el `core` pronto y entender cada línea.
+ Un motor terminado y bien diseñado pesa más en el portfolio que uno a medias.
- Exhaustividad de eventos sin compilador: la compenso con el linter `exhaustive`
  (interfaz sellada con método privado) y con un test que recorre todos los tipos de evento.
- El formato de datos pasa a ser el ADR 0003.
- Rust queda como posible proyecto futuro, más pequeño, con el diseño ya probado.
