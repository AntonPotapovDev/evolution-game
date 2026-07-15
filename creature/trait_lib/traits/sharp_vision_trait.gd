class_name SharpVisionTrait
extends AbstractTrait


func patch_config(config: CreatureConfig):
    config.vision_radius *= 1.5


func _init():
    _name = "Sharp vision"
    _description = "Creature sees x1.5 further"
