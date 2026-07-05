class_name PostBirthState
extends AbstractAiState


var _other_creature: Creature = null
var _move_direction: Vector2 = Vector2.ZERO


static func make_factory(other_creature: Creature, is_child: bool) -> Callable:
    return PostBirthState.new.bind(other_creature, is_child)


func _init(ai: CreatureAI, other_creature: Creature, is_child: bool):
    super(ai)
    _other_creature = other_creature
    _move_direction = Vector2.LEFT if is_child else Vector2.RIGHT


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
    _ai.creature.move_towards(_move_direction, delta)


func _try_change_state() -> AbstractAiState:
    if not is_instance_valid(_other_creature):
        return WanderingState.new(_ai)
    return null


func _on_creature_leaved(_area: Area2D):
    state_change_request.emit(WanderingState.new(_ai))
