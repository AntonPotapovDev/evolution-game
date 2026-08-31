class_name GameWord
extends Node2D


const WORLD_RADIUS = 5000.0


@onready var _camera: GameCamera = $GameCamera


var _screen_size: Vector2


func start() -> void:
    _init_system()
    _init_fields()
    _init_cretures()


func _init_system():
    _screen_size = get_viewport_rect().size
    _camera.global_position = _screen_size / 2

    Spawner.init(self)


func _init_cretures():
    var creatures = get_tree().get_nodes_in_group(Groups.CREATURE)
    for node in creatures:
        var creature = node as Creature
        if not creature:
            continue

        var blueprint = CreatureBlueprint.make_default()
        creature.init(blueprint, Spawner.gen_creature_id())
        EventBus.creature_spawned.emit(creature.config)


func _init_fields():
    var fields = get_tree().get_nodes_in_group(Groups.FIELD)
    for node in fields:
        var field = node as Field
        if field:
            field.init()

func _draw():
    draw_circle(Vector2.ZERO, WORLD_RADIUS, Color.YELLOW, false, 2.0)
