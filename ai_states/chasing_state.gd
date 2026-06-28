class_name ChasingState
extends AbstractAiState


var _target: Creature


func _init(ai: CreatureAI, target: Creature):
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
    if not is_instance_valid(_target):
        return

    _ai.creature.attack_if_in_range(_target)
    if not _target.dead:
        _ai.creature.rush_to_target(_target, delta)


func _try_change_state() -> AbstractAiState:
    if not is_instance_valid(_target):
        return WanderingState.new(_ai)

    return null
