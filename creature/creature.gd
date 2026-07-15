class_name Creature
extends Area2D


@onready var _attack: Attack = $Attack
@onready var _selection_control = $CreatureSelectionControl


@warning_ignore("unused_signal")
signal died


var _id: int
var _config: CreatureConfig = null

var _ai: CreatureAI = null
var _health: Health = null
var _energy: Energy = null
var _movement: Movement = null
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


var eating: Eating:
    get:
        return _eating


var breeding: Breeding:
    get:
        return _breeding


var death: Death:
    get:
        return _death


var attack: Attack:
    get:
        return _attack


var selection_control: CreatureSelectionControl:
    get:
        return _selection_control


func init(creature_config: CreatureConfig, new_id: int, initial_state_factory: Callable):
    if _config:
        return

    z_index = Layers.Layer.CREATURE

    _id = new_id
    _config = creature_config

    _health = Health.new(self)
    _energy = Energy.new(self, creature_config.energy_config)
    _movement = Movement.new(self, $MovingAdviser)
    _eating = Eating.new(self)
    area_entered.connect(_eating.on_creature_area_entered)
    _breeding = Breeding.new(self)
    _death = Death.new(self)

    _ai = CreatureAI.new(self, initial_state_factory)

    _updatable_components = [
        _energy,
        _ai,
        _movement
    ]


func _ready() -> void:
    add_to_group(Groups.CREATURE)


func _exit_tree() -> void:
    _ai.deinit()
    area_entered.disconnect(_eating.on_creature_area_entered)


func _physics_process(delta: float) -> void:
    for component in _updatable_components:
        if _death.dead:
            return
        component.update(delta)
