class_name FindNewFieldsState
extends AbstractFeedNeedState


func _init(actor: Creature):
    super(actor)


func start():
    pass


func update(delta: float):
    _actor.movement.move_to_position(Vector2.ZERO, delta)


func reset():
    pass
