class_name Creature
extends Area2D

#TODO: make correct _physics_process

const MAX_ENERGY: float = 300
const DEFAULT_ENERGY_CONSUMPTION: float = 1
const MAX_HP: int = 10
const MOVING_SPEED: float = 150.0


var _energy: float = MAX_ENERGY
var _hp: int = MAX_HP


func change_energy(delta: float):
    _energy = clampf(_energy + delta, 0, MAX_ENERGY)


func _process_energy_and_hp(delta: float):
    change_energy(-DEFAULT_ENERGY_CONSUMPTION * delta)

    if _hp <= 0 or _energy <= 0:
        queue_free()


func _process_behavior(delta: float):
    var ai = $CreatureAI

    match ai.state:
        CreatureAI.AiState.SEARCHING:
            pass
        CreatureAI.AiState.MOVING_TO_TARGET:
            var target = ai.target_food
            if not target:
                return
            var advised_dir = $MovingAdviser.advised_direction(target.global_position)
            position += advised_dir * MOVING_SPEED * delta
            #position = position.move_toward(target.position, MOVING_SPEED * delta)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    _process_energy_and_hp(delta)


func _physics_process(delta: float) -> void:
    _process_behavior(delta)
