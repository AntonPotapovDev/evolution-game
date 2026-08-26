class_name NavigationInfoProvider
extends RefCounted


const WORLD_RADIUS: float = 5000.0
const OFFSET: float = 64.0
const NAVIGATION_RADIUS: float = WORLD_RADIUS - OFFSET

const MIN_ANGLE_STEP: float = deg_to_rad(50.0)
const MAX_ANGLE_STEP: float = deg_to_rad(60.0)

const MAX_RADIUS_STEP: float = 1000.0


var _creature: Creature


func _init(creature: Creature):
    _creature = creature


func get_navigation_point() -> Vector2:
    var creature_pos = _creature.global_position
    if creature_pos.is_zero_approx():
        creature_pos = Vector2.RIGHT * 0.01

    var current_angle = _get_angle_from_right(creature_pos)
    var next_angle = current_angle + randf_range(MIN_ANGLE_STEP, MAX_ANGLE_STEP)

    var current_radius = creature_pos.distance_to(Vector2.ZERO)
    var min_bound = max(current_radius - MAX_RADIUS_STEP, 0.0)
    var max_bound = min(current_radius + MAX_RADIUS_STEP, NAVIGATION_RADIUS)
    var next_radius = randf_range(min_bound, max_bound)

    return Vector2.from_angle(next_angle) * next_radius


func _get_angle_from_right(vector: Vector2) -> float:
    var angle = Vector2.RIGHT.angle_to(vector)
    if angle < 0.0:
        angle += TAU
    return angle
