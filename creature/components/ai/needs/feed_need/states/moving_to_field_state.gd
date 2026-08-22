class_name MovingToFieldState
extends AbstractFeedNeedState


var _target_field: Field = null
var _target_position: Vector2 = Vector2.ZERO


func _init(actor: Creature):
    super(actor)


func set_target_field(field: Field):
    if _target_field != field:
        _target_field = field
        _target_position = LocationInfoProvider.get_random_position_on_field(field)


func start():
    pass


func update(delta: float):
    _actor.movement.move_to_position(_target_position, delta)


func reset():
    _target_field = null
    _target_position = Vector2.ZERO
