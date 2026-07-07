class_name CreatureConfig
extends RefCounted


enum DietPhase {
    HERBIVORE,
    OMNIVORE_SCAVENGER,
    OMNIVORE_OPPORTUNIST,
    CARNIVORE
}


var diet_phase: DietPhase
var trait_ids: Array[int]
var movement_speed: float
var energy_config: EnergySystem.EnergyConfig


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
    config.movement_speed = DefaultValues.MOVEMENT_SPEED
    config.energy_config = _make_default_energy_config()

    return config


static func _make_default_energy_config() -> EnergySystem.EnergyConfig:
    var config = EnergySystem.EnergyConfig.new()
    config.max_energy = DefaultValues.MAX_ENERGY
    config.general_consumption = DefaultValues.GENERAL_ENERGY_CONSUMPTION
    config.movement_consumption = DefaultValues.MOVEMENT_ENERGY_CONSUMPTION
    config.birth_cost = DefaultValues.BIRTH_ENERGY_COST
    return config
