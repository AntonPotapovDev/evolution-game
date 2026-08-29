class_name FoodRushTrait
extends AbstractTrait


func patch_blueprint(blueprint: CreatureBlueprint):
    blueprint.moving_to_food_policy = Movement.Policy.SPRINT_IF_CAN


func _init():
    _name = "Food rush"
    _description = "Creature always sprints when heading towards food"
