class_name SafetyNeed
extends AbstractNeed


var _danger_info_provider: WeakRef
var _flee_strategy: FleeStrategy = null


func _init(actor: Creature, danger_info_provider: DangerInfoProvider):
    super(actor)
    _danger_info_provider = weakref(danger_info_provider)


func is_actual() -> bool:
    var dip = _danger_info_provider.get_ref() as DangerInfoProvider
    return dip.get_info().has_dangers


func can_interrupt() -> bool:
    return not is_actual()


func update(delta: float):
    _flee_strategy.update(delta)


func activate():
    _flee_strategy = FleeStrategy.new(_actor, _danger_info_provider.get_ref() as DangerInfoProvider)


func reset():
    _flee_strategy = null
