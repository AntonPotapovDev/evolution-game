class_name CreatureSelectionControl
extends Area2D


@export var creature: Creature


@onready var _outline: Sprite2D = $Outline


var selected: bool:
    get():
        return _outline.visible
    set(value):
        _outline.visible = value


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    var mouse_button_event = event as InputEventMouseButton
    if not mouse_button_event:
        return

    if mouse_button_event.button_index == MOUSE_BUTTON_LEFT and mouse_button_event.is_pressed():
        EventBus.creature_clicked.emit(creature)
