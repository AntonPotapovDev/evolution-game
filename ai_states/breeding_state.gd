class_name BreedingState
extends AbstractAiState


const ENERGY_THRESHOLD_COEF: float = 0.8


var _child: Creature = null


func _init(ai: CreatureAI):
    super(ai)


static func should_enter_state(creature: Creature) -> bool:
    var threshold = creature.max_energy * ENERGY_THRESHOLD_COEF
    return creature.energy > threshold


func try_get_next_state_before_enter() -> AbstractAiState:
    return null


func try_get_next_state_after_process() -> AbstractAiState:
    if is_instance_valid(_child):
        return PostBirthState.new(_ai, _child, false)

    return WanderingState.new(_ai)


func leave_state():
    _child = null


func process_state(_delta: float):
    _child = _ai.creature.make_child()
    _child.relatives_ids.append(_ai.creature.id)
    _ai.creature.relatives_ids.append(_child.id)
