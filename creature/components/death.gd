class_name Death
extends RefCounted


var _creature: Creature = null
var _died: bool = false


var dead: bool:
    get:
        return _died


func _init(creature: Creature):
    _creature = creature


func on_death():
    if _died:
        return

    _died = true
    Spawner.spawn_meat_food.call_deferred(_creature.global_position)

    EventBus.creature_died.emit(_creature.config)
    _creature.died.emit()
    _creature.queue_free()
