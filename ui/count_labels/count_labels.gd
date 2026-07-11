class_name CountLabels
extends VBoxContainer


var _herbi_count: int = 0
var _scavenger_count: int = 0
var _opport_count: int = 0
var _carni_count: int = 0


@onready var _herbi_label: Label = $HerbiCount
@onready var _scavenger_label: Label = $ScavengerCount
@onready var _opport_label: Label = $OpportunistCount
@onready var _carni_label: Label = $CarniCount


func _ready() -> void:
    EventBus.creature_spawned.connect(_on_creature_spawned)
    EventBus.creature_died.connect(_on_creature_died)

    _update_label(_herbi_label, Text.LABEL_BY_DIET[CreatureConfig.DietPhase.HERBIVORE], _herbi_count)
    _update_label(_scavenger_label, Text.LABEL_BY_DIET[CreatureConfig.DietPhase.OMNIVORE_SCAVENGER], _scavenger_count)
    _update_label(_opport_label, Text.LABEL_BY_DIET[CreatureConfig.DietPhase.OMNIVORE_OPPORTUNIST], _opport_count)
    _update_label(_carni_label, Text.LABEL_BY_DIET[CreatureConfig.DietPhase.CARNIVORE], _carni_count)


func _update_hud_with_config(config: CreatureConfig, delta: int):
    var new_title = Text.LABEL_BY_DIET[config.diet_phase]

    match config.diet_phase:
        CreatureConfig.DietPhase.HERBIVORE:
            _herbi_count += delta
            _update_label(_herbi_label, new_title, _herbi_count)
        CreatureConfig.DietPhase.OMNIVORE_SCAVENGER:
            _scavenger_count += delta
            _update_label(_scavenger_label, new_title, _scavenger_count)
        CreatureConfig.DietPhase.OMNIVORE_OPPORTUNIST:
            _opport_count += delta
            _update_label(_opport_label, new_title, _opport_count)
        CreatureConfig.DietPhase.CARNIVORE:
            _carni_count += delta
            _update_label(_carni_label, new_title, _carni_count)


func _update_label(label: Label, title: StringName, count: int):
    label.text = str(title) + ": " + str(count)


func _on_creature_spawned(config: CreatureConfig):
    _update_hud_with_config(config, 1)


func _on_creature_died(config: CreatureConfig):
    _update_hud_with_config(config, -1)
