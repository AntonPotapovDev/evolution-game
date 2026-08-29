class_name CreatureConfig
extends RefCounted


enum DietType {
    HERBIVORE,
    OMNIVORE,
    CARNIVORE
}


var diet_type: DietType
var vision_radius: float
var eating_config: Eating.Config
var movement_config: Movement.Config
var stamina_config: Stamina.Config
var energy_config: Energy.Config
var moving_to_food_policy: Movement.Policy


var diet: Array[StringName]:
    get:
        match diet_type:
            DietType.HERBIVORE:
                return [ Groups.PLANT_FOOD ] as Array[StringName]
            DietType.CARNIVORE:
                return [ Groups.MEAT_FOOD ] as Array[StringName]
            DietType.OMNIVORE:
                return [ Groups.PLANT_FOOD, Groups.MEAT_FOOD ] as Array[StringName]
            _:
                return [] as Array[StringName]


var is_hunter: bool:
    get:
        return diet_type == DietType.CARNIVORE


static func make_default() -> CreatureConfig:
    var config = CreatureConfig.new()

    config.diet_type = DietType.HERBIVORE
    config.vision_radius = DefaultValues.VISION_RADIUS
    config.eating_config = _make_default_eating_config()
    config.movement_config = _make_default_movement_config()
    config.stamina_config = _make_default_stamina_config()
    config.energy_config = _make_default_energy_config()
    config.moving_to_food_policy = Movement.Policy.NORMAL

    return config


static func _make_default_energy_config() -> Energy.Config:
    var config = Energy.Config.new()
    config.max_energy = DefaultValues.MAX_ENERGY
    config.general_consumption = DefaultValues.GENERAL_ENERGY_CONSUMPTION
    config.movement_consumption = DefaultValues.MOVEMENT_ENERGY_CONSUMPTION
    return config


static func _make_default_movement_config() -> Movement.Config:
    var config = Movement.Config.new()
    config.normal_speed = DefaultValues.NORMAL_SPEED
    config.sprint_speed = DefaultValues.SPRINT_SPEED
    return config


static func _make_default_stamina_config() -> Stamina.Config:
    var config = Stamina.Config.new()
    config.max_stamina = DefaultValues.MAX_STAMINA
    config.stamina_restore_rate = DefaultValues.STAMINA_RESTORE_RATE
    config.sprint_consumption = DefaultValues.SPRINT_STAMINA_CONSUMPTION
    return config


static func _make_default_eating_config() -> Eating.Config:
    var config = Eating.Config.new()
    config.plant_energy_multiplier = 1.0
    config.meat_energy_multiplier = 1.0
    return config
