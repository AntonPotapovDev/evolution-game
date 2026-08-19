class_name SeekFoodState
extends AbstractFeedNeedState


const CHANGE_DIRECTON_RATE: float = 4.0


var _time_passed: float
var _direction: Vector2


func _init(actor: Creature):
    super(actor)
    reset()


func start():
    _set_random_direction()


func update(delta: float):
    _time_passed += delta
    if _time_passed > CHANGE_DIRECTON_RATE:
        _rotate_direction_random()
        _time_passed = 0.0

    _actor.movement.move_towards(_direction, delta)


func reset():
    _direction = Vector2.ZERO
    _time_passed = 0.0


func _rotate_direction_random():
    _direction = _direction.rotated(randf_range(PI / 2, PI))


func _set_random_direction():
    _direction = Vector2.UP.rotated(randf_range(0, TAU))
