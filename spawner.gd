extends Node


const CREATURE_SCENE = preload("res://creature.tscn")
const FOOD_SCENE = preload("res://food.tscn")


func spawn_creature(global_position: Vector2, state_factory: Callable = Callable()) -> Creature:
    var instance = CREATURE_SCENE.instantiate() as Creature
    if not state_factory.is_null():
        instance.init_with_state(state_factory)
    _add_object_to_scene(instance, global_position)
    return instance


func spawn_food(global_position: Vector2) -> Food:
    var instance = FOOD_SCENE.instantiate() as Food
    _add_object_to_scene(instance, global_position)
    return instance


func _add_object_to_scene(obj: Node2D, global_position: Vector2):
    obj.global_position = global_position
    get_tree().current_scene.add_child(obj)
