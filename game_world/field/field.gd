class_name Field
extends Area2D


@export var min_spawn_time: float = 2.0
@export var max_spawn_time: float = 4.0
@export var min_starting_food: int = 0
@export var max_starting_food: int = 5


@onready var _shape: CircleShape2D = $CollisionShape2D.shape as CircleShape2D


var _time_left: float = 0.0


func init():
    z_index = Layers.Layer.FIELD

    var staring_food_count = randi_range(min_starting_food, max_starting_food)
    for _i in range(staring_food_count):
        _spawn_food()

    _update_time_left()


func _ready() -> void:
    add_to_group(Groups.FIELD)


func _physics_process(delta: float) -> void:
    _time_left -= delta

    if _time_left < 0.0:
        _spawn_food()
        _update_time_left()


func _spawn_food():
    Spawner.spawn_plant_food(_get_random_point())


func _update_time_left():
    _time_left = randf_range(min_spawn_time, max_spawn_time)


func _get_random_point() -> Vector2:
    var point = Vector2.UP * randf_range(0.0, _shape.radius)
    return to_global(point.rotated(randf_range(0.0, TAU)))
