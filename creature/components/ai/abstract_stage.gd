class_name AbstractStage
extends RefCounted


enum Result {
    NONE,
    SUCCESS,
    FAIL
}


var _actor: Creature


func _init(actor: Creature):
    _actor = actor


func update(_delta: float) -> Result:
    return Result.NONE


func start():
    pass


func stop():
    pass
