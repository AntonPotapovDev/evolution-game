extends Node2D


@export var food_scene: PackedScene


var _screen_size: Vector2
var _rng: RandomNumberGenerator


func _spawn_food() -> void:
    var food_pick = food_scene.instantiate()
    
    var center = _screen_size / 2
    var coef = 0.7

    var move_x = _rng.randf_range(-center.x * coef, center.x * coef)
    var move_y = _rng.randf_range(-center.y * coef, center.y * coef)

    food_pick.position = center + Vector2(move_x, move_y)

    add_child(food_pick)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _screen_size = get_viewport_rect().size
    _rng = RandomNumberGenerator.new()

    $FoodTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _on_food_timer_timeout() -> void:
    _spawn_food()
    $FoodTimer.start()
