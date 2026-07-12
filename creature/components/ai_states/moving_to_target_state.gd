class_name MovingToTargetState
extends AbstractAiState


var _target: AbstractFood
var _background_searching: SearchingState


func _init(host_ai: CreatureAI, target: AbstractFood):
    super(host_ai)
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
        actor.movement.move_to_target(_target, delta)


func _try_change_state() -> AbstractAiState:
    if BreedingState.should_enter_state(actor):
        return BreedingState.new(ai)

    if not is_instance_valid(_target):
        return WanderingState.new(ai)

    return null


func _on_closer_target_found(new_target: AbstractFood):
    if _target != new_target:
        _target = new_target
