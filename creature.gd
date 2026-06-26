class_name Creature
extends Area2D


const MAX_ENERGY: float = 300
const STARTING_ENERGY: float = 0.4 * MAX_ENERGY
const DEFAULT_ENERGY_CONSUMPTION: float = 10.0
const MAX_HP: int = 10
const MOVING_SPEED: float = 150.0
const TURN_INERTIA: float = 0.3


var _energy: float = STARTING_ENERGY
var _hp: int = MAX_HP

var _last_moving_direction: Vector2 = Vector2.ZERO
var _moved_prev_tick: bool = false
var _moved_this_tick: bool = false


var energy: float:
    get:
        return _energy


func init_with_state(state_factory: Callable):
    $CreatureAI.init_state(state_factory)


func move_to_target(target: Food, delta: float) -> void:
    var advised_dir = $MovingAdviser.advised_direction(target.global_position)
    _move_towards(advised_dir, delta)


func move_towards(direction: Vector2, delta: float) -> void:
    var advised_dir = $MovingAdviser.correct_direction(direction)
    _move_towards(advised_dir, delta)


func make_child(init_direction: Vector2) -> Creature:
    return Spawner.spawn_creature(global_position, LeavingCreatureState.make_factory(self, init_direction))


func change_energy(delta: float):
    _energy = clampf(_energy + delta, 0, MAX_ENERGY)


func is_alive() -> bool:
    return _hp > 0 and _energy > 0


func _move_towards(direction: Vector2, delta: float) -> void:
    _moved_this_tick = true

    var move_direction = direction
    if _moved_prev_tick:
        move_direction = move_direction.lerp(_last_moving_direction, TURN_INERTIA)

    global_position += move_direction * MOVING_SPEED * delta
    _last_moving_direction = move_direction


func _ready() -> void:
    pass


func _process(_delta: float) -> void:
    pass


func _physics_process(delta: float) -> void:
    change_energy(-DEFAULT_ENERGY_CONSUMPTION * delta)
    if not is_alive():
        queue_free()
        return

    $CreatureAI.update(delta)

    _moved_prev_tick = _moved_this_tick
    _moved_this_tick = false
