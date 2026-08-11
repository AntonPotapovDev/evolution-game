class_name HuntingStrategy
extends AbstractGetFoodStrategy


var _current_prey: Creature = null


func _init(actor: Creature, init_food_info_provider: FoodInfoProvider, prey: Creature):
    super(actor, init_food_info_provider)
    _current_prey = prey


func can_continue() -> bool:
    if is_instance_valid(_current_prey):
        return true

    var food_info = food_info_provider.get_info()
    return food_info.prey != null


func update(delta: float) -> bool:
    if not is_instance_valid(_current_prey):
        _current_prey = food_info_provider.get_info().prey

    _actor.attack.attack_if_in_range(_current_prey)

    if _current_prey.death.dead:
        return true

    _actor.movement.rush_to_target(_current_prey, delta, Movement.Policy.SPRINT_IF_CAN)
    return false
