class_name LeavingCreatureState
extends AbstractAiState


var _other_creature: Creature = null
var _leave_direction: Vector2 = Vector2.ZERO


static func make_factory(other_creature: Creature, leave_direction: Vector2) -> Callable:
    return LeavingCreatureState.new.bind(other_creature, leave_direction)


func _init(ai: CreatureAI, other_creature: Creature, leave_direction: Vector2):
    super(ai)
    _other_creature = other_creature
    _leave_direction = leave_direction


func try_get_next_state_before_enter() -> AbstractAiState:
    return _try_change_state()


func try_get_next_state_after_process() -> AbstractAiState:
    return _try_change_state()


func enter_state():
    if is_instance_valid(_other_creature):
        _other_creature.area_exited.connect(_on_creature_leaved)


func leave_state():
    if is_instance_valid(_other_creature):
        _other_creature.area_exited.disconnect(_on_creature_leaved)


func process_state(delta: float):
    _ai.creature.move_towards(_leave_direction, delta)


func _try_change_state() -> AbstractAiState:
    if not is_instance_valid(_other_creature):
        return SearchingState.new(_ai)
    return null


func _on_creature_leaved(_area: Area2D):
    state_change_request.emit(SearchingState.new(_ai))
