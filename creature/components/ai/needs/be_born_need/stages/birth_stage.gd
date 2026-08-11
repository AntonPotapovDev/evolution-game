class_name BirthStage
extends AbstractStage


static func make_factory(actor: Creature) -> BeBornNeedStageFactory:
    return BeBornNeedStageFactory.new(actor, BirthStage.new.bind())


var _parent: Creature = null
var _birth_completed: bool = false


func _init(actor: Creature):
    super(actor)
    _parent = actor.breeding.parent


func update(delta: float) -> AbstractStage.Result:
    if _birth_completed:
        return AbstractStage.Result.SUCCESS

    if not is_instance_valid(_parent):
        return AbstractStage.Result.FAIL

    _actor.movement.move_towards(Vector2.LEFT, delta)

    return AbstractStage.Result.NONE


func start():
    if is_instance_valid(_parent):
        _parent.area_exited.connect(_on_birth_completed)


func stop():
    _disconnect_parent()


func _disconnect_parent():
    if is_instance_valid(_parent) and _parent.area_exited.is_connected(_on_birth_completed):
        _parent.area_exited.disconnect(_on_birth_completed)


func _on_birth_completed(_area: Area2D):
    _disconnect_parent()
    _birth_completed = true
