class_name Eating
extends RefCounted


class Config extends RefCounted:
    var plant_energy_multiplier: float
    var meat_energy_multiplier: float


var _creature: Creature
var _config: Config


var config: Config:
    get:
        return _config


func _init(creature: Creature, init_config: Config):
    _creature = creature
    _config = init_config


func eat_food_if_can(food: AbstractFood):
    if not _creature.config.diet.has(food.type):
        return

    if _creature.overlaps_area(food):
        food.consume(_creature)
