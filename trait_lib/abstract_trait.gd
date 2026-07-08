class_name AbstractTrait
extends RefCounted


var _name: String
var _description: String


var name: String:
    get():
        return _name


var description: String:
    get():
        return _description


func patch_config(_config: CreatureConfig):
    pass
