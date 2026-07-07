class_name Creature
extends Area2D


const TURN_INERTIA: float = 0.3


@onready var _energy_system: EnergySystem = $EnergySystem
@onready var _ai: CreatureAI = $CreatureAI
@onready var _moving_adviser: MovingAdviser = $MovingAdviser
@onready var _attack: Attack = $Attack


var _id: int

var _hp: int = DefaultValues.MAX_HP
var _died: bool = false
var _relatives_ids: Array[int] = []

var _config: CreatureConfig = null

var _facing_direction: Vector2 = Vector2.UP
var _last_moving_direction: Vector2 = Vector2.ZERO
var _moved_prev_tick: bool = false
var _moved_this_tick: bool = false


var id: int:
    get:
        return _id


var energy: float:
    get:
        return _energy_system.energy


var max_energy: float:
    get:
        return _config.energy_config.max_energy


var dead: bool:
    get:
        return _died


var diet: Array[StringName]:
    get:
        return _config.diet


var is_hunter: bool:
    get:
        return _config.is_hunter


var relatives_ids: Array[int]:
    get:
        return _relatives_ids


func init(config: CreatureConfig, new_id: int, initial_state_factory: Callable):
    if _config:
        return

    _id = new_id
    _config = config

    $EnergySystem.init(config.energy_config)
    $CreatureAI.init_state(initial_state_factory)


func move_to_target(target: Node2D, delta: float) -> void:
    var advised_dir = _moving_adviser.advised_direction(target.global_position)
    _move_towards(advised_dir, delta)


func rush_to_target(target: Node2D, delta: float) -> void:
    var direction = (target.global_position - global_position).normalized()
    _move_towards(direction, delta)


func move_towards(direction: Vector2, delta: float) -> void:
    var advised_dir = _moving_adviser.correct_direction(direction)
    _move_towards(advised_dir, delta)


func make_child() -> Creature:
    var config = Mutator.mutate(_config)
    var state_factory = PostBirthState.make_factory(self, true)
    _energy_system.on_gave_birth()
    return Spawner.spawn_creature(global_position, config, state_factory)


func gain_energy(amount: float):
    _energy_system.gain(amount)


func do_attack():
    _attack.do_attack()


func attack_if_in_range(creature: Creature):
    if _attack.in_attack_range(creature):
        do_attack()


func take_damage(damage: int):
    _hp = max(0, _hp - damage)
    if _hp == 0:
        _on_death()


func _on_death():
    if _died:
        return

    _died = true
    Spawner.spawn_meat_food.call_deferred(global_position)
    EventBus.creature_died.emit(_config)
    queue_free()


func _move_towards(direction: Vector2, delta: float) -> void:
    _moved_this_tick = true

    var move_direction = direction
    if _moved_prev_tick:
        move_direction = move_direction.lerp(_last_moving_direction, TURN_INERTIA)

    global_position += move_direction * _config.movement_speed * delta
    _last_moving_direction = move_direction

    var rotate_angle = _facing_direction.angle_to(move_direction)
    rotate(rotate_angle)
    _facing_direction = move_direction

    _energy_system.on_movement(_config.movement_speed, delta)


func _ready() -> void:
    z_index = Layers.CREATURE
    add_to_group(Groups.CREATURE)


func _process(_delta: float) -> void:
    pass


func _physics_process(delta: float) -> void:
    if _died:
        return

    _energy_system.update(delta)
    if _died:
        return

    _ai.update(delta)

    _moved_prev_tick = _moved_this_tick
    _moved_this_tick = false


func _on_area_entered(area: Area2D) -> void:
    var food = area as AbstractFood
    if not food:
        return

    if _config.diet.has(food.type):
        food.consume(self)


func _on_out_of_energy():
    _on_death()
