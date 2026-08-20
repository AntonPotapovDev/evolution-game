class_name Eating
extends RefCounted


var _creature: Creature

var _plant_energy_mult: float
var _meat_energy_mult: float


var plant_energy_multiplier: float:
    get:
        return _plant_energy_mult


var meat_energy_multiplier: float:
    get:
        return _meat_energy_mult


func _init(creature: Creature):
    _creature = creature
    _init_energy_multipliers()


func eat_food_if_can(food: AbstractFood):
    if not _creature.config.diet.has(food.type):
        return

    if _creature.overlaps_area(food):
        food.consume(_creature)


func _init_energy_multipliers():
    match _creature.config.diet_phase:
        CreatureConfig.DietPhase.HERBIVORE:
            _plant_energy_mult = 1.5
            _meat_energy_mult = 0.0
        CreatureConfig.DietPhase.OMNIVORE:
            _plant_energy_mult = 0.8
            _meat_energy_mult = 0.8
        CreatureConfig.DietPhase.CARNIVORE:
            _plant_energy_mult = 0.0
            _meat_energy_mult = 1.5
