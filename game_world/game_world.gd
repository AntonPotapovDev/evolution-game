class_name GameWord
extends Node2D


@onready var _camera: GameCamera = $GameCamera


var _screen_size: Vector2
var _rng: RandomNumberGenerator


func start() -> void:
    _init_system()
    _init_fields()
    _init_cretures()


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


func _init_fields():
    var fields = get_tree().get_nodes_in_group(Groups.FIELD)
    for node in fields:
        var field = node as Field
        if field:
            field.init()
