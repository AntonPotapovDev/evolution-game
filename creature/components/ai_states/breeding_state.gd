class_name BreedingState
extends AbstractAiState


const ENERGY_THRESHOLD_COEF: float = 0.8


var _child: Creature = null


func _init(host_ai: CreatureAI):
    super(host_ai)


static func should_enter_state(creature: Creature) -> bool:
    var threshold = creature.energy.config.max_energy * ENERGY_THRESHOLD_COEF
    return creature.energy.current_energy > threshold


func try_get_next_state_before_enter() -> AbstractAiState:
    return null


func try_get_next_state_after_process() -> AbstractAiState:
    if is_instance_valid(_child):
        return PostBirthState.new(ai, _child, false)

    return WanderingState.new(ai)


func leave_state():
    _child = null


func process_state(_delta: float):
    _child = actor.breeding.make_child()
