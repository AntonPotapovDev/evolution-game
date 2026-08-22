class_name GrazingState
extends AbstractFeedNeedState


var _field: Field = null
var _target_position: Vector2 = Vector2.ZERO


func _init(actor: Creature):
    super(actor)


func set_field(field: Field):
    if field != _field:
        _field = field
        _set_new_target_position()


func start():
    _set_new_target_position()


func update(delta: float):
    if _actor.global_position.distance_to(_target_position) < 64.0:
        _set_new_target_position()

    _actor.movement.move_to_position(_target_position, delta)


func reset():
    _field = null
    _target_position = Vector2.ZERO


func _set_new_target_position():
    _target_position = LocationInfoProvider.get_random_position_on_field(_field)
