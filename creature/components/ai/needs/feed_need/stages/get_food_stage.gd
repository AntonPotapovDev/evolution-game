class_name GetFoodStage
extends AbstractStage


static func make_factory(actor: Creature, food_info_provider: FoodInfoProvider) -> FoodNeedStageFactory:
    return FoodNeedStageFactory.new(actor, food_info_provider, GetFoodStage.new.bind())


var _food_info_provider: WeakRef
var _current_strategy: AbstractGetFoodStrategy = null


func _init(actor: Creature, food_info_provider: FoodInfoProvider):
    super(actor)
    _food_info_provider = weakref(food_info_provider)


func update(delta: float) -> AbstractStage.Result:
    if not _current_strategy:
        return AbstractStage.Result.FAIL

    if not _current_strategy.can_continue():
        _init_strategy()

    if not _current_strategy:
        return AbstractStage.Result.FAIL

    if _current_strategy.update(delta):
        return AbstractStage.Result.SUCCESS

    return AbstractStage.Result.NONE


func start():
    _init_strategy()


func stop():
    _current_strategy = null


func _init_strategy():
    var fip = _food_info_provider.get_ref() as FoodInfoProvider
    var food_info = fip.get_info()

    if not food_info.has_food:
        _current_strategy = null
        return

    if food_info.food:
        _current_strategy = PickFoodStrategy.new(_actor, fip)
    elif food_info.prey:
        _current_strategy = HuntingStrategy.new(_actor, fip, food_info.prey)
