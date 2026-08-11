class_name FoodNeedStageFactory
extends AbstractStageFactory


var _factory_method: Callable
var _food_info_provider: WeakRef


func _init(actor: Creature, food_info_provider: FoodInfoProvider, factory_method: Callable):
    super(actor)
    _factory_method = factory_method
    _food_info_provider = weakref(food_info_provider)


func make() -> AbstractStage:
    return _factory_method.call(_actor, _food_info_provider.get_ref() as FoodInfoProvider)
