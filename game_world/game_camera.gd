class_name GameCamera
extends Camera2D


@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.1
@export var max_zoom: float = 2.0


var _is_dragging: bool = false
var _drag_start_pos: Vector2


func _input(event: InputEvent):
    if event is InputEventMouseButton:
        var mb_event = event as InputEventMouseButton
        _handle_zoom(mb_event)
        _handle_drag_start(mb_event)
    elif event is InputEventMouseMotion:
        var mm_event = event as InputEventMouseMotion
        _handle_mouse_move(mm_event)


func _handle_zoom(event: InputEventMouseButton):
    var new_zoom = zoom

    if _check_pressed(event, MOUSE_BUTTON_WHEEL_UP):
        new_zoom += Vector2(zoom_speed, zoom_speed)
    elif _check_pressed(event, MOUSE_BUTTON_WHEEL_DOWN):
        new_zoom -= Vector2(zoom_speed, zoom_speed)

    new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
    new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)

    zoom = new_zoom


func _handle_drag_start(event: InputEventMouseButton):
    if event.button_index != MOUSE_BUTTON_RIGHT:
        return

    if event.is_pressed():
        _is_dragging = true
        _drag_start_pos = event.position
    else:
        _is_dragging = false


func _handle_mouse_move(event: InputEventMouseMotion):
    if not _is_dragging:
        return

    var delta = event.position - _drag_start_pos
    global_position -= delta * (1.0 / zoom.x)
    _drag_start_pos = event.position


func _check_pressed(event: InputEventMouseButton, button: MouseButton) -> bool:
    return event.button_index == button and event.is_pressed()
