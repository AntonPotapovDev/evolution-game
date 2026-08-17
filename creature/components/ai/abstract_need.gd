class_name AbstractNeed
extends RefCounted


var _actor: Creature


func _init(actor: Creature):
    _actor = actor


func is_actual() -> bool:
    return false


func can_interrupt() -> bool:
    return true


func update(_delta: float):
    pass


func activate():
    pass


func reset():
    pass
