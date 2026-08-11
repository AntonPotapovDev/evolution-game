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


func consume(consuming_creature: Creature):
    if _is_consumed:
        return

    consuming_creature.energy.gain(_energy_boost)
    _is_consumed = true

    queue_free()
