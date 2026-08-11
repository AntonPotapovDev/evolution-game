class_name AbstractNeed
extends RefCounted


var _actor: Creature


func _init(actor: Creature):
    _actor = actor


func is_actual() -> bool:
    return false


func update(_delta: float):
    pass


func activate():
    pass


func reset():
    pass
