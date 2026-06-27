class_name MovingToTargetState
extends AbstractAiState


var _target: Food
var _background_searching: SearchingState


func _init(ai: CreatureAI, target: Food):
    super(ai)
    _target = target
    _background_searching = SearchingState.new(ai)


func try_get_next_state_before_enter() -> AbstractAiState:
    return _try_change_state()


func try_get_next_state_after_process() -> AbstractAiState:
    return _try_change_state()


func enter_state():
    _background_searching.food_found.connect(_on_closer_target_found)
    _background_searching.enter_state()


func leave_state():
    _background_searching.food_found.disconnect(_on_closer_target_found)
    _background_searching.leave_state()
    _target = null


func process_state(delta: float):
    if is_instance_valid(_target):
        _ai.creature.move_to_target(_target, delta)


func _on_closer_target_found(new_target: Food):
    _target = new_target


func _try_change_state() -> AbstractAiState:
    if BreedingState.should_enter_state(_ai.creature):
        return BreedingState.new(_ai)

    if not is_instance_valid(_target):
        return WanderingState.new(_ai)

    return null
