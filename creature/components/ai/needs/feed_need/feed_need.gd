class_name FeedNeed
extends AbstractNeed


var _food_info_provider: WeakRef

var _seek_food: AbstractFeedNeedState
var _pick_food: PickFoodState
var _hunting: HuntingState

var _current_state: AbstractFeedNeedState = null


func _init(actor: Creature, food_info_provider: FoodInfoProvider, location_info_provider: LocationInfoProvider):
    super(actor)
    _food_info_provider = weakref(food_info_provider)

    _seek_food = _get_searching_state(location_info_provider)
    _pick_food = PickFoodState.new(actor)
    _hunting = HuntingState.new(actor)


func is_actual() -> bool:
    return true


func can_interrupt() -> bool:
    return true


func update(delta: float):
    _update_state()
    _current_state.update(delta)


func activate():
    pass


func reset():
    if _current_state:
        _current_state.reset()
        _current_state = null


func _update_state():
    var fip = _food_info_provider.get_ref() as FoodInfoProvider
    var info = fip.get_info()

    if not info.has_food:
        _start_seek_food()
        return

    if info.food:
        _start_pick_food(info.food)
        return

    if _can_hunt():
        _start_hunting(info.prey)
        return

    _start_seek_food()


func _start_seek_food():
    _start_state(_seek_food)


func _start_pick_food(food: AbstractFood):
    _pick_food.set_food(food)
    _start_state(_pick_food)


func _start_hunting(prey: Creature):
    if not _hunting.has_prey():
        _hunting.set_prey(prey)
    _start_state(_hunting)


func _start_state(state: AbstractFeedNeedState):
    if _current_state != state:
        reset()
        _current_state = state
        _current_state.start()


func _can_hunt() -> bool:
    return _actor.stamina.can_use_stamina


func _get_searching_state(location_info_provider: LocationInfoProvider) -> AbstractFeedNeedState:
    if _actor.config.is_hunter:
        return SeekPreyState.new(_actor)
    return SeekFoodState.new(_actor, location_info_provider)
