class_name PickFoodStrategy
extends AbstractGetFoodStrategy


func _init(actor: Creature, init_food_info_provider: FoodInfoProvider):
    super(actor, init_food_info_provider)


func can_continue() -> bool:
    var food_info = food_info_provider.get_info()
    return food_info.food != null


func update(delta: float) -> bool:
    var food = food_info_provider.get_info().food

    var movement_policy = _actor.config.moving_to_food_policy
    _actor.movement.move_to_target(food, delta, movement_policy)
    return food.is_consumed
