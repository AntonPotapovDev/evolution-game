class_name PlantFood
extends AbstractFood


const ENERGY_BOOST: float = 50.0


func _ready() -> void:
    _energy_boost = ENERGY_BOOST
    z_index = Layers.Layer.FOOD
    _type = Groups.PLANT_FOOD
    add_to_group(_type)
