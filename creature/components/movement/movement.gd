class_name Movement
extends RefCounted


class Config extends RefCounted:
    var normal_speed: float
    var sprint_speed: float


enum Policy {
    NORMAL,
    SPRINT_IF_CAN
}


const TURN_INERTIA: float = 0.3


var _creature: Creature = null
var _config: Config = null
var _moving_adviser: MovingAdviser = null

var _facing_direction: Vector2 = Vector2.UP
var _last_moving_direction: Vector2 = Vector2.ZERO
var _moved_prev_tick: bool = false
var _moved_this_tick: bool = false


var config: Config:
    get:
        return _config


func _init(creature: Creature, init_config: Config, moving_adviser: MovingAdviser):
    _creature = creature
    _config = init_config
    _moving_adviser = moving_adviser


func update(_delta: float):
    _moved_prev_tick = _moved_this_tick
    _moved_this_tick = false


func move_to_target(target: Node2D, delta: float, policy: Policy = Policy.NORMAL) -> void:
    var advised_dir = _moving_adviser.advised_direction(target.global_position)
    _move_towards(advised_dir, delta, policy)


func rush_to_target(target: Node2D, delta: float, policy: Policy = Policy.NORMAL) -> void:
    var direction = (target.global_position - _creature.global_position).normalized()
    _move_towards(direction, delta, policy)


func move_to_position(position: Vector2, delta: float, policy: Policy = Policy.NORMAL) -> void:
    var advised_dir = _moving_adviser.advised_direction(position)
    _move_towards(advised_dir, delta, policy)


func move_towards(direction: Vector2, delta: float, policy: Policy = Policy.NORMAL) -> void:
    var advised_dir = _moving_adviser.correct_direction(direction)
    _move_towards(advised_dir, delta, policy)


func _move_towards(direction: Vector2, delta: float, policy: Policy) -> void:
    _moved_this_tick = true

    var move_direction = direction
    if _moved_prev_tick:
        move_direction = move_direction.lerp(_last_moving_direction, TURN_INERTIA)

    var speed = _apply_policy_and_get_speed(policy, delta)

    _creature.global_position += move_direction * speed * delta
    _last_moving_direction = move_direction

    var rotate_angle = _facing_direction.angle_to(move_direction)
    _creature.rotate(rotate_angle)
    _facing_direction = move_direction

    _creature.energy.on_movement(speed, delta)


func _apply_policy_and_get_speed(policy: Policy, delta: float) -> float:
    if policy == Policy.SPRINT_IF_CAN and _creature.stamina.can_use_stamina:
        _creature.stamina.on_try_sprint(delta)
        return _config.sprint_speed
    return _config.normal_speed
