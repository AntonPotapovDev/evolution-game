class_name Breeding
extends RefCounted


var _creature: Creature = null
var _relatives_ids: Array[int] = []


var relatives_ids: Array[int]:
    get:
        return _relatives_ids


func make_child() -> Creature:
    var child_config = Mutator.mutate(_creature.config)
    var state_factory = PostBirthState.make_factory(_creature, true)
    _creature.energy.on_gave_birth()

    var child = Spawner.spawn_creature(_creature.global_position, child_config, state_factory)
    child.breeding.relatives_ids.append(_creature.id)
    relatives_ids.append(child.id)

    return child


func _init(creature: Creature):
    _creature = creature
