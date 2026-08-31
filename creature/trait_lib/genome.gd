class_name Genome
extends RefCounted


const DIET_MUTATION: float = 0.2
const GAIN_TRAIT_MUTATION: float = 0.3
const LOSE_TRAIT_MUTATION: float = 0.1


var _diet_trait: TraitPool.Trait
var _general_traits: Array[TraitPool.Trait]


var diet_trait: TraitPool.Trait:
    get:
        return _diet_trait


var general_traits: Array[TraitPool.Trait]:
    get:
        return _general_traits


var all_traits: Array[TraitPool.Trait]:
    get:
        var result = _general_traits.duplicate()
        result.push_front(_diet_trait)
        return result


static func make_default() -> Genome:
    var genome = Genome.new()
    genome._diet_trait = TraitPool.Trait.HERBIVORE
    genome._general_traits = [] as Array[TraitPool.Trait]
    return genome


func replicate_mutated() -> Genome:
    var result = Genome.new()
    result._diet_trait = _diet_trait
    result._general_traits = _general_traits.duplicate()

    if _check_chance(DIET_MUTATION):
        result._mutate_diet()

    if _check_chance(LOSE_TRAIT_MUTATION):
        result._lose_trait()

    if _check_chance(GAIN_TRAIT_MUTATION):
        result._gain_trait()

    return result


func _mutate_diet():
    match _diet_trait:
        TraitPool.Trait.HERBIVORE:
            _diet_trait = TraitPool.Trait.OMNIVORE
        TraitPool.Trait.OMNIVORE:
            _diet_trait = [TraitPool.Trait.HERBIVORE, TraitPool.Trait.CARNIVORE].pick_random()
        TraitPool.Trait.CARNIVORE:
            _diet_trait = TraitPool.Trait.OMNIVORE
        _:
            pass


func _lose_trait():
    var trait_count = _general_traits.size()
    if trait_count > 0:
        var trait_idx = randi_range(0, trait_count - 1)
        _general_traits.remove_at(trait_idx)


func _gain_trait():
    var trait_options = TraitPool.general_traits.filter(
        func (t: TraitPool.Trait): return not _general_traits.has(t))
    if not trait_options.is_empty():
        _general_traits.append(trait_options.pick_random())


static func _check_chance(chance: float) -> bool:
    return randf() < chance
