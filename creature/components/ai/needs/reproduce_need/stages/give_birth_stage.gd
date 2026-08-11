class_name GiveBirthStage
extends AbstractStage


static func make_factory(actor: Creature) -> ReproduceNeedStageFactory:
    return ReproduceNeedStageFactory.new(actor, GiveBirthStage.new.bind())


var _child: Creature = null
var _child_spawned: bool = false
var _birth_completed: bool = false


func _init(actor: Creature):
    super(actor)


func update(delta: float) -> AbstractStage.Result:
    if _birth_completed:
        return AbstractStage.Result.SUCCESS

    if not _child_spawned:
        _child = _actor.breeding.make_child()
        _child.area_exited.connect(_on_birth_completed)
        _child_spawned = true
        return AbstractStage.Result.NONE

    if not is_instance_valid(_child):
        return AbstractStage.Result.FAIL

    _actor.movement.move_towards(Vector2.RIGHT, delta)

    return AbstractStage.Result.NONE


func start():
    pass


func stop():
    _disconnect_child()


func _disconnect_child():
    if is_instance_valid(_child) and _child.area_exited.is_connected(_on_birth_completed):
        _child.area_exited.disconnect(_on_birth_completed)


func _on_birth_completed(_area: Area2D):
    _disconnect_child()
    _birth_completed = true
