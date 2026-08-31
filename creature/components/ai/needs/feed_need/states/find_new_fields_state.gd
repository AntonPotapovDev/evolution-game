class_name FindNewFieldsState
extends AbstractFeedNeedState


var _nip: NavigationInfoProvider
var _current_target: Vector2 = Vector2.ZERO


func _init(actor: Creature):
    super(actor)
    _nip = NavigationInfoProvider.new(actor)


func start():
    _nip.init_path()
    _current_target = _nip.get_next_point()


func update(delta: float):
    if _actor.global_position.distance_to(_current_target) < 64.0:
        _current_target = _nip.get_next_point()

    _actor.movement.move_to_position(_current_target, delta)


func reset():
    _current_target = Vector2.ZERO
    _nip.reset_path()
