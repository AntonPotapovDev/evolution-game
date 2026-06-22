@abstract
class_name AbstractAiState
extends RefCounted


var _ai: CreatureAI


@warning_ignore("unused_signal")
signal state_change_request(new_state: AbstractAiState)


func _init(ai: CreatureAI):
    _ai = ai


func try_get_next_state_before_enter() -> AbstractAiState:
    return null


func try_get_next_state_after_process() -> AbstractAiState:
    return null


func enter_state():
    pass


func leave_state():
    pass


func process_state(_delta: float):
    pass
