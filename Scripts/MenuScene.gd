extends Node



@onready var leave: Button = $Leave

@onready var black_bars: VBoxContainer = $HUD/BlackBars
@onready var black_bars_top: ColorRect = $HUD/BlackBars/BlackBarsTop
@onready var black_bars_bottom: ColorRect = $HUD/BlackBars/BlackBarsBottom
@onready var shore_audio: AudioStreamPlayer2D = $ShoreAudio


var black_background_progress: float :
	set(value):
		if black_background_progress == value: return
		black_background_progress = clamp(value,0,1)
		if value == 0:
			black_bars.visible = false
		elif value > 0:
			black_bars.visible = true
		black_bars_top.custom_minimum_size.y = 150 * value
		black_bars_bottom.custom_minimum_size.y = 150 * value
		black_background_progress = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leave.pressed.connect(close)
	open() 

var _tween:Tween
func open() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(shore_audio,"volume_linear",1,1.5).from(0)
	#_tween.tween_await(get_tree().create_timer(0.5).timeout)
	_tween.tween_property(self,"black_background_progress",0,1.5).from(1).set_delay(0.5)
	await get_tree().create_timer(3).timeout
	leave.modulate = Color.WHITE
	leave.disabled = false


func close() -> void:
	leave.modulate = Color(Color.WHITE,0)
	leave.disabled = true
	black_bars_top.color = Color(0.231, 0.075, 0.169, 1.0)
	black_bars_bottom.color = Color(0.231, 0.075, 0.169, 1.0)
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(self,"black_background_progress",1,2.0).from(0)
	_tween.tween_property(shore_audio,"volume_linear",0,2).from(1)
	
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")
	
