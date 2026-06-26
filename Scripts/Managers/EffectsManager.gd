class_name EffectsManager extends Node
static var instance : EffectsManager = null
const DEBUG_NAME : String = "[b][EffectsManager][/b] "
func _enter_tree() -> void:
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)

@onready var shore_audio: AudioStreamPlayer2D = $"../../World/Effects/ShoreAudio"
@onready var music: AudioStreamPlayer2D = $"../../World/Effects/Music"
#@onready var crickets: AudioStreamPlayer2D = $"../../World/Effects/Crickets"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WorldManager.day_ended().connect(on_day_ended)

var _tween: Tween
func on_day_ended() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel()
	_tween.tween_property(shore_audio,"volume_linear",0,1)
	_tween.tween_property(music,"volume_linear",0,2)
	#_tween.tween_callback(crickets.play)
	#_tween.tween_property(crickets,"volume_linear",0.75,2)
