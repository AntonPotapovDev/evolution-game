class_name AbstractStageFactory
extends RefCounted


var _actor: Creature


func _init(actor: Creature):
    _actor = actor


func make() -> AbstractStage:
    return null
