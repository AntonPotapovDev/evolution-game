class_name SeekFoodStage
extends AbstractStage


const CHANGE_DIRECTON_RATE: float = 4.0


static func make_factory(actor: Creature, food_info_provider: FoodInfoProvider) -> FoodNeedStageFactory:
    return FoodNeedStageFactory.new(actor, food_info_provider, SeekFoodStage.new.bind())


var _food_info_provider: WeakRef

var _time_passed: float = 0.0
var _direction: Vector2


func _init(actor: Creature, food_info_provider: FoodInfoProvider):
    super(actor)
    _food_info_provider = weakref(food_info_provider)
    _set_random_direction()


func update(delta: float) -> AbstractStage.Result:
    var fip = _food_info_provider.get_ref() as FoodInfoProvider
    if fip.get_info().has_food:
        return AbstractStage.Result.SUCCESS

    _time_passed += delta
    if _time_passed > CHANGE_DIRECTON_RATE:
        _rotate_direction_random()
        _time_passed = 0.0

    _actor.movement.move_towards(_direction, delta)

    return AbstractStage.Result.NONE


func start():
    pass


func stop():
    pass


func _rotate_direction_random():
    _direction = _direction.rotated(randf_range(PI / 2, PI))


func _set_random_direction():
    _direction = Vector2.UP.rotated(randf_range(0, TAU))
