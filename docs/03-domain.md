# Modelo de dominio del motor (borrador v1)
---

## Principio
`state = fold(initial_state, events)`.
El estado nunca se modifica directamente: solo aplicando eventos.
Guardar = guardar la semilla + la lista de eventos. Deshacer y replays salen de ahí.

## Flujo de una acción
```
jugador elige acción
  → validar (¿está disponible?, ¿hay recursos?)        [puro, sin RNG]
  → resolver (tirar dados, aplicar perks, calcular resultado) [usa RNG]
  → emitir eventos con el resultado ya decidido
  → aplicar eventos al estado                          [puro, sin RNG]
```

**Regla clave: aplicar un evento nunca usa el RNG.** El azar se resuelve antes y el evento
guarda el resultado (`success: true`). Así el replay es trivial y aplicar es una función pura.

## Estado
| Campo | Qué guarda |
|-------|------------|
| `rng` | Semilla y posición actual |
| `tick` | Tiempo de juego |
| `resources` | Cantidades: madera, tela, alcohol, comida, balas, cordura... |
| `items` | Objetos con estado propio: mechero (durabilidad), antorcha, armas... |
| `flags` | Pistas, puntos looteados, escenas vistas, elecciones hechas |
| `location` | Planta actual |
| `locations` | Estado por planta (puntos de loot vaciados, descubierta o no) |
| `background` | Trasfondo oculto |
| `active_scene` | Escena o decisión abierta, si la hay |

## Eventos
| Evento | Cuándo |
|--------|--------|
| `GameStarted { seed }` | Inicio de partida |
| `BackgroundAssigned { id }` | Inicio, tras resolver el trasfondo |
| `ActionAttempted { action, success }` | Acción con azar (encender mechero, buscar a oscuras...) |
| `ResourceChanged { id, delta }` | Cualquier cambio de cantidad |
| `ItemGained { id }` / `ItemBroken { id }` | Ganar o perder un objeto |
| `ItemCrafted { recipe }` | Crafteo (consume entradas, da salidas) |
| `SceneEntered { id }` | Se abre una escena o decisión |
| `ChoiceMade { scene, option, outcome }` | El jugador elige y se resuelve el resultado |
| `FlagSet { id }` | Pista, punto looteado, escena vista... |
| `LocationChanged { from, to }` | Rapel entre plantas |
| `Ticked { n }` | Paso del tiempo (incluye progreso offline: N ticks) |
| `PlayerCollapsed` | Cordura a 0 |

## Reglas que viven en datos (no en código)
- Acciones: coste, cooldown, probabilidad, condición de disponibilidad.
- Recetas: entradas → salidas.
- Escenas: texto, opciones, resultados ponderados.
- Condiciones: `recurso >= N`, flag activo, planta actual, trasfondo.
- Perks: modificadores sobre probabilidad, cantidad o coste.
- Drenaje por tick según contexto (a oscuras / con luz).

## Invariantes
- Siempre hay al menos una acción posible.
- Ningún recurso baja de 0; la cordura no supera su máximo.
- No se puede craftear sin todas las entradas.
- Un punto de loot vaciado no vuelve a dar lo mismo.
- Misma semilla + mismas acciones del jugador = mismo estado final.

## Decisiones abiertas
1. **Granularidad**: ¿`ChoiceMade` lleva sus efectos dentro, o emite además `ResourceChanged`/`FlagSet` por cada efecto?
   Propuesta: eventos pequeños por efecto. El log se lee mejor y `apply` queda simple.
2. **Perks**: se aplican al **resolver** (antes del evento), nunca al aplicar. Coherente con la regla del azar.
3. **Formato de datos** (ADR 0003): pendiente de escribir el inicio del juego en formato.
