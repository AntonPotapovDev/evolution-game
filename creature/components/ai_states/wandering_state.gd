class_name WanderingState
extends AbstractAiState


const CHANGE_DIRECTON_RATE: float = 4.0


var _background_searching: SearchingState
var _timer: Timer
var _direction: Vector2


func _init(ai: CreatureAI):
    super(ai)
    _background_searching = SearchingState.new(ai)
    _timer = Timer.new()
    _timer.wait_time = CHANGE_DIRECTON_RATE
    _set_random_direction()


func try_get_next_state_before_enter() -> AbstractAiState:
    return _background_searching.try_get_next_state_before_enter()


func try_get_next_state_after_process() -> AbstractAiState:
    return _background_searching.try_get_next_state_after_process()


func enter_state():
    _timer.timeout.connect(_on_timer_timeout)
    _ai.add_child(_timer)
    _timer.start()

    _background_searching.state_change_request.connect(_on_searching_state_change)
    _background_searching.enter_state()


func leave_state():
    _background_searching.state_change_request.disconnect(_on_searching_state_change)
    _background_searching.leave_state()

    _timer.stop()
    _timer.timeout.disconnect(_on_timer_timeout)
    _ai.remove_child(_timer)
    _timer.queue_free()
    _timer = null


func process_state(delta: float):
    _ai.creature.move_towards(_direction, delta)


func _rotate_direction_random():
    var rng = RandomNumberGenerator.new()
    _direction = _direction.rotated(rng.randf_range(PI / 2, PI))


func _set_random_direction():
    var rng = RandomNumberGenerator.new()
    var dir = Vector2.UP
    _direction = dir.rotated(rng.randf_range(0, TAU))


func _on_searching_state_change(new_state: AbstractAiState):
    state_change_request.emit(new_state)


func _on_timer_timeout():
    _rotate_direction_random()
