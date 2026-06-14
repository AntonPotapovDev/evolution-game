class_name MovingAdviser
extends Node2D

#TODO: need refactoring

const RAY_PAIRS_COUNT: int = 4
const RAYS_HALF_SPREAD: float = 80.0
const RAY_LENGTH: float = 800.0


@export var creature: Creature
@export var debug_mode: bool


var _debug_info: Array[Dictionary]


#func advised_direction(desired_pos: Vector2) -> Vector2:
    #var space_state = get_world_2d().direct_space_state
#
    #var rays = _make_rays(desired_pos)
#
    #var weighted_sum = Vector2.ZERO
#
    #for ray in rays:
        #var result = space_state.intersect_ray(ray["ray"])
        #var penalty = _calculate_penalty(result)
#
        #var score = max(0.0, ray["interest"] - penalty)
        #weighted_sum += score * ray["direction"]
#
    #if debug_mode:
        #queue_redraw()
#
    #return weighted_sum.normalized()


func advised_direction(desired_pos: Vector2) -> Vector2:
    var space_state = get_world_2d().direct_space_state

    var rays = _make_rays(desired_pos)
    
    var best_score = 0.0
    var best_idx = 0

    for i in range(rays.size()):
        var ray = rays[i]
        var result = space_state.intersect_ray(ray["ray"])
        var penalty = _calculate_penalty(result)
        var score = max(0.0, ray["interest"] - penalty)

        if score > best_score:
            best_score = score
            best_idx = i

    var weighted_sum = Vector2.ZERO

    for i in range(rays.size()):
        var ray = rays[i]
        var result = space_state.intersect_ray(ray["ray"])
        var penalty = _calculate_penalty(result)
        var score = max(0.0, ray["interest"] - penalty)
        if i == best_idx:
            score *= 10.0
        elif penalty == 0.0:
            score *= 10.0

        weighted_sum += score * ray["direction"]

    if debug_mode:
        queue_redraw()

    return weighted_sum.normalized()


func _make_ray(orig_pos: Vector2, main_dir: Vector2, angle: float) -> Dictionary:
    var angle_rad = deg_to_rad(angle)
    var ray_dir = main_dir.rotated(angle_rad)
    var ray_vector = ray_dir * RAY_LENGTH
    var ray_query = PhysicsRayQueryParameters2D.create(orig_pos, orig_pos + ray_vector)
    ray_query.collide_with_areas = true
    ray_query.collide_with_bodies = false
    ray_query.exclude = [creature]
    ray_query.collision_mask = 2

    if debug_mode:
        _debug_info.append({
            "from": ray_query.from,
            "to": ray_query.to,
            "is_dir": false
        })

    var interest = 1.0
    #var interest = cos(angle_rad)
    #var interest = max(0.0, 1.0 - abs(angle) / RAYS_HALF_SPREAD)

    return {
        "ray": ray_query,
        "direction": ray_dir,
        "interest": interest,
    }


func _make_rays(desired_pos: Vector2) -> Array[Dictionary]:
    var orig_pos = creature.global_position
    var main_dir = (desired_pos - orig_pos).normalized()

    var rays: Array[Dictionary] = [ _make_ray(orig_pos, main_dir, 0) ]

    var angle_step = RAYS_HALF_SPREAD / RAY_PAIRS_COUNT
    var curr_angle = 0.0
    for _i in range(RAY_PAIRS_COUNT):
        curr_angle += angle_step
        rays.append(_make_ray(orig_pos, main_dir, curr_angle))
        rays.append(_make_ray(orig_pos, main_dir, -curr_angle))

    return rays


func _calculate_penalty(ray_intersect_result: Dictionary) -> float:
    if not ray_intersect_result:
        return 0.0

    var distance = creature.global_position.distance_to(ray_intersect_result["position"])
    return 1.0 - distance / RAY_LENGTH


func _draw() -> void:
    for ray in _debug_info:
        var from = ray["from"]
        var to = ray["to"]
        draw_line(to_local(from), to_local(to), Color.RED, 2.0)
    _debug_info.clear()
