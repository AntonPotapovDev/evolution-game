class_name Energy
extends RefCounted


class Config extends RefCounted:
    var max_energy: float
    var general_consumption: float
    var movement_consumption: float
    var birth_cost: float


var _creature: Creature = null
var _energy: float = 0.0
var _config: Config = null


var config: Config:
    get:
        return _config


var current_energy: float:
    get:
        return _energy


var is_out_of_energy: bool:
    get:
        return is_zero_approx(_energy)


func _init(creature: Creature, init_config: Config):
    _creature = creature
    _energy = init_config.birth_cost
    _config = init_config


func update(delta: float):
    var delta_energy = _config.general_consumption * delta
    _change_energy(-delta_energy)


func on_movement(speed: float, delta: float):
    var delta_energy = _config.movement_consumption * speed * delta
    _change_energy(-delta_energy)


func on_gave_birth():
    _change_energy(-_config.birth_cost)


func gain(amount: float):
    _change_energy(amount)


func _change_energy(delta_energy: float):
    _energy = clampf(_energy + delta_energy, 0.0, _config.max_energy)
    if is_out_of_energy:
        _energy = 0.0
        _creature.death.on_death()
