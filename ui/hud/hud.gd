class_name Hud
extends CanvasLayer


func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("pause"):
        get_tree().paused = not get_tree().paused
