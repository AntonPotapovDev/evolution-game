class_name Vision
extends Area2D


const UPDATE_RATE: float = 0.1


var _creature: Creature = null
var _vision_radius: float = 0.0

var _seen_creatures_cache: Array[Creature]
var _seen_food_cache: Array[AbstractFood]

var _time_passed: float = 0.0


var seen_creatures: Array[Creature]:
    get():
        return _get_seen_creatures()


var seen_food: Array[AbstractFood]:
    get():
        return _get_seen_food()


func init(creature: Creature):
    if _creature:
        return

    _creature = creature
    _vision_radius = creature.config.vision_radius

    var shape = $CollisionShape2D.shape as CircleShape2D
    shape.radius = _vision_radius


func update(delta: float):
    _time_passed += delta
    if _time_passed < UPDATE_RATE:
        return

    _time_passed = 0.0

    _seen_creatures_cache.clear()
    _seen_food_cache.clear()

    for node in get_overlapping_areas():
        if node is Creature:
            var creature = node as Creature
            if creature != _creature:
                _seen_creatures_cache.append(creature)
        elif node is AbstractFood:
            _seen_food_cache.append(node as AbstractFood)


func is_creature_seen(creature: Creature) -> bool:
    return seen_creatures.has(creature)


func is_food_seen(food: AbstractFood) -> bool:
    return seen_food.has(food)


func _get_seen_creatures() -> Array[Creature]:
    _seen_creatures_cache = _filter_invalid_nodes(_seen_creatures_cache) as Array[Creature]
    return _seen_creatures_cache


func _get_seen_food() -> Array[AbstractFood]:
    _seen_food_cache = _filter_invalid_nodes(_seen_food_cache) as Array[AbstractFood]
    return _seen_food_cache


func _filter_invalid_nodes(nodes: Array) -> Array:
    return nodes.filter(func(n): return is_instance_valid(n))
