class_name Inspector
extends Panel


const TRAIT_ITEM_SCENE: PackedScene = preload("res://ui/trait_item/trait_item.tscn")


@onready var _title_label: Label = $MainContainer/TitleBar/TitleLabel
@onready var _health_label: Label = $MainContainer/Content/HealthLabel
@onready var _energy_label: Label = $MainContainer/Content/EnergyLabel
@onready var _diet_label: Label = $MainContainer/Content/DietLabel

@onready var _trait_list: VBoxContainer = $MainContainer/Content/TraitContainer/TraiList


var _display_creature: Creature = null


func _ready() -> void:
    visible = false
    CreatureSelecttionManager.selection_changed.connect(_on_selection_changed)


func _process(_delta: float) -> void:
    if not is_instance_valid(_display_creature):
        _hide()
        return

    _update_label(_health_label, Text.HEALTH, ": ",
        _make_param_text(_display_creature.hp, DefaultValues.MAX_HP))

    _update_label(_energy_label, Text.ENERGY, ": ",
        _make_param_text(
            floori(_display_creature.energy),
            int(_display_creature.config.energy_config.max_energy)))


func _update_label(label: Label, title: StringName, separator: String, value: String):
    label.text = str(title) + separator + value


func _update_diet_label():
    var diet_phase = _display_creature.config.diet_phase
    _update_label(_diet_label, Text.DIET, ": ", str(Text.LABEL_BY_DIET[diet_phase]))
    _diet_label.tooltip_text = str(Text.TOOLTIP_BY_DIET[diet_phase])


func _make_param_text(value: int, max_value: int) -> String:
    return str(value) + " / " + str(max_value)


func _clear_trait_list():
    for trait_item in _trait_list.get_children():
        _trait_list.remove_child(trait_item)
        trait_item.queue_free()


func _populate_trait_list(config: CreatureConfig):
    for trait_id in config.trait_ids:
        var creature_trait = TraitPool.get_by_id(trait_id)
        var trait_item = TRAIT_ITEM_SCENE.instantiate() as TraitItem
        trait_item.init(creature_trait.name, creature_trait.description)
        _trait_list.add_child(trait_item)


func _hide():
    visible = false
    _display_creature = null


func _on_close_button_pressed() -> void:
    EventBus.reset_selection_requested.emit()


func _on_selection_changed(creature: Creature):
    if creature == null:
        _hide()
        return

    visible = true
    if creature == _display_creature:
        return

    _display_creature = creature
    _update_label(_title_label, Text.CREATURE, " #", str(_display_creature.id))
    _update_diet_label()

    _clear_trait_list()
    _populate_trait_list(creature.config)
