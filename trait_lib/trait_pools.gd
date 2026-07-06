class_name TraitPools
extends RefCounted


static var _general_pool: Array[AbstractTrait] = [
    SpeedsterTrait.new()
] as Array[AbstractTrait]


static var _traits_by_id: Dictionary
static var _trait_list: Array[int]


static func _static_init() -> void:
    var id = 0
    for creature_trait in _general_pool:
        _traits_by_id.set(id, creature_trait)
        _trait_list.append(id)
        id += 1


func pick_id(conifg: CreatureConfig) -> Variant:
    var available_ids = _trait_list.filter(
        func(id) -> bool: return not conifg.trait_ids.has(id))

    if available_ids.is_empty():
        return null

    return available_ids.pick_random()


func get_by_id(id: int) -> AbstractTrait:
    return _traits_by_id[id]
