class_name CreatureAI
extends RefCounted


var _creature: Creature
var _current_state: AbstractAiState = null


var creature: Creature:
    get:
        return _creature


func _init(owner: Creature, state_factory: Callable):
    _creature = owner
    _change_state(state_factory.call(self))


func deinit() -> void:
    _clean_state()


func update(delta: float) -> void:
    if not _current_state:
        return

    _current_state.process_state(delta)
    var new_state = _current_state.try_get_next_state_after_process()
    if new_state:
        _change_state(new_state)


func _change_state(new_state: AbstractAiState):
    _clean_state()

    while true:
        var actual_state = new_state.try_get_next_state_before_enter()
        if not actual_state:
            break
        new_state = actual_state

    _current_state = new_state
    _current_state.enter_state()
    _current_state.state_change_request.connect(_change_state)


func _clean_state():
    if not _current_state:
        return

    if _current_state.state_change_request.is_connected(_change_state):
        _current_state.state_change_request.disconnect(_change_state)
    _current_state.leave_state()
    _current_state = null
