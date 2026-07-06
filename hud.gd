extends CanvasLayer


const HERBI_TEXT: StringName = &"Herbi"
const CARNI_TEXT: StringName = &"Carni"
const OMNI_TEXT: StringName = &"Omni"


var _herbi_count: int = 0
var _carni_count: int = 0
var _omni_count: int = 0


@onready var _herbi_label = $VFlowContainer/HerbiCount
@onready var _carni_label = $VFlowContainer/CarniCount
@onready var _omni_label = $VFlowContainer/OmniCount


func _ready() -> void:
    EventBus.creature_spawned.connect(_on_creature_spawned)
    EventBus.creature_died.connect(_on_creature_died)

    _update_herbi()
    _update_carni()
    _update_omni()


func _update_hud_with_config(config: CreatureConfig, delta: int):
    match config.diet_phase:
        CreatureConfig.DietPhase.HERBIVORE:
            _herbi_count += delta
            _update_herbi()
        CreatureConfig.DietPhase.CARNIVORE:
            _carni_count += delta
            _update_carni()
        _:
            _omni_count += delta
            _update_omni()


func _update_herbi():
    _herbi_label.text = _make_label_text(HERBI_TEXT, _herbi_count)


func _update_carni():
    _carni_label.text = _make_label_text(CARNI_TEXT, _carni_count)


func _update_omni():
    _omni_label.text = _make_label_text(OMNI_TEXT, _omni_count)


func _make_label_text(prefix: StringName, count: int) -> String:
    return str(prefix) + ": " + str(count)


func _on_creature_spawned(config: CreatureConfig):
    _update_hud_with_config(config, 1)


func _on_creature_died(config: CreatureConfig):
    _update_hud_with_config(config, -1)
