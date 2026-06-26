class_name CreatureAI
extends Node2D


@export var creature: Creature


var _current_state: AbstractAiState = null


func _ready() -> void:
    if not _current_state:
        _change_state(SearchingState.new(self))


func _process(_delta: float) -> void:
    pass


func init_state(state_factory: Callable):
    if not _current_state:
        _change_state(state_factory.call(self))


func update(delta: float) -> void:
    if _current_state:
        _current_state.process_state(delta)
        var new_state = _current_state.try_get_next_state_after_process()
        if new_state:
            _change_state(new_state)


func _change_state(new_state: AbstractAiState):
    if _current_state:
        _current_state.leave_state()
        _current_state.state_change_request.disconnect(_change_state)

    while true:
        var actual_state = new_state.try_get_next_state_before_enter()
        if not actual_state:
            break
        new_state = actual_state

    _current_state = new_state
    _current_state.state_change_request.connect(_change_state)
    _current_state.enter_state()
