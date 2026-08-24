class_name ReproduceNeed
extends AbstractNeed


var _script: StagedScript
var _is_giving_birth: bool = false


func _init(actor: Creature):
    super(actor)
    _script = StagedScript.new([
        GiveBirthStage.make_factory(actor)
    ] as Array[AbstractStageFactory])


func is_actual() -> bool:
    return _is_giving_birth or _actor.breeding.ready_for_breeding


func can_interrupt() -> bool:
    return not _is_giving_birth


func update(delta: float):
    _script.update(delta)


func activate():
    _script.script_ended.connect(_on_script_ended)
    _is_giving_birth = true
    _script.start()


func reset():
    _script.script_ended.disconnect(_on_script_ended)
    _script.stop()


func _on_script_ended():
    _is_giving_birth = false
