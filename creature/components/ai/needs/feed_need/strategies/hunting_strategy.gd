class_name HuntingStrategy
extends AbstractGetFoodStrategy


var _current_prey: Creature = null


func _init(actor: Creature, init_food_info_provider: FoodInfoProvider, prey: Creature):
    super(actor, init_food_info_provider)
    _current_prey = prey


func can_continue() -> bool:
    if _is_current_prey_actual():
        return true

    var food_info = food_info_provider.get_info()
    return food_info.prey != null


func update(delta: float) -> bool:
    if not _is_current_prey_actual():
        _current_prey = food_info_provider.get_info().prey

    _actor.attack.attack_if_in_range(_current_prey)

    if _current_prey.death.dead:
        return true

    _actor.movement.rush_to_target(_current_prey, delta, Movement.Policy.SPRINT_IF_CAN)
    return false


func _is_current_prey_actual() -> bool:
    return is_instance_valid(_current_prey) and _actor.vision.is_creature_seen(_current_prey)
