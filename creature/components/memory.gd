class_name Memory
extends RefCounted


var _creature: Creature

var _fields: Array[Field] = [] as Array[Field]


var remembered_fields: Array[Field]:
    get:
        return _fields


func _init(creature: Creature):
    _creature = creature


func update(_delta: float):
    var seen_fields = _creature.vision.seen_fields
    for field in seen_fields:
        if not _fields.has(field):
            _fields.append(field)
