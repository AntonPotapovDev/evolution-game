class_name PlantFood
extends AbstractFood


const ENERGY_BOOST: float = 50.0


func consume(consuming_creature: Creature):
    _consume(consuming_creature, consuming_creature.eating.config.plant_energy_multiplier)


func _ready() -> void:
    _energy_boost = ENERGY_BOOST
    z_index = Layers.Layer.FOOD
    _type = Groups.PLANT_FOOD
    add_to_group(_type)
