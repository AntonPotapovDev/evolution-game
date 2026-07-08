extends Node


@onready var game_world: GameWord = $GameWorld


func _ready() -> void:
    EventBus.creature_clicked.connect(
        CreatureSelecttionManager.on_creature_clicked)
    EventBus.reset_selection_requested.connect(
        CreatureSelecttionManager.on_reset_selection_requested)

    game_world.start()
