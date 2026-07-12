extends Node


signal selection_changed(Creature)


var _selected_creature: Creature


func on_creature_clicked(creature: Creature):
    if creature == _selected_creature:
        return

    _update_selection(creature)


func on_reset_selection_requested():
    _drop_selection()
    selection_changed.emit(null)


func _update_selection(creature: Creature):
    _drop_selection()

    _selected_creature = creature
    _selected_creature.selection_control.selected = true
    creature.died.connect(on_reset_selection_requested)
    selection_changed.emit(_selected_creature)


func _drop_selection():
    if is_instance_valid(_selected_creature):
        _selected_creature.died.disconnect(on_reset_selection_requested)
        _selected_creature.selection_control.selected = false
        _selected_creature = null

func _exit_tree() -> void:
    _drop_selection()
