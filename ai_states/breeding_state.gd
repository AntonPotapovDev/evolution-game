class_name BreedingState
extends AbstractAiState


const ENERGY_THRESHOLD: float = 0.8 * Creature.MAX_ENERGY
const ENERGY_COST: float = 0.4 * Creature.MAX_ENERGY


var _child: Creature = null


func _init(ai: CreatureAI):
    super(ai)


static func should_enter_state(creature: Creature) -> bool:
    return creature.energy >= ENERGY_THRESHOLD


func try_get_next_state_before_enter() -> AbstractAiState:
    return null


func try_get_next_state_after_process() -> AbstractAiState:
    if is_instance_valid(_child):
        return LeavingCreatureState.new(_ai, _child, Vector2.LEFT, false)

    return WanderingState.new(_ai)


func enter_state():
    pass


func leave_state():
    _child = null
    pass


func process_state(_delta: float):
    _ai.creature.change_energy(-ENERGY_COST)
    _child = _ai.creature.make_child(Vector2.RIGHT)
    _child.relatives_ids.append(_ai.creature.id)
    _ai.creature.relatives_ids.append(_child.id)
