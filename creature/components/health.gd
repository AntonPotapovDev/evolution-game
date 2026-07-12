class_name Health
extends RefCounted


var _creature: Creature = null
var _hp: int = DefaultValues.MAX_HP


func  _init(creature: Creature):
    _creature = creature


var hp: int:
    get:
        return _hp


func take_damage(damage: int):
    _hp = max(0, _hp - damage)
    if _hp == 0:
        _creature.death.on_death()
