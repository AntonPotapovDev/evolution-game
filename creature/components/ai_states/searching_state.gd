class_name SearchingState
extends AbstractAiState


class SearchResult extends RefCounted:
    var food: AbstractFood = null
    var prey: Creature = null


const SEARCH_RATE: float = 0.2


var _timer: SceneTreeTimer


signal food_found(food: AbstractFood)


static func make_factory() -> Callable:
    return SearchingState.new


func _init(host_ai: CreatureAI):
    super(host_ai)


func try_get_next_state_before_enter() -> AbstractAiState:
    if BreedingState.should_enter_state(actor):
        return BreedingState.new(ai)

    var search_result = _do_search()

    if search_result.food:
        return MovingToTargetState.new(ai, search_result.food)

    if search_result.prey:
        return ChasingState.new(ai, search_result.prey)

    return null


func try_get_next_state_after_process() -> AbstractAiState:
    return null


func enter_state():
    _start_timer()


func leave_state():
    _reset_timer()


func _do_search() -> SearchResult:
    var result = SearchResult.new()

    result.food = _find_nearest_food()

    if actor.config.is_hunter:
        result.prey = _find_nearest_prey()

    return result


func _find_nearest_food() -> AbstractFood:
    var nearest_of_type: Array[AbstractFood]
    for food_type in actor.config.diet:
        var nearest = _find_nearest_food_of_type(food_type)
        if not nearest:
            continue
        nearest_of_type.append(nearest)

    return _pick_nearest_of(nearest_of_type) as AbstractFood


func _find_nearest_food_of_type(food_type: StringName) -> AbstractFood:
    var nodes = actor.get_tree().get_nodes_in_group(food_type)
    return _pick_nearest_of(nodes) as AbstractFood


func _find_nearest_prey() -> Creature:
    var nodes = actor.get_tree().get_nodes_in_group(Groups.CREATURE)
    return _pick_nearest_of(nodes.filter(_may_be_prey)) as Creature


func _may_be_prey(node: Node2D) -> bool:
    var creature = node as Creature
    if not creature:
        return false

    if creature == actor:
        return false

    return not actor.breeding.relatives_ids.has(creature.id)


func _pick_nearest_of(nodes: Array) -> Node2D:
    var min_distance = INF
    var target: Node2D = null

    for node in nodes:
        var creature = node as Creature
        if creature:
            if creature == actor:
                continue
            if actor.breeding.relatives_ids.has(creature.id):
                continue

        var distance = actor.global_position.distance_to(node.global_position)
        if distance < min_distance:
            min_distance = distance
            target = node

    return target


func _start_timer():
    _timer = actor.get_tree().create_timer(SEARCH_RATE)
    _timer.timeout.connect(_on_timer_timeout)


func _reset_timer():
    if _timer:
        _timer.timeout.disconnect(_on_timer_timeout)
        _timer = null


func _on_timer_timeout():
    var search_result = _do_search()

    if search_result.food:
        food_found.emit(search_result.food)
        state_change_request.emit(MovingToTargetState.new(ai, search_result.food))
    elif search_result.prey:
        state_change_request.emit(ChasingState.new(ai, search_result.prey))

    _reset_timer()
    _start_timer()
