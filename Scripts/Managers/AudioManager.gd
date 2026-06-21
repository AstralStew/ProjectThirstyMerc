class_name AudioManager extends Node
static var instance : AudioManager = null
const DEBUG_NAME : String = "[b][AudioManager][/b] "
func _enter_tree() -> void:
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)


enum Sounds {UI_POP_UP,CASH_REGISTER,SHOP_DOOR_BELL, FOOTSTEPS,PHONE_VIBRATION, COINS, DIG_UP, DIG_DOWN, PICKUP}

@onready var shore_audio: AudioStreamPlayer2D = $"../../World/Effects/ShoreAudio"
@onready var music: AudioStreamPlayer2D = $"../../World/Effects/Music"
@onready var crickets: AudioStreamPlayer2D = $"../../World/Effects/Crickets"



const UI_POP_UP = preload("uid://c0dp42bg2mio4")
const CASH_REGISTER = preload("uid://cofymlbl5yxhp")
const SHOP_DOOR_BELL = preload("uid://uwkj1u5fh6ow")
const FOOTSTEPS = preload("uid://b211s3nge70eq")
const PHONE_VIBRATION = preload("uid://bkfpf6cphoj2b")
const COINS = preload("uid://lk6idc4bjvhj")
const DIG_UP = preload("uid://nbf0dv3niolu")
const DIG_DOWN = preload("uid://71fjns0a228b")
const PICKUP = preload("uid://bpd11uw8m72hi")
const CRICKETS = preload("uid://7atwfvff1kkn")





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WorldManager.day_ended().connect(on_day_ended)

var _tween: Tween
func on_day_ended() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel()
	_tween.tween_property(shore_audio,"volume_linear",0,1)
	_tween.tween_property(music,"volume_linear",0,2)
	_tween.tween_callback(crickets.play)
	_tween.tween_property(crickets,"volume_linear",0.75,2)



static func play_sound(sound:Sounds,volume:float = 1.0,pitch_scale:float=1.0, start_time:float=-1.0,end_time:float=-1.0) -> void:
	instance._play_sound(sound,volume,pitch_scale, start_time,end_time)
func _play_sound(sound:Sounds,volume:float = 1.0,pitch_scale=1.0, start_time:float=-1.0,end_time:float=-1.0) -> void:
	
	var stream: AudioStream = null
	
	match sound:
		Sounds.UI_POP_UP:
			stream = UI_POP_UP
	
		Sounds.CASH_REGISTER:
			stream = CASH_REGISTER
	
		Sounds.SHOP_DOOR_BELL:
			stream = SHOP_DOOR_BELL
		
		Sounds.FOOTSTEPS:
			stream = FOOTSTEPS
			
		Sounds.PHONE_VIBRATION:
			stream = PHONE_VIBRATION
			
		Sounds.COINS:
			stream = COINS
			
		Sounds.DIG_UP:
			stream = DIG_UP
			
		Sounds.DIG_DOWN:
			stream = DIG_DOWN
			
		Sounds.PICKUP:
			stream = PICKUP
	
	var new_audio_player = AudioStreamPlayer.new()
	WorldManager.effects_root.add_child(new_audio_player)
	new_audio_player.stream = stream
	new_audio_player.volume_linear = volume
	new_audio_player.pitch_scale = pitch_scale
	
	if end_time > 0:
		var _timer = get_tree().create_timer(end_time - max(0,start_time)).timeout.connect(func():new_audio_player.queue_free())
	else:
		new_audio_player.finished.connect(func():new_audio_player.queue_free())
	
	if start_time > 0:
		new_audio_player.call_deferred("play",start_time)
	else:
		new_audio_player.call_deferred("play")
	
	
