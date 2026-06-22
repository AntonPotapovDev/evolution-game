class_name Food
extends Area2D


const ENERGY_BOOST: float = 50.0


func _consume(consuming_creature: Creature):
    consuming_creature.change_energy(ENERGY_BOOST)
    queue_free()


func _ready() -> void:
    add_to_group(Groups.FOOD)


func _process(_delta: float) -> void:
    pass


func _on_area_entered(area: Area2D) -> void:
    var creature = area as Creature
    if creature:
        _consume(creature)
