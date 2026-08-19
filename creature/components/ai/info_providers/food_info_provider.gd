class_name FoodInfoProvider
extends RefCounted


class FoodInfo extends RefCounted:
    var food: AbstractFood = null
    var prey: Creature = null

    var has_food: bool:
        get:
            return food != null or prey != null


var _creature: Creature
var _result_cache: FoodInfo = null


func _init(creature: Creature):
    _creature = creature


func get_info() -> FoodInfo:
    if not _result_cache:
        _result_cache = _do_search()

    return _result_cache


func update():
    _result_cache = null


func _do_search() -> FoodInfo:
    var result = FoodInfo.new()

    result.food = _find_nearest_food()

    if _creature.config.is_hunter:
        result.prey = _find_nearest_prey()

    return result


func _find_nearest_food() -> AbstractFood:
    var food = _creature.vision.seen_food
    return _pick_nearest_of(food.filter(_may_be_eaten)) as AbstractFood


func _find_nearest_prey() -> Creature:
    var creatures = _creature.vision.seen_creatures
    return _pick_nearest_of(creatures.filter(_may_be_prey)) as Creature


func _may_be_eaten(food: AbstractFood) -> bool:
    return _creature.config.diet.has(food.type)


func _may_be_prey(creature: Creature) -> bool:
    return not _creature.breeding.relatives_ids.has(creature.id) and not creature.config.is_hunter


func _pick_nearest_of(nodes: Array) -> Node2D:
    var min_distance = INF
    var target: Node2D = null

    for node in nodes:
        var creature = node as Creature
        if creature:
            if _creature.breeding.relatives_ids.has(creature.id):
                continue

        var distance = _creature.global_position.distance_to(node.global_position)
        if distance < min_distance:
            min_distance = distance
            target = node

    return target
