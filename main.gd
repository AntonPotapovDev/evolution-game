extends Node2D


var _screen_size: Vector2
var _rng: RandomNumberGenerator


func _spawn_food() -> void:
    var center = _screen_size / 2
    var coef = 0.7

    var move_x = _rng.randf_range(-center.x * coef, center.x * coef)
    var move_y = _rng.randf_range(-center.y * coef, center.y * coef)

    Spawner.spawn_plant_food(center + Vector2(move_x, move_y))


func _ready() -> void:
    _screen_size = get_viewport_rect().size
    _rng = RandomNumberGenerator.new()

    var creature_config = CreatureConfig.make_default()

    var creatures = get_tree().get_nodes_in_group(Groups.CREATURE)
    for node in creatures:
        var creature = node as Creature
        if not creature:
            continue

        creature.init(creature_config.clone(), Spawner.gen_creature_id(), SearchingState.make_factory())
        EventBus.creature_spawned.emit(creature_config)

    $FoodTimer.start()


func _process(_delta: float) -> void:
    pass


func _on_food_timer_timeout() -> void:
    _spawn_food()
    _spawn_food()
    $FoodTimer.start()
