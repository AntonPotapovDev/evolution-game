class_name SeekPreyState
extends AbstractFeedNeedState


var _patrolling_area: PatrollingAreaState
var _find_new_fields: FindNewFieldsState

var _current_state: AbstractFeedNeedState = null


func _init(actor: Creature):
    super(actor)
    _patrolling_area = PatrollingAreaState.new(actor)
    _find_new_fields = FindNewFieldsState.new(actor)


func start():
    pass


func update(delta: float):
    _update_state()
    _current_state.update(delta)


func reset():
    if _current_state:
        _current_state.reset()
        _current_state = null


func _update_state():
    if _actor.memory.remembered_fields.is_empty():
        _start_state(_find_new_fields)
    else:
        _start_state(_patrolling_area)


func _start_state(state: AbstractFeedNeedState):
    if _current_state != state:
        reset()
        _current_state = state
        _current_state.start()
