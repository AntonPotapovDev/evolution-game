class_name SpeedsterTrait
extends AbstractTrait


func patch_blueprint(blueprint: CreatureBlueprint):
    blueprint.movement_normal_speed_mult += 0.5
    blueprint.movement_sprint_speed_mult += 0.5


func _init():
    _name = "Fast legs"
    _description = "Creature moves x1.5 faster"
