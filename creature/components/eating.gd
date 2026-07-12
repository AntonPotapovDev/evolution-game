class_name Eating
extends RefCounted


var _creature: Creature


func on_creature_area_entered(area: Area2D):
    var food = area as AbstractFood
    if not food:
        return

    if _creature.config.diet.has(food.type):
        food.consume(_creature)


func _init(creature: Creature):
    _creature = creature
