class_name MeatFood
extends AbstractFood


const ENERGY_BOOST: float = 100.0


func _ready() -> void:
    _energy_boost = ENERGY_BOOST
    z_index = Layers.Layer.FOOD
    _type = Groups.MEAT_FOOD
    add_to_group(_type)
