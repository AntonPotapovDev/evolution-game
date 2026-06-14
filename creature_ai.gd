extends Node2D
class_name CreatureAI


enum AiState
{
    SEARCHING,
    MOVING_TO_TARGET
}


@export var creature: Creature


var _target_food: Food
var _current_state: AiState


var target_food: Food:
    get:
        if not is_instance_valid(_target_food):
            return null

        return _target_food


var state: AiState:
    get:
        return _current_state


func _find_nearest_food():
    var food_pickups = get_tree().get_nodes_in_group(Groups.FOOD)

    var min_distance = INF
    var new_target: Food = null
    
    for node in food_pickups:
        var pickup = node as Food
        if not pickup:
            continue

        var distance = creature.position.distance_to(pickup.position)
        if distance < min_distance:
            min_distance = distance
            new_target = pickup

    return new_target


func _enter_state_searching():
    _target_food = null
    _current_state = AiState.SEARCHING
    _process_searching()


func _enter_state_moving_to_target(new_target: Food):
    $FoodSearchTimer.stop()
    _current_state = AiState.MOVING_TO_TARGET
    _target_food = new_target
    _process_moving_to_target()


func _process_searching():
    var new_target = _find_nearest_food()

    if new_target:
        _enter_state_moving_to_target(new_target)
    else:
        $FoodSearchTimer.start()


func _process_moving_to_target():
    if not is_instance_valid(_target_food):
        _enter_state_searching()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _enter_state_searching()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    match _current_state:
        AiState.SEARCHING:
            # Done by timer callback
            pass
        AiState.MOVING_TO_TARGET:
            _process_moving_to_target()


func _on_food_search_timer_timeout() -> void:
    _process_searching()
