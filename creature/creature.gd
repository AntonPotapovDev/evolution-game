class_name Creature
extends Area2D


@onready var _selection_control: CreatureSelectionControl = $CreatureSelectionControl


@warning_ignore("unused_signal")
signal died


var _id: int
var _config: CreatureConfig = null

var _ai: Ai = null
var _memory: Memory = null
var _health: Health = null
var _energy: Energy = null
var _vision: Vision = null
var _movement: Movement = null
var _stamina: Stamina = null
var _attack: Attack = null
var _eating: Eating = null
var _breeding: Breeding = null
var _death: Death = null

var _updatable_components: Array = []


var id: int:
    get:
        return _id


var config: CreatureConfig:
    get:
        return _config


var health: Health:
    get():
        return _health


var energy: Energy:
    get:
        return _energy


var movement: Movement:
    get:
        return _movement


var stamina: Stamina:
    get:
        return _stamina


var eating: Eating:
    get:
        return _eating


var breeding: Breeding:
    get:
        return _breeding


var memory: Memory:
    get:
        return _memory


var death: Death:
    get:
        return _death


var attack: Attack:
    get:
        return _attack


var vision: Vision:
    get:
        return _vision


var selection_control: CreatureSelectionControl:
    get:
        return _selection_control


func init(creature_config: CreatureConfig, new_id: int):
    if _config:
        return

    z_index = Layers.Layer.CREATURE

    _id = new_id
    _config = creature_config

    _init_creature_color(_get_creature_color())
    _init_node_components()
    _init_simple_components()

    _updatable_components = [
        _energy,
        _vision,
        _memory,
        _ai,
        _movement,
        _stamina
    ]


func _init_node_components():
    _vision = $Vision
    _vision.init(self)

    _attack = $Attack
    _attack.init(_get_creature_color())


func _init_simple_components():
    _health = Health.new(self)
    _energy = Energy.new(self, _config.energy_config)
    _movement = Movement.new(self, _config.movement_config, $MovingAdviser)
    _stamina = Stamina.new(self, _config.stamina_config)
    _eating = Eating.new(self)
    _breeding = Breeding.new(self)
    _death = Death.new(self)
    _memory = Memory.new(self)
    _ai = Ai.new(self)


func _init_creature_color(color: Color):
    var sprite = $Sprite2D
    sprite.self_modulate = color


func _get_creature_color() -> Color:
    match _config.diet_phase:
        CreatureConfig.DietPhase.HERBIVORE:
            return Color.GREEN
        CreatureConfig.DietPhase.OMNIVORE:
            return Color.CYAN
        CreatureConfig.DietPhase.CARNIVORE:
            return Color.TOMATO
        _:
            return Color.WHITE


func _ready() -> void:
    add_to_group(Groups.CREATURE)


func _exit_tree() -> void:
    _ai.deinit()


func _physics_process(delta: float) -> void:
    for component in _updatable_components:
        if _death.dead:
            return
        component.update(delta)
