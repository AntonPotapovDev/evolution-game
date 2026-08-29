class_name CreatureBlueprint
extends RefCounted


var _genome: Genome
var _config: CreatureConfig


var diet_type: CreatureConfig.DietType

var plant_energy_multiplier: float
var meat_energy_multiplier: float

var vision_radius_mult: float

var moving_to_food_policy: Movement.Policy
var movement_normal_speed_mult: float
var movement_sprint_speed_mult: float


var genome: Genome:
    get:
        return _genome


var config: CreatureConfig:
    get:
        return _config


static func make_from_genome(init_genome: Genome) -> CreatureBlueprint:
    var blueprint = CreatureBlueprint.new()

    blueprint._genome = init_genome
    blueprint._config = CreatureConfig.make_default()

    blueprint._init_default_values()

    for trait_id in blueprint._genome.all_traits:
        TraitPool.get_trait(trait_id).patch_blueprint(blueprint)

    blueprint._update_config()

    return blueprint


static func make_default() -> CreatureBlueprint:
    return make_from_genome(Genome.make_default())


func _init_default_values():
    diet_type = _config.diet_type

    plant_energy_multiplier = 1.0
    meat_energy_multiplier = 1.0

    vision_radius_mult = 1.0

    moving_to_food_policy = _config.moving_to_food_policy
    movement_normal_speed_mult = 1.0
    movement_sprint_speed_mult = 1.0


func _update_config():
    _config.diet_type = diet_type

    _config.eating_config.plant_energy_multiplier = plant_energy_multiplier
    _config.eating_config.meat_energy_multiplier = meat_energy_multiplier

    _config.vision_radius *= vision_radius_mult

    _config.moving_to_food_policy = moving_to_food_policy
    _config.movement_config.normal_speed *= movement_normal_speed_mult
    _config.movement_config.sprint_speed *= movement_sprint_speed_mult
