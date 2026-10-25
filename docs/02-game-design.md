# Juego de demo — diseño (borrador)
---

Juego de demo del motor. Estilo A Dark Room: revelación progresiva, decisiones con riesgo y misterio.

## Premisa
Despiertas a oscuras, de noche cerrada, en un penthouse vacío de un rascacielos a medio construir,
en un mundo post-apocalíptico. Nadie llegó a vivir ahí. No sabes quién eres ni por qué estás ahí.
Nunca se explica directamente.

## Escenario
- Un macro-barrio gigante en construcción (inspirado en las ciudades fantasma de promotoras quebradas, p. ej. Ocean Flower Island),
  ficticio y con nombre propio: torres de lujo a medio acabar, hoteles y centros comerciales sin estrenar, grúas paradas.
- Además, un apocalipsis misterioso que nunca se explica directamente. El jugador no sabe qué vino antes:
  ¿se abandonó la obra por el apocalipsis, o el apocalipsis empezó aquí?

## Arco
**Solo y a oscuras → refugio → bastión con comunidad.**
1. Penthouse: conseguir luz.
2. Rascacielos: explorar plantas (unas acabadas, otras en obra, sin paredes, andamios). Progresión vertical:
   bajar a por recursos, asegurar plantas, la azotea como objetivo.
3. Bastión: convertir plantas en huerto, taller, dormitorios... para la gente que llega.

## Inicio (v1)
1. **Oscuridad.** Única acción: *Encender mechero* (25 % de éxito; varios textos de fallo).
2. **Llama.** *"Una tenue llama naranja ilumina vagamente la sala. Estás solo, pero hay madera."*
   La llama dura un número limitado de decisiones.
3. **Lootear con decisiones.** Cada punto del penthouse (cocina sin estrenar, cajas de obra, plásticos de protección, hueco del ascensor...)
   gasta llama y tiene resultados ponderados con riesgo. Un punto looteado se vacía.
4. **Se apaga la llama.** Al soltar el mechero hay un % de que se rompa.
5. **Mechero roto.** *Buscar a oscuras*: probabilidad baja, cuesta cordura y tiene riesgos.
   Puede dar otra fuente de fuego (cerillas, piedras...).
6. **Antorcha** = madera + tela + alcohol → luz estable. Empieza la siguiente fase: explorar el edificio.

## Moverse entre plantas
- Por el **hueco del ascensor**: rapel a la planta de abajo o de arriba. Ambas son otros penthouses.
- Requiere cuerda (crafteo o loot) y tiene riesgo (caída, pérdida de cordura).
- Cada planta es una localización con sus propios puntos de loot, flags y estado.
- **Arriba**: más seguro, hacia la azotea. Se oye una voz por radio (pistas del misterio, posible contacto).
  Si investigas, encuentras un militar muerto: pistola Beretta 92 con pocas balas y escopeta de corredera con 2 cartuchos.
  La munición es escasa y no se recupera fácilmente.
- **Abajo**: más recursos y más peligro. Se oyen rugidos y voces (¿criaturas?, ¿supervivientes hostiles?, ¿ambos?).

## Trasfondo oculto
- Al iniciar, se asigna un trasfondo al azar (con semilla). El jugador no lo elige ni lo ve.
- Da perks pasivas ocultas que el jugador nota en el juego y que una pista acaba confirmando.
- Los perks son modificadores en datos sobre probabilidades, costes y textos.

| Trasfondo | Perks |
|-----------|-------|
| Policía | Mejor en conversaciones; investigador: más probabilidad de encontrar e interpretar pistas; sabe usar la radio y sus frecuencias |
| Militar | Nervios de acero; puntería ×1,5; sabe usar la radio y sus frecuencias |
| Constructor | Recolectar ×1,5; más éxito al construir |
| Chef | Encontrar comestibles ×1,25; convierte comida mala o mediocre en buena y comestible |
| Ingeniero | Obtener electrónica ×1,25; desmontar objetos; más éxito construyendo objetos electrónicos (radio, generadores...) |
| Enfermero | Pierde menos cordura; recupera más descansando; cura heridas propias y de otros (propuesta) |
| Vagabundo | Sigilo: menos ruido y menos peligros al lootear; encuentra recursos donde otros no ven nada; aguanta mejor el hambre y la oscuridad (propuesta) |

## Cordura
- Baja más rápido a oscuras y al asumir riesgos; más despacio con luz.
- Sube descansando (con luz y seguridad), comiendo y hablando con gente.
- A 0: te desmayas y despiertas a oscuras con menos recursos y algo de cordura (sin reinicio total).

## Misterio
- Pistas fragmentadas: planos de la obra con anotaciones, un cartel de venta de los penthouses, una tarjeta de acceso,
  partes de obra interrumpidos, radio, periódicos. Más adelante, edificios cercanos (p. ej. una comisaría) con más pistas.
- Cada pista es un flag; ciertas combinaciones desbloquean escenas de recuerdo.
- Ambigüedad: ¿culpable o víctima? Se mantiene hasta tarde.

## Lo que exige al motor (v1)
- Recursos e inventario.
- Acciones con coste, cooldown y probabilidad (RNG con semilla en el estado).
- Estado que se agota (llama, durabilidad, cordura) y drenaje por tick según contexto.
- Opciones con resultados ponderados.
- Flags (puntos looteados, pistas, peligro).
- Recetas de crafteo.
- Localizaciones conectadas (plantas) con estado propio y transiciones con requisitos y riesgo.
- Condiciones de desbloqueo (`recurso >= N`, flags, elecciones previas).
- Escenas de texto y condición de "derrota" (desmayo) como efectos en datos.

## Modos de fallo
| ID | ¿Qué pasa si…? | ¿Qué debe ocurrir? |
|----|----------------|--------------------|
| FM-01 | el mechero se rompe sin antorcha | *Buscar a oscuras* siempre disponible, con coste de cordura |
| FM-02 | se vacían los puntos de loot sin los 3 ingredientes | queda al menos una fuente (a oscuras o reaparición) |
| FM-03 | se gasta la madera antes de craftear | se puede volver a conseguir |
| FM-04 | la cordura llega a 0 | desmayo: despiertas a oscuras con menos recursos |

## Invariantes
- Siempre hay al menos una acción posible.
- La cordura está entre 0 y su máximo.
- No se puede craftear sin todos los ingredientes.
- Un punto de loot vaciado no vuelve a dar lo mismo.

## Abierto
- Qué hay al salir del penthouse: primera planta a explorar y cómo se "asegura" una planta.
- Números concretos (duración de la llama, % de rotura, drenaje de cordura).
- Muerte roguelite (persistencia entre partidas) como idea para v2.
