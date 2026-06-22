class_name Creature
extends Area2D


const MAX_ENERGY: float = 300
const STARTING_ENERGY: float = 0.4 * MAX_ENERGY
const DEFAULT_ENERGY_CONSUMPTION: float = 10.0
const MAX_HP: int = 10
const MOVING_SPEED: float = 150.0


var _energy: float = STARTING_ENERGY
var _hp: int = MAX_HP


var energy: float:
    get:
        return _energy


func init_with_state(state_factory: Callable):
    $CreatureAI.init_state(state_factory)


func move_to_target(target: Food, delta: float) -> void:
    var advised_dir = $MovingAdviser.advised_direction(target.global_position)
    _move_towards(advised_dir, delta)


func move_towards(direction: Vector2, delta: float) -> void:
    #TODO: use MovingAdviser
    _move_towards(direction, delta)


func make_child(init_direction: Vector2) -> Creature:
    return Spawner.spawn_creature(global_position, LeavingCreatureState.make_factory(self, init_direction))


func change_energy(delta: float):
    _energy = clampf(_energy + delta, 0, MAX_ENERGY)


func _process_energy_and_hp(delta: float):
    change_energy(-DEFAULT_ENERGY_CONSUMPTION * delta)

    if _hp <= 0 or _energy <= 0:
        queue_free()


func _move_towards(direction: Vector2, delta: float) -> void:
    global_position += direction * MOVING_SPEED * delta


func _ready() -> void:
    pass


func _process(_delta: float) -> void:
    pass


func _physics_process(delta: float) -> void:
    _process_energy_and_hp(delta)
