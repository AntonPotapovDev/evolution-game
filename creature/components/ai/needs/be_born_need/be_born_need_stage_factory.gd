class_name BeBornNeedStageFactory
extends AbstractStageFactory


var _factory_method: Callable


func _init(actor: Creature, factory_method: Callable):
    super(actor)
    _factory_method = factory_method


func make() -> AbstractStage:
    return _factory_method.call(_actor)
