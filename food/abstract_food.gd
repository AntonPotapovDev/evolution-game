@abstract class_name AbstractFood
extends Area2D


var _energy_boost: float = 0.0
var _is_consumed: bool = false
var _type: StringName = Groups.NONE


var type: StringName:
    get:
        return _type


var is_consumed: bool:
    get:
        return _is_consumed


func consume(_consuming_creature: Creature):
    pass


func _consume(consuming_creature: Creature, energy_mult: float):
    if _is_consumed:
        return

    consuming_creature.energy.gain(_energy_boost * energy_mult)
    _is_consumed = true

    queue_free()
