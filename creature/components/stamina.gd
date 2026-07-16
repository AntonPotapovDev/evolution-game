class_name Stamina
extends RefCounted


class Config extends RefCounted:
    var max_stamina: float
    var stamina_restore_rate: float
    var sprint_consumption: float


var _creature: Creature = null
var _stamina: float = 0.0
var _config: Config = null

var _used_prev_tick: bool = false
var _used_this_tick: bool = false
var _is_resting: bool = false


var config: Config:
    get:
        return _config


var current_stamina: float:
    get:
        return _stamina


var can_use_stamina: bool:
    get:
        return not _is_resting


func _init(creature: Creature, init_config: Config):
    _creature = creature
    _stamina = init_config.max_stamina
    _config = init_config


func update(delta: float):
    if not _used_prev_tick and not _used_this_tick:
        _change_stamina(_config.stamina_restore_rate * delta)

    _used_prev_tick = _used_this_tick
    _used_this_tick = false


func on_try_sprint(delta: float):
    if not can_use_stamina:
        return
    _change_stamina(_config.sprint_consumption * -delta)


func _change_stamina(delta_stamina: float):
    if delta_stamina > 0.0:
        _used_this_tick = true

    _stamina = clampf(_stamina + delta_stamina, 0.0, _config.max_stamina)
    if is_zero_approx(_stamina):
        _is_resting = true
    elif is_equal_approx(_stamina, _config.max_stamina):
        _is_resting = false
