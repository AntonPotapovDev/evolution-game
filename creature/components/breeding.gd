class_name Breeding
extends RefCounted


var _creature: Creature = null
var _parent: Creature = null
var _relatives_ids: Array[int] = []


var relatives_ids: Array[int]:
    get:
        return _relatives_ids


var parent: Creature:
    get:
        return _parent


func make_child() -> Creature:
    _creature.energy.on_gave_birth()

    var child_config = Mutator.mutate(_creature.config)
    var child = Spawner.spawn_creature(_creature.global_position, child_config)
    child.get_parent().move_child(child, 0)

    child.breeding.relatives_ids.append(_creature.id)
    relatives_ids.append(child.id)

    child.breeding._parent = _creature

    return child


func _init(creature: Creature):
    _creature = creature
