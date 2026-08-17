class_name FleeStrategy
extends RefCounted


var _actor: Creature
var _danger_info_provider: WeakRef



func _init(actor: Creature, danger_info_provider: DangerInfoProvider):
    _actor = actor
    _danger_info_provider = weakref(danger_info_provider)


func can_continue() -> bool:
    var dip = _danger_info_provider.get_ref() as DangerInfoProvider
    return dip.get_info().has_dangers


func update(delta: float) -> bool:
    var dip = _danger_info_provider.get_ref() as DangerInfoProvider
    var danger_positions = dip.get_info().positions

    var flee_direction = Vector2.ZERO
    for danger_pos in danger_positions:
        var dir_from_danger = danger_pos.direction_to(_actor.global_position)
        flee_direction += dir_from_danger

    if flee_direction.is_zero_approx():
        #TODO: make real fallback direction
        flee_direction = Vector2.from_angle(randf_range(0, TAU))

    _actor.movement.move_towards(flee_direction.normalized(), delta, Movement.Policy.SPRINT_IF_CAN)
    return false
