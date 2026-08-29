class_name HerbivoreTrait
extends AbstractTrait


func patch_blueprint(blueprint: CreatureBlueprint):
    blueprint.diet_type = CreatureConfig.DietType.HERBIVORE
    blueprint.plant_energy_multiplier += 0.5
    blueprint.meat_energy_multiplier = 0.0


func _init():
    _name = "Herbivore"
    _description = "Creatre eats only plants"
