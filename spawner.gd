extends Node


const CREATURE_SCENE = preload("res://creature.tscn")
const PLANT_FOOD_SCENE = preload("res://plant_food.tscn")
const MEAT_FOOD_SCENE = preload("res://meat_food.tscn")


var _last_creature_id: int = -1


func spawn_creature(global_position: Vector2, config: CreatureConfig, initial_state_factory: Callable) -> Creature:
    var instance = CREATURE_SCENE.instantiate() as Creature
    instance.init(config, gen_creature_id(), initial_state_factory)
    _add_object_to_scene(instance, global_position)
    EventBus.creature_spawned.emit(config)
    return instance


func spawn_default_creature(global_position: Vector2) -> Creature:
    return spawn_creature(global_position, CreatureConfig.make_default(), SearchingState.make_factory())


func spawn_plant_food(global_position: Vector2) -> PlantFood:
    var instance = PLANT_FOOD_SCENE.instantiate() as PlantFood
    _add_object_to_scene(instance, global_position)
    return instance


func spawn_meat_food(global_position: Vector2) -> MeatFood:
    var instance = MEAT_FOOD_SCENE.instantiate() as MeatFood
    _add_object_to_scene(instance, global_position)
    return instance


func gen_creature_id() -> int:
    _last_creature_id += 1
    return _last_creature_id


func _add_object_to_scene(obj: Node2D, global_position: Vector2):
    obj.global_position = global_position
    get_tree().current_scene.add_child(obj)
