class_name FoodRush
extends AbstractTrait


func patch_config(config: CreatureConfig):
    config.moving_to_food_policy = Movement.Policy.SPRINT_IF_CAN


func _init():
    _name = "Food rush"
    _description = "Creature always sprints when heading towards food"
