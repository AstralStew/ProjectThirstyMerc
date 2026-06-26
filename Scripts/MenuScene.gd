extends Node



@onready var leave: Button = $Leave
@onready var shore_audio: AudioStreamPlayer2D = $ShoreAudio


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leave.pressed.connect(close)
	open() 

var _tween:Tween
func open() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(shore_audio,"volume_linear",1,1.5).from(0)
	_tween.tween_callback(ScreenBars.activate.bind(0,1.5)).set_delay(0.5)
	await get_tree().create_timer(3).timeout
	leave.modulate = Color.WHITE
	leave.disabled = false


func close() -> void:
	AudioManager.play_sound(AudioManager.UI_POP_UP,1,0.8)
	ScreenBars.change_color(Color(0.231, 0.075, 0.169, 1.0))
	leave.modulate = Color(Color.WHITE,0)
	leave.disabled = true
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_callback(ScreenBars.activate.bind(1,2.0))
	_tween.tween_property(shore_audio,"volume_linear",0,2).from(1)
	
	await get_tree().create_timer(3).timeout
	Main.change_current_scene(Main.Scene.GAME)
	
