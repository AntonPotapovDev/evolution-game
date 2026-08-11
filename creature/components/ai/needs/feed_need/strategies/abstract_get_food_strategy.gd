class_name AbstractGetFoodStrategy
extends RefCounted


var _actor: Creature
var _food_info_provider: WeakRef


var food_info_provider: FoodInfoProvider:
    get:
        return _food_info_provider.get_ref() as FoodInfoProvider


func _init(actor: Creature, init_food_info_provider: FoodInfoProvider):
    _actor = actor
    _food_info_provider = weakref(init_food_info_provider)


func can_continue() -> bool:
    return false


func update(_delta: float) -> bool:
    return false
