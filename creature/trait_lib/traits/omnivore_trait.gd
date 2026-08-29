class_name OmnivoreTrait
extends AbstractTrait


func patch_blueprint(blueprint: CreatureBlueprint):
    blueprint.diet_type = CreatureConfig.DietType.OMNIVORE


func _init():
    _name = "Omnivore"
    _description = "Creatre eats both plants and meat, but less effective"
