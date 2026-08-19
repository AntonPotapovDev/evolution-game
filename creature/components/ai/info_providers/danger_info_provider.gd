class_name DangerInfoProvider
extends RefCounted


const FORGET_TIMEOUT: float = 2.0


class SeenDanger extends RefCounted:
    var last_seen_position: Vector2
    var time_since_seen: float


class DangerInfo extends RefCounted:
    var _dangers: Dictionary = {}

    var has_dangers: bool:
        get:
            return _dangers.size() > 0

    var positions: Array[Vector2]:
        get:
            var result = [] as Array[Vector2]
            for danger in _dangers.values():
                result.append(danger.last_seen_position)
            return result


var _creature: Creature
var _result: DangerInfo


func _init(creature: Creature):
    _creature = creature
    _result = DangerInfo.new()


func get_info() -> DangerInfo:
    return _result


func update(delta: float):
    _filter_seen_dangers(delta)
    _renew_seen_dangers()


func _filter_seen_dangers(delta: float):
    for id in _result._dangers.keys():
        var danger = _result._dangers[id] as SeenDanger
        danger.time_since_seen += delta
        if danger.time_since_seen > FORGET_TIMEOUT:
            _result._dangers.erase(id)


func _renew_seen_dangers():
    for creature in _find_dangers():
        var new_info = SeenDanger.new()
        new_info.last_seen_position = creature.global_position
        new_info.time_since_seen = 0.0
        _result._dangers.set(creature.id, new_info)


func _find_dangers() -> Array[Creature]:
    return _creature.vision.seen_creatures.filter(
        func(creature: Creature): return not _is_relative(creature) and _is_danger(creature))


func _is_danger(creature: Creature) -> bool:
    if _is_relative(creature):
        return false
    return not _is_hunter(_creature) and _is_hunter(creature)


func _is_relative(creature: Creature) -> bool:
    return _creature.breeding.relatives_ids.has(creature.id)


func _is_hunter(creature: Creature) -> bool:
    return creature.config.is_hunter
