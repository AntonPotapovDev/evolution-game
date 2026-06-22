class_name MovingToTargetState
extends AbstractAiState


var _target: Food


func _init(ai: CreatureAI, target: Food):
    super(ai)
    _target = target


func try_get_next_state_before_enter() -> AbstractAiState:
    return _try_change_state()


func try_get_next_state_after_process() -> AbstractAiState:
    return _try_change_state()


func enter_state():
    pass


func leave_state():
    _target = null


func process_state(delta: float):
    if is_instance_valid(_target):
        _ai.creature.move_to_target(_target, delta)


func _try_change_state() -> AbstractAiState:
    if BreedingState.should_enter_state(_ai.creature):
        return BreedingState.new(_ai)

    if not is_instance_valid(_target):
        return SearchingState.new(_ai)

    return null
