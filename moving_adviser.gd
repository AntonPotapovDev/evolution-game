class_name MovingAdviser
extends Node2D


const FRONT_RAY_LENGTH: float = 600.0
const MIDDLE_RAY_LENGTH: float = 600.0
const SIDE_RAY_LENGTH: float = 300.0
const MIDDLE_RAY_PAIRS_COUNT: int = 3


@export var creature: Creature
@export var debug_mode: bool


var _debug_info: Array[Dictionary]


func advised_direction(desired_pos: Vector2) -> Vector2:
    var orig_pos = creature.global_position
    var main_dir = (desired_pos - orig_pos).normalized()

    var advise = main_dir
    advise += _cast_front_and_middle_rays(orig_pos, main_dir, desired_pos)
    advise += _cast_side_rays(orig_pos, main_dir)

    if debug_mode:
        queue_redraw()

    return advise.normalized()


func _cast_front_and_middle_rays(orig_pos: Vector2, main_dir: Vector2, desired_pos: Vector2) -> Vector2:
    var space_state = get_world_2d().direct_space_state
    var advise = Vector2.ZERO

    var front_ray = _make_front_ray(orig_pos, main_dir)
    var front_result = space_state.intersect_ray(front_ray["query"])

    if front_result:
        var hit_dist = orig_pos.distance_to(front_result["position"])
        if hit_dist <= orig_pos.distance_to(desired_pos):
            advise += _calculate_perp_avoidance(front_ray, orig_pos, front_result["position"])

    for middle_ray in _make_middle_rays(orig_pos, main_dir):
        var result = space_state.intersect_ray(middle_ray["query"])
        if result:
            advise += _calculate_perp_avoidance(middle_ray, orig_pos, result["position"])

    return advise


func _cast_side_rays(orig_pos: Vector2, main_dir: Vector2) -> Vector2:
    var space_state = get_world_2d().direct_space_state
    var advise = Vector2.ZERO

    for side_ray in _make_side_rays(orig_pos, main_dir):
        var result = space_state.intersect_ray(side_ray["query"])
        if result:
            var penalty = _calculate_penalty(orig_pos, result["position"], side_ray["length"])
            advise += -penalty * side_ray["direction"]
    return advise


func _make_front_ray(orig_pos: Vector2, main_dir: Vector2) -> Dictionary:
    return _make_ray(orig_pos, main_dir, 0, FRONT_RAY_LENGTH)


func _make_middle_rays(orig_pos: Vector2, main_dir: Vector2) -> Array[Dictionary]:
    var rays: Array[Dictionary] = []

    var angle_step = 90.0 / (MIDDLE_RAY_PAIRS_COUNT + 1)
    var curr_angle = 0.0
    for _i in range(MIDDLE_RAY_PAIRS_COUNT):
        curr_angle += angle_step
        rays.append(_make_ray(orig_pos, main_dir, curr_angle, MIDDLE_RAY_LENGTH))
        rays.append(_make_ray(orig_pos, main_dir, -curr_angle, MIDDLE_RAY_LENGTH))

    return rays


func _make_side_rays(orig_pos: Vector2, main_dir: Vector2) -> Array[Dictionary]:
    return [
        _make_ray(orig_pos, main_dir, 90, SIDE_RAY_LENGTH),
        _make_ray(orig_pos, main_dir, -90, SIDE_RAY_LENGTH),
    ]


func _calculate_perp_avoidance(ray: Dictionary, orig_pos: Vector2, hit_pos: Vector2) -> Vector2:
    var ray_dir = ray["direction"]
    var perp = Vector2(-ray_dir.y, ray_dir.x)
    var avoid_vec = -perp if ray["angle"] > 0 else perp

    var penalty = _calculate_penalty(orig_pos, hit_pos, ray["length"])
    return penalty * avoid_vec


func _calculate_penalty(orig_pos: Vector2, hit_pos: Vector2, ray_length: float) -> float:
    var distance = orig_pos.distance_to(hit_pos)
    return 2 * (1.0 - pow(distance / ray_length, 4))


func _make_ray(orig_pos: Vector2, main_dir: Vector2, angle: float, length: float) -> Dictionary:
    var angle_rad = deg_to_rad(angle)
    var ray_dir = main_dir.rotated(angle_rad)
    var ray_vector = ray_dir * length
    var ray_query = PhysicsRayQueryParameters2D.create(orig_pos, orig_pos + ray_vector)
    ray_query.collide_with_areas = true
    ray_query.collide_with_bodies = false
    ray_query.exclude = [creature]
    ray_query.collision_mask = 2

    if debug_mode:
        _debug_info.append({
            "from": ray_query.from,
            "to": ray_query.to
        })

    return {
        "query": ray_query,
        "direction": ray_dir,
        "angle": angle,
        "length": length
    }


func _draw() -> void:
    for ray in _debug_info:
        var from = ray["from"]
        var to = ray["to"]
        draw_line(to_local(from), to_local(to), Color.RED, 2.0)
    _debug_info.clear()
