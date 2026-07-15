class_name WanderingState
extends AbstractAiState


const CHANGE_DIRECTON_RATE: float = 4.0


var _background_searching: SearchingState
var _direction: Vector2
var _timer: SceneTreeTimer = null


static func make_factory() -> Callable:
    return WanderingState.new


func _init(host_ai: CreatureAI):
    super(host_ai)
    _background_searching = SearchingState.new(ai)
    _set_random_direction()


func try_get_next_state_before_enter() -> AbstractAiState:
    return _background_searching.try_get_next_state_before_enter()


func try_get_next_state_after_process() -> AbstractAiState:
    return _background_searching.try_get_next_state_after_process()


func enter_state():
    _start_timer()

    _background_searching.state_change_request.connect(_on_searching_state_change)
    _background_searching.enter_state()


func leave_state():
    _background_searching.state_change_request.disconnect(_on_searching_state_change)
    _background_searching.leave_state()

    _reset_timer()


func process_state(delta: float):
    actor.movement.move_towards(_direction, delta)


func _rotate_direction_random():
    _direction = _direction.rotated(randf_range(PI / 2, PI))


func _set_random_direction():
    var dir = Vector2.UP
    _direction = dir.rotated(randf_range(0, TAU))


func _start_timer():
    _timer = actor.get_tree().create_timer(CHANGE_DIRECTON_RATE)
    _timer.timeout.connect(_on_timer_timeout)


func _reset_timer():
    if _timer:
        _timer.timeout.disconnect(_on_timer_timeout)
        _timer = null


func _on_searching_state_change(new_state: AbstractAiState):
    state_change_request.emit(new_state)


func _on_timer_timeout():
    _rotate_direction_random()
    _reset_timer()
    _start_timer()
