class_name PatrollingAreaState
extends AbstractFeedNeedState


var _checked_fields: Array[Field] = [] as Array[Field]
var _target_field: Field = null
var _target_position: Vector2 = Vector2.ZERO


func _init(actor: Creature):
    super(actor)


func start():
    _set_target_field(_select_field())


func update(delta: float):
    if _actor.global_position.distance_to(_target_position) < 64.0:
        _checked_fields.append(_target_field)
        _set_target_field(_select_field())

    _actor.movement.move_to_position(_target_position, delta)


func reset():
    _checked_fields.clear()
    _set_target_field(null)


func _select_field() -> Field:
    var remembered_fields = _actor.memory.remembered_fields
    var fields_to_check = remembered_fields.filter(
        func(field: Field): return not _checked_fields.has(field))

    if fields_to_check.is_empty():
        _checked_fields.clear()
        fields_to_check = remembered_fields.duplicate()

    var target_field = null
    var min_distance = INF
    for field in fields_to_check:
        var distance = _actor.global_position.distance_to(field.global_position)
        if distance < min_distance:
            target_field = field
            min_distance = distance

    return target_field


func _set_target_field(field: Field):
    if field == null:
        _target_field = null
        _target_position = Vector2.ZERO
        return

    _target_field = field
    _target_position = LocationInfoProvider.get_random_position_on_field(field)
