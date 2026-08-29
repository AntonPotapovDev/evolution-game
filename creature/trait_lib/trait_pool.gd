class_name TraitPool
extends RefCounted


enum Trait {
    HERBIVORE,
    OMNIVORE,
    CARNIVORE,

    SPEEDSTER,
    SHARP_VISION,
    FOOD_RUSH,
}


static var _all_traits: Dictionary = {
    Trait.HERBIVORE: HerbivoreTrait.new(),
    Trait.OMNIVORE: OmnivoreTrait.new(),
    Trait.CARNIVORE: CarnivoreTrait.new(),

    Trait.SPEEDSTER: SpeedsterTrait.new(),
    Trait.SHARP_VISION: SharpVisionTrait.new(),
    Trait.FOOD_RUSH: FoodRushTrait.new()
}


static var _general_pool: Array[Trait] = [
    Trait.SPEEDSTER,
    Trait.SHARP_VISION,
    Trait.FOOD_RUSH
] as Array[Trait]


static var _diet_pool: Array[Trait] = [
    Trait.HERBIVORE,
    Trait.OMNIVORE,
    Trait.CARNIVORE
] as Array[Trait]


static var general_traits: Array[Trait]:
    get:
        return _general_pool


static var diet_traits: Array[Trait]:
    get:
        return _diet_pool


static func get_trait(trait_id: Trait) -> AbstractTrait:
    return _all_traits[trait_id]
