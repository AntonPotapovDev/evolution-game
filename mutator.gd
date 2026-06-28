extends Node


const DIET: float = 0.2


var _rng: RandomNumberGenerator


func mutate(config: CreatureConfig):
    if _check_chance(DIET):
        _mutate_diet(config)


func _mutate_diet(config: CreatureConfig):
    if config.diet.size() == 2:
        var remove_idx = _rng.randi_range(0, 1)
        config.diet.remove_at(remove_idx)
        config.is_hunter = config.diet.front() == Groups.MEAT_FOOD
        return

    config.diet = [Groups.PLANT_FOOD, Groups.MEAT_FOOD] as Array[StringName]


func _check_chance(chance: float) -> bool:
    return _rng.randf() < chance


func _ready() -> void:
    _rng = RandomNumberGenerator.new()
