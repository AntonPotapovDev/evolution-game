class_name MovingAdviser
extends Node2D


class RaycastInfo extends RefCounted:
    var result: Dictionary = {}
    var direction: Vector2 = Vector2.ZERO


class AdviseCache extends RefCounted:
    var rays: Dictionary
    var _origin_position: Vector2

    var main_direction: Vector2:
        get:
            return rays[0].direction if rays.has(0) else Vector2.ZERO
            
    var origin_position: Vector2:
        get:
            return _origin_position

    func _init(init_origin_position: Vector2):
        _origin_position = init_origin_position
        rays = {}


const RAY_LENGTH: float = 600.0
const RAY_PAIRS_COUNT: int = 4
const NO_PENALTY_THRESHOLD: float = 0.8


static var _ray_angles: Dictionary
static var _angles_order: Array[int]


@export var creature: Creature
@export var debug_mode: bool = false


@onready var _space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state


var _debug_info: Array[Dictionary]


static func _static_init() -> void:
    _ray_angles.set(0, 0.0)
    _angles_order.append(0)

    var angle_step = 90.0 / RAY_PAIRS_COUNT
    var curr_angle = 0.0
    for i in range(RAY_PAIRS_COUNT):
        curr_angle += angle_step
        _ray_angles.set(i + 1, curr_angle)
        _ray_angles.set(-i - 1, -curr_angle)
        _angles_order.append(i + 1)
        _angles_order.append(-i - 1)


func correct_direction(direction: Vector2) -> Vector2:
    var cache = AdviseCache.new(creature.global_position)
    var result_direction =  _find_open_direction(direction, cache)
    _queue_debug_redraw(cache)
    return result_direction


func advised_direction(desired_position: Vector2) -> Vector2:
    var cache = AdviseCache.new(creature.global_position)

    _find_direction_to_target(desired_position, cache)
    _fill_advise_cache(cache)

    var advise = Vector2.ZERO

    for idx in cache.rays:
        if _is_side_ray_idx(idx):
            continue

        var ray = cache.rays[idx]
        if ray.result.is_empty():
            continue

        var penalty = _calculate_penalty(ray)
        advise += cache.main_direction - penalty * ray.direction

    _queue_debug_redraw(cache)

    return advise.normalized() if not advise.is_zero_approx() else cache.main_direction


func _find_open_direction(base_direction: Vector2, cache: AdviseCache) -> Vector2:
    var max_idx = 0
    var max_distance = -INF
    for idx in _angles_order:
        if cache.rays.has(idx):
            continue

        var ray_angle = _ray_angles[idx]
        var ray = _cast_ray(cache.origin_position, base_direction, ray_angle)
        cache.rays.set(idx, ray)

        if ray.result.is_empty():
            _rebase_main_direction(idx, cache)
            return cache.main_direction

        if max_distance < ray.result["distance"]:
            max_distance = ray.result["distance"]
            max_idx = idx

    _rebase_main_direction(max_idx, cache)
    return cache.main_direction


func _find_direction_to_target(desired_position: Vector2, cache: AdviseCache):
    var main_direction = (desired_position - cache.origin_position).normalized()

    var front_ray = _cast_ray(cache.origin_position, main_direction, 0)
    cache.rays.set(0, front_ray)

    if front_ray.result.is_empty():
        return

    var distance_to_target = cache.origin_position.distance_to(desired_position)
    if front_ray.result["distance"] > distance_to_target:
        return

    _find_open_direction(main_direction, cache)


func _rebase_main_direction(angle_idx: int, cache: AdviseCache):
    assert(cache.rays.has(angle_idx), "Incorrect base angle")
    var new_rays = {}

    for idx in cache.rays:
        var new_idx = idx - angle_idx
        if not _ray_angles.has(new_idx):
            continue

        new_rays.set(new_idx, cache.rays[idx])

    cache.rays = new_rays


func _fill_advise_cache(cache: AdviseCache):
    for idx in _angles_order:
        if cache.rays.has(idx):
            continue

        var ray_angle = _ray_angles[idx]
        var new_ray = _cast_ray(cache.origin_position, cache.main_direction, ray_angle)
        cache.rays.set(idx, new_ray)


func _calculate_penalty(ray_info: RaycastInfo) -> float:
    var distance_to_length = ray_info.result["distance"] / RAY_LENGTH
    if distance_to_length > NO_PENALTY_THRESHOLD:
        return 0.0

    return 1.0 - distance_to_length


func _is_side_ray_idx(idx: int) -> bool:
    return abs(idx) == RAY_PAIRS_COUNT


func _cast_ray(from: Vector2, main_dir: Vector2, angle: float) -> RaycastInfo:
    var angle_rad = deg_to_rad(angle)
    var ray_dir = main_dir.rotated(angle_rad)
    var ray_query = PhysicsRayQueryParameters2D.create(from, from + ray_dir * RAY_LENGTH)
    ray_query.collide_with_areas = true
    ray_query.collide_with_bodies = false
    ray_query.exclude = [creature]
    ray_query.collision_mask = 2

    var result = _space_state.intersect_ray(ray_query)

    if not result.is_empty():
        result["distance"] = from.distance_to(result["position"])

    var ray = RaycastInfo.new()
    ray.result = result
    ray.direction = ray_dir

    return ray


func _queue_debug_redraw(cache: AdviseCache):
    if not debug_mode:
        return

    var from = cache.origin_position

    for idx in cache.rays:
        var debug_ray = {
            "from": from,
            "to": from + cache.rays[idx].direction * RAY_LENGTH
        }
        _debug_info.append(debug_ray)
    queue_redraw()


func _draw() -> void:
    if not debug_mode:
        return

    for ray in _debug_info:
        draw_line(to_local(ray["from"]), to_local(ray["to"]), Color.RED, 2.0)
    _debug_info.clear()
