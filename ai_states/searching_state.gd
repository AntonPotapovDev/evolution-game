class_name SearchingState
extends AbstractAiState


const SEARCH_RATE: float = 0.2


var _timer: Timer


func _init(ai: CreatureAI):
    super(ai)
    _timer = Timer.new()
    _timer.wait_time = SEARCH_RATE


func try_get_next_state_before_enter() -> AbstractAiState:
    if BreedingState.should_enter_state(_ai.creature):
        return BreedingState.new(_ai)

    var new_target = _find_nearest_food()
    if new_target:
        return MovingToTargetState.new(_ai, new_target)

    return null


func try_get_next_state_after_process() -> AbstractAiState:
    return null


func enter_state():
    _timer.timeout.connect(_on_timer_timeout)
    _ai.add_child(_timer)
    _timer.start()


func leave_state():
    _timer.stop()
    _ai.remove_child(_timer)
    _timer.queue_free()
    _timer = null


func process_state(_delta: float):
    pass


func _find_nearest_food() -> Food:
    var food_pickups = _ai.get_tree().get_nodes_in_group(Groups.FOOD)

    var min_distance = INF
    var new_target: Food = null
    
    for node in food_pickups:
        var pickup = node as Food
        if not pickup:
            continue

        var distance = _ai.creature.position.distance_to(pickup.position)
        if distance < min_distance:
            min_distance = distance
            new_target = pickup

    return new_target


func _on_timer_timeout():
    var new_target = _find_nearest_food()

    if new_target:
        state_change_request.emit(MovingToTargetState.new(_ai, new_target))
    else:
        _timer.start()
