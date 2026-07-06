class_name CreatureConfig
extends RefCounted


enum DietPhase {
    HERBIVORE,
    OMNIVORE_SCAVENGER,
    OMNIVORE_OPPORTUNIST,
    CARNIVORE
}


const DEFAULT_MOVEMENT_SPEED: float = 150.0


var diet_phase: DietPhase
var trait_ids: Array[int]
var movement_speed: float


var diet: Array[StringName]:
    get:
        match diet_phase:
            DietPhase.HERBIVORE:
                return [ Groups.PLANT_FOOD ] as Array[StringName]
            DietPhase.CARNIVORE:
                return [ Groups.MEAT_FOOD ] as Array[StringName]
            _:
                return [ Groups.PLANT_FOOD, Groups.MEAT_FOOD ] as Array[StringName]


var is_hunter: bool:
    get:
        match diet_phase:
            DietPhase.OMNIVORE_OPPORTUNIST, DietPhase.CARNIVORE:
                return true
            _:
                return false


static func make_default() -> CreatureConfig:
    var config = CreatureConfig.new()

    config.diet_phase = DietPhase.HERBIVORE
    config.trait_ids = [] as Array[int]
    config.movement_speed = DEFAULT_MOVEMENT_SPEED

    return config
