class_name PickFoodState
extends AbstractFeedNeedState


var _food: AbstractFood = null


func _init(actor: Creature):
    super(actor)


func set_food(food: AbstractFood):
    _food = food


func start():
    pass


func update(delta: float):
    _actor.eating.eat_food_if_can(_food)
    if _food.is_consumed:
        return

    var movement_policy = _actor.config.moving_to_food_policy
    _actor.movement.move_to_target(_food, delta, movement_policy)


func reset():
    _food = null
