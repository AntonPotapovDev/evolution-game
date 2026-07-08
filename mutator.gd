extends Node


const DIET_MUTATION: float = 0.2
const TRAIT_MUTATION: float = 0.5
const GAIN_TRAIT_MUTATION: float = 0.5


var _rng: RandomNumberGenerator


func mutate(config: CreatureConfig) -> CreatureConfig:
    var new_config = CreatureConfig.make_default()
    new_config.diet_phase = config.diet_phase
    new_config.trait_ids = config.trait_ids.duplicate()

    if _check_chance(DIET_MUTATION):
        _mutate_diet(new_config)

    if _check_chance(TRAIT_MUTATION):
        _mutate_traits(new_config)

    for trait_id in new_config.trait_ids:
        TraitPool.get_by_id(trait_id).patch_config(new_config)

    return new_config


func _mutate_diet(config: CreatureConfig):
    var delta_variants = []
    if config.diet_phase > CreatureConfig.DietPhase.HERBIVORE:
        delta_variants.append(-1)
    if config.diet_phase < CreatureConfig.DietPhase.CARNIVORE:
        delta_variants.append(1)

    var delta = delta_variants.pick_random()
    config.diet_phase += delta


func _mutate_traits(config: CreatureConfig):
    if _check_chance(GAIN_TRAIT_MUTATION):
        var new_trait = TraitPool.pick_id(config)
        if new_trait != null:
            config.trait_ids.append(new_trait)
        return

    if config.trait_ids.is_empty():
        return

    var trait_idx = _rng.randi_range(0, config.trait_ids.size() - 1)
    config.trait_ids.remove_at(trait_idx)


func _check_chance(chance: float) -> bool:
    return _rng.randf() < chance


func _ready() -> void:
    _rng = RandomNumberGenerator.new()
