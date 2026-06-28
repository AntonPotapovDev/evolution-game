class_name CreatureConfig
extends RefCounted


var diet: Array[StringName]
var is_hunter: bool


static func make_default() -> CreatureConfig:
    var config = CreatureConfig.new()

    config.diet = [ Groups.PLANT_FOOD ] as Array[StringName]
    config.is_hunter = false

    return config


func clone() -> CreatureConfig:
    var config = CreatureConfig.new()

    config.diet = diet.duplicate()
    config.is_hunter = is_hunter

    return config
