class_name SpeedsterTrait
extends AbstractTrait


func patch_config(config: CreatureConfig):
    config.movement_speed *= 1.5


func _init():
    _name = "Fast legs"
    _description = "Creature moves x1.5 faster"
