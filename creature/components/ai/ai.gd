class_name Ai
extends RefCounted


var _needs_by_priority: Array[AbstractNeed]
var _active_need: AbstractNeed = null

var _food_info_provider: FoodInfoProvider


func _init(actor: Creature):
    _food_info_provider = FoodInfoProvider.new(actor)

    _needs_by_priority = [
        BeBornNeed.new(actor),
        ReproduceNeed.new(actor),
        FeedNeed.new(actor, _food_info_provider)
    ] as Array[AbstractNeed]

    _active_need = _needs_by_priority.back()


func deinit():
    if _active_need:
        _active_need.reset()
        _active_need = null


func update(delta: float):
    _food_info_provider.update()

    var new_need_idx = _needs_by_priority.find_custom(
        func(need: AbstractNeed): return need.is_actual())

    var new_need = _needs_by_priority[new_need_idx]

    if new_need != _active_need:
        _active_need.reset()
        _active_need = new_need
        _active_need.activate()

    _active_need.update(delta)
