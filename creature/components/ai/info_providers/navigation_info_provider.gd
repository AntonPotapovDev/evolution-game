class_name NavigationInfoProvider
extends RefCounted


const WORLD_RADIUS: float = 5000.0
const OFFSET: float = 64.0
const NAVIGATION_RADIUS: float = WORLD_RADIUS - OFFSET

const MIN_ANGLE_STEP: float = deg_to_rad(10.0)
const MAX_ANGLE_STEP: float = deg_to_rad(20.0)


var _creature: Creature


func _init(creature: Creature):
    _creature = creature


func get_naviation_point() -> Vector2:
    var current_angle = _get_angle_from_up(_creature.global_position)
    var next_angle = current_angle + randf_range(MIN_ANGLE_STEP, MAX_ANGLE_STEP)
    var radius = randf_range(0.0, NAVIGATION_RADIUS)
    return Vector2.from_angle(next_angle) * radius


func _get_angle_from_up(vector: Vector2) -> float:
    var angle = Vector2.UP.angle_to(vector)
    if angle < 0.0:
        angle += TAU
    return angle
