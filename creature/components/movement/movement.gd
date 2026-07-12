class_name Movement
extends RefCounted


const TURN_INERTIA: float = 0.3


var _creature: Creature
var _moving_adviser: MovingAdviser

var _facing_direction: Vector2 = Vector2.UP
var _last_moving_direction: Vector2 = Vector2.ZERO
var _moved_prev_tick: bool = false
var _moved_this_tick: bool = false


func _init(creature: Creature, moving_adviser: MovingAdviser):
    _creature = creature
    _moving_adviser = moving_adviser


func update(_delta: float):
    _moved_prev_tick = _moved_this_tick
    _moved_this_tick = false


func move_to_target(target: Node2D, delta: float) -> void:
    var advised_dir = _moving_adviser.advised_direction(target.global_position)
    _move_towards(advised_dir, delta)


func rush_to_target(target: Node2D, delta: float) -> void:
    var direction = (target.global_position - _creature.global_position).normalized()
    _move_towards(direction, delta)


func move_towards(direction: Vector2, delta: float) -> void:
    var advised_dir = _moving_adviser.correct_direction(direction)
    _move_towards(advised_dir, delta)


func _move_towards(direction: Vector2, delta: float) -> void:
    _moved_this_tick = true

    var move_direction = direction
    if _moved_prev_tick:
        move_direction = move_direction.lerp(_last_moving_direction, TURN_INERTIA)

    _creature.global_position += move_direction * _creature.config.movement_speed * delta
    _last_moving_direction = move_direction

    var rotate_angle = _facing_direction.angle_to(move_direction)
    _creature.rotate(rotate_angle)
    _facing_direction = move_direction

    _creature.energy.on_movement(_creature.config.movement_speed, delta)
