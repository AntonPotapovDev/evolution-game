class_name LocationInfoProvider
extends RefCounted


const IS_ON_FIELD_THRESHOLD_COEF: float = 0.9


class LocationInfo extends RefCounted:
    var closest_field: Field = null
    var current_field: Field = null


static func get_random_position_on_field(field: Field) -> Vector2:
    var radius = randf_range(0, IS_ON_FIELD_THRESHOLD_COEF * field.radius)
    var angle = randf_range(0, TAU)
    var delta_pos = Vector2.from_angle(angle) * radius
    return field.global_position + delta_pos


var _creature: Creature
var _result_cache: LocationInfo = null


func _init(creature: Creature):
    _creature = creature


func get_info() -> LocationInfo:
    if not _result_cache:
        _result_cache = _get_new_info()
        if _result_cache.closest_field != null and _is_on_field(_result_cache.closest_field):
            _result_cache.current_field = _result_cache.closest_field
    return _result_cache


func update():
    _result_cache = null


func _get_new_info() -> LocationInfo:
    var info = LocationInfo.new()
    info.closest_field = _find_closest_field()
    return info


func _is_on_field(closest_field: Field) -> bool:
    var radius = closest_field.radius
    var distance = _creature.global_position.distance_to(closest_field.global_position)
    return distance < IS_ON_FIELD_THRESHOLD_COEF * radius


func _find_closest_field() -> Field:
    var min_distance = INF
    var result: Field = null

    for field in _creature.memory.remembered_fields:
        var distance = _creature.global_position.distance_to(field.global_position)
        if distance < min_distance:
            result = field
            min_distance = distance
            continue

    return result
