class_name ChasingState
extends AbstractAiState


var _target: Creature


func _init(host_ai: CreatureAI, target: Creature):
    super(host_ai)
    _target = target


func try_get_next_state_before_enter() -> AbstractAiState:
    return _try_change_state()


func try_get_next_state_after_process() -> AbstractAiState:
    return _try_change_state()


func leave_state():
    _target = null


func process_state(delta: float):
    if not is_instance_valid(_target):
        return

    actor.attack.attack_if_in_range(_target)
    if not _target.death.dead:
        actor.movement.rush_to_target(_target, delta)


func _try_change_state() -> AbstractAiState:
    if not is_instance_valid(_target):
        return WanderingState.new(ai)

    return null
