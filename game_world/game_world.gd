class_name GameWord
extends Node2D


@onready var _food_timer: Timer = $FoodTimer
@onready var _camera: GameCamera = $GameCamera


var _screen_size: Vector2
var _rng: RandomNumberGenerator


func start() -> void:
    _init_system()
    _init_cretures()

    _food_timer.start()


func _init_system():
    _screen_size = get_viewport_rect().size
    _camera.global_position = _screen_size / 2

    _rng = RandomNumberGenerator.new()

    Spawner.init(self)


func _init_cretures():
    var creatures = get_tree().get_nodes_in_group(Groups.CREATURE)
    for node in creatures:
        var creature = node as Creature
        if not creature:
            continue

        var creature_config = CreatureConfig.make_default()
        creature.init(creature_config, Spawner.gen_creature_id(), SearchingState.make_factory())
        EventBus.creature_spawned.emit(creature_config)


func _spawn_food() -> void:
    var center = _screen_size / 2
    var coef = 0.7

    var move_x = _rng.randf_range(-center.x * coef, center.x * coef)
    var move_y = _rng.randf_range(-center.y * coef, center.y * coef)

    Spawner.spawn_plant_food(center + Vector2(move_x, move_y))


func _on_food_timer_timeout() -> void:
    _spawn_food()
    _spawn_food()
