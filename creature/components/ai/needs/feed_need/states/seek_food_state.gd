class_name SeekFoodState
extends AbstractFeedNeedState


var _location_info_provider: WeakRef

var _moving_to_field: MovingToFieldState
var _grazing: GrazingState
var _find_new_fields: FindNewFieldsState

var _current_state: AbstractFeedNeedState = null


func _init(actor: Creature, location_info_provider: LocationInfoProvider):
    super(actor)
    _location_info_provider = weakref(location_info_provider)

    _moving_to_field = MovingToFieldState.new(actor)
    _grazing = GrazingState.new(actor)
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
    var lip = _location_info_provider.get_ref() as LocationInfoProvider
    var info = lip.get_info()

    if info.current_field:
        _start_grazing(info.current_field)
        return

    if info.closest_field:
        _start_moving_to_field(info.closest_field)
        return

    _start_finding_new_fields()


func _start_moving_to_field(field: Field):
    _moving_to_field.set_target_field(field)
    _start_state(_moving_to_field)


func _start_grazing(field: Field):
    _grazing.set_field(field)
    _start_state(_grazing)


func _start_finding_new_fields():
    _start_state(_find_new_fields)


func _start_state(state: AbstractFeedNeedState):
    if _current_state != state:
        reset()
        _current_state = state
        _current_state.start()
