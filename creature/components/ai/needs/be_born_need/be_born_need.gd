class_name BeBornNeed
extends AbstractNeed


var _script: StagedScript
var _is_born: bool = false


func _init(actor: Creature):
    super(actor)
    _script = StagedScript.new([
        BirthStage.make_factory(actor)
    ] as Array[AbstractStageFactory])


func is_actual() -> bool:
    return not _is_born


func can_interrupt() -> bool:
    return _is_born


func update(delta: float):
    _script.update(delta)


func activate():
    _script.script_ended.connect(_on_script_ended)
    _script.start()


func reset():
    _script.script_ended.disconnect(_on_script_ended)
    _script.stop()


func _on_script_ended():
    _is_born = true
