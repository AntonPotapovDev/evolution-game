class_name FeedNeed
extends AbstractNeed


var _script: StagedScript
var _food_info_provider: WeakRef


func _init(actor: Creature, food_info_provider: FoodInfoProvider):
    super(actor)
    _food_info_provider = weakref(food_info_provider)
    _script = StagedScript.new([
        SeekFoodStage.make_factory(actor, food_info_provider),
        GetFoodStage.make_factory(actor, food_info_provider)
    ] as Array[AbstractStageFactory])


func is_actual() -> bool:
    return true


func update(delta: float):
    _script.update(delta)


func activate():
    _script.start()


func reset():
    _script.stop()
