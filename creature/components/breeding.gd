class_name Breeding
extends RefCounted


var _creature: Creature = null
var _parent: Creature = null
var _relatives_ids: Array[int] = []

var _child_energy_reserve: float = 0.0


var relatives_ids: Array[int]:
    get:
        return _relatives_ids


var parent: Creature:
    get:
        return _parent


var ready_for_breeding: bool:
    get:
        return is_equal_approx(_child_energy_reserve, DefaultValues.STARTING_ENERGY)


var child_energy_reserve: float:
    get:
        return _child_energy_reserve


func gain_energy(income_energy: float):
    _child_energy_reserve = min(_child_energy_reserve + income_energy, DefaultValues.STARTING_ENERGY)


func make_child() -> Creature:
    if not ready_for_breeding:
        return null

    _child_energy_reserve = 0.0

    var child_config = Mutator.mutate(_creature.config)
    var child = Spawner.spawn_creature(_creature.global_position, child_config)
    child.get_parent().move_child(child, 0)

    child.breeding.relatives_ids.append(_creature.id)
    relatives_ids.append(child.id)

    child.breeding._parent = _creature

    return child


func _init(creature: Creature):
    _creature = creature
