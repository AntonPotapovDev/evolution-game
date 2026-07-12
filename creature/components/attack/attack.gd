class_name Attack
extends Path2D


@export var creature: Creature


@onready var _paw = $AttackPath/Paw
@onready var _attack_hitbox = $AttackPath/Paw/CollisionShape2D
@onready var _animation_player = $AnimationPlayer
@onready var _attack_box = $AttackBox


var _cooldown_left: float = 0.0
var _is_attacking: bool = false


func do_attack():
    if _is_attacking or not is_zero_approx(_cooldown_left):
        return

    _set_enabled(true)
    _is_attacking = true
    _cooldown_left = DefaultValues.ATTACK_COOLDOWN
    _animation_player.play("Attack")


func attack_if_in_range(other_creature: Creature):
    if _attack_box.overlaps_area(other_creature):
        do_attack()


func _set_enabled(enabled: bool):
    _paw.visible = enabled
    _attack_hitbox.disabled = !enabled


func _ready() -> void:
    _set_enabled(false)


func _physics_process(delta: float) -> void:
    _cooldown_left = max(0.0, _cooldown_left - delta)


func _on_paw_area_entered(area: Area2D) -> void:
    if area == creature:
        return

    var other_creature = area as Creature
    if not other_creature:
        return

    if _attack_box.overlaps_area(other_creature):
        other_creature.health.take_damage(DefaultValues.ATTACK_DAMAGE)


func _on_animation_finished(_anim_name: StringName) -> void:
    _set_enabled(false)
    _is_attacking = false
    _animation_player.play("RESET")
