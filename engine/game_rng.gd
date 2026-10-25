class_name GameRng
extends RefCounted
## Builds the seeded generator whose seed and position live in the game state.

## Position of a fresh generator for the given seed.
static func initial_state(seed_value : int) -> int:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	return rng.state

## Generator placed where the state left it.
static func from_state(state : GameState) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = state.rng_seed
	rng.state = state.rng_state
	return rng
