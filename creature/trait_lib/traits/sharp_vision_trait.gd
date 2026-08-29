class_name SharpVisionTrait
extends AbstractTrait


func patch_blueprint(blueprint: CreatureBlueprint):
    blueprint.vision_radius_mult += 0.5


func _init():
    _name = "Sharp vision"
    _description = "Creature sees x1.5 further"
