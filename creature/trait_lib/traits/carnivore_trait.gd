class_name CarnivoreTrait
extends AbstractTrait


func patch_blueprint(blueprint: CreatureBlueprint):
    blueprint.diet_type = CreatureConfig.DietType.CARNIVORE
    blueprint.plant_energy_multiplier = 0.0
    blueprint.meat_energy_multiplier += 0.5


func _init():
    _name = "Carnivore"
    _description = "Creatre hunts and eats only meat"
