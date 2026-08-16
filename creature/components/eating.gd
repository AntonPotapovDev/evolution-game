class_name Eating
extends RefCounted


var _creature: Creature


func _init(creature: Creature):
    _creature = creature


func eat_food_if_can(food: AbstractFood):
    if not _creature.config.diet.has(food.type):
        return

    if _creature.overlaps_area(food):
        food.consume(_creature)
