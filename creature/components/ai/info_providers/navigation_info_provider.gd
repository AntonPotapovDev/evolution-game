class_name NavigationInfoProvider
extends RefCounted


const WORLD_RADIUS: float = 5000.0
const OFFSET: float = 64.0
const NAVIGATION_RADIUS: float = WORLD_RADIUS - OFFSET

const MIN_ANGLE_STEP: float = deg_to_rad(50.0)
const MAX_ANGLE_STEP: float = deg_to_rad(60.0)

const MAX_RADIUS_STEP: float = 1000.0


var _creature: Creature

var _angle_sign: int = 0
var _points: Array[Vector2] = []


func _init(creature: Creature):
    _creature = creature


func init_path():
    var zero_point = _get_zero_point()
    var first_point = _get_first_point(zero_point)

    _update_angle_sign(zero_point, first_point)

    var second_point = _get_second_point(zero_point, first_point)

    _points = [ first_point, second_point ] as Array[Vector2]


func reset_path():
    _angle_sign = 0
    _points = []


func get_next_point() -> Vector2:
    if _points.size() > 0:
        return _points.pop_front()

    return _get_next_point()


func _get_zero_point() -> Vector2:
    var zero_point = _creature.global_position
    if zero_point.is_zero_approx():
        zero_point = Vector2.RIGHT * 0.1
    return zero_point


func _get_first_point(zero_point: Vector2) -> Vector2:
    var radius = randf_range(0.0, NAVIGATION_RADIUS)
    var angle = randf_range(0.0, TAU)
    var first_point = Vector2.from_angle(angle) * radius

    var distance = zero_point.distance_to(first_point)
    if distance > MAX_RADIUS_STEP or distance < MAX_RADIUS_STEP / 2:
        var direction = zero_point.direction_to(first_point)
        var local_radius = randf_range(MAX_RADIUS_STEP / 2, MAX_RADIUS_STEP)
        first_point = zero_point + local_radius * direction

    return first_point


func _get_second_point(zero_point: Vector2, first_point: Vector2) -> Vector2:
    var angle = _get_next_point_angle(first_point)
    var radius = _get_second_point_radius(zero_point, first_point)
    return Vector2.from_angle(angle) * radius


func _get_second_point_radius(zero_point: Vector2, first_point: Vector2) -> float:
    var zero_point_radius = zero_point.distance_to(Vector2.ZERO)
    var first_point_radius = first_point.distance_to(Vector2.ZERO)

    var delta_sign = 1 if first_point_radius > zero_point_radius else -1

    var min_bound = first_point_radius
    var max_bound = clampf(first_point_radius + delta_sign * (MAX_RADIUS_STEP / 2), 0.0, NAVIGATION_RADIUS)

    if min_bound > max_bound:
        var temp = max_bound
        max_bound = min_bound
        min_bound = temp

    return randf_range(min_bound, max_bound)


func _get_next_point() -> Vector2:
    var zero_point = _get_zero_point()

    var zero_point_radius = zero_point.distance_to(Vector2.ZERO)

    var min_bound = max(zero_point_radius - MAX_RADIUS_STEP, 0.0)
    var max_bound = min(zero_point_radius + MAX_RADIUS_STEP, NAVIGATION_RADIUS)
    var next_point_radius = randf_range(min_bound, max_bound)

    var next_point_angle = _get_next_point_angle(zero_point)

    return Vector2.from_angle(next_point_angle) * next_point_radius


func _get_next_point_angle(prev_point: Vector2) -> float:
    var prev_point_angle = _get_angle_from_right(prev_point)
    return prev_point_angle + _angle_sign * randf_range(MIN_ANGLE_STEP, MAX_ANGLE_STEP)


func _update_angle_sign(zero_point: Vector2, first_point: Vector2):
    _angle_sign = 1 if zero_point.angle_to(first_point) > 0.0 else -1


func _get_angle_from_right(vector: Vector2) -> float:
    var angle = Vector2.RIGHT.angle_to(vector)
    if angle < 0.0:
        angle += TAU
    return angle
