class_name StagedScript
extends RefCounted


signal script_ended


var _current_stage: AbstractStage = null
var _current_stage_idx: int = -1
var _stage_factories: Array[AbstractStageFactory]


func _init(stage_factories: Array[AbstractStageFactory]):
    _stage_factories = stage_factories


func update(delta: float):
    if not _current_stage:
        return

    match _current_stage.update(delta):
        AbstractStage.Result.SUCCESS:
            _switch_to_next_stage()
        AbstractStage.Result.FAIL:
            _restart_script()
        _:
            pass


func start():
    if _current_stage:
        return

    _current_stage_idx = 0
    _start_current_stage()


func stop():
    if not _current_stage:
        return

    _stop_current_stage()
    _current_stage_idx = -1


func _switch_to_next_stage():
    _stop_current_stage()

    _current_stage_idx += 1
    if _current_stage_idx >= _stage_factories.size():
        script_ended.emit()
        _current_stage_idx = 0

    _start_current_stage()


func _restart_script():
    _stop_current_stage()
    script_ended.emit()
    _current_stage_idx = 0
    _start_current_stage()


func _start_current_stage():
    _current_stage = _stage_factories[_current_stage_idx].make()
    _current_stage.start()


func _stop_current_stage():
    _current_stage.stop()
    _current_stage = null
