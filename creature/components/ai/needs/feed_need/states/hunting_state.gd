class_name HuntingState
extends AbstractFeedNeedState


var _prey: Creature = null


func _init(actor: Creature):
    super(actor)


func set_prey(prey: Creature):
    _prey = prey


func has_prey() -> bool:
    return is_instance_valid(_prey)


func start():
    pass


func update(delta: float):
    _actor.attack.attack_if_in_range(_prey)
    _actor.movement.rush_to_target(_prey, delta, Movement.Policy.SPRINT_IF_CAN)


func reset():
    _prey = null
