class_name EnergySystem
extends Node


class EnergyConfig extends RefCounted:
    var max_energy: float
    var general_consumption: float
    var movement_consumption: float
    var birth_cost: float


signal out_of_energy


var _energy: float
var _config: EnergyConfig = null


var energy: float:
    get:
        return _energy


var is_out_of_energy: bool:
    get:
        return is_zero_approx(_energy)


func init(config: EnergyConfig):
    if _config:
        return

    _energy = config.birth_cost
    _config = config


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
        out_of_energy.emit()
