class_name AudioManager extends Node
static var instance : AudioManager = null
const DEBUG_NAME : String = "[b][AudioManager][/b] "
func _enter_tree() -> void:
	instance = self





const UI_POP_UP : AudioStream = preload("uid://c0dp42bg2mio4")
const CASH_REGISTER : AudioStream = preload("uid://cofymlbl5yxhp")
const SHOP_DOOR_BELL : AudioStream = preload("uid://uwkj1u5fh6ow")
const FOOTSTEPS : AudioStream  = preload("uid://b211s3nge70eq")
const PHONE_VIBRATION : AudioStream  = preload("uid://bkfpf6cphoj2b")
const COINS : AudioStream  = preload("uid://lk6idc4bjvhj")
const DIG_UP : AudioStream = preload("uid://nbf0dv3niolu")
const DIG_DOWN : AudioStream = preload("uid://71fjns0a228b")
const PICKUP : AudioStream = preload("uid://bpd11uw8m72hi")
const COLLECTABLE_REVEAL : AudioStream = preload("uid://bum5g1phyeffn")
const SWEEP = preload("uid://wmk8u0tcdaad")
const INSTRUCTIONS = preload("uid://bhdausagepfi")
const ERROR = preload("uid://b0ualfpwqubgl")









static func play_sound(stream:AudioStream,volume:float = 1.0,pitch_scale:float=1.0, start_time:float=-1.0,end_time:float=-1.0) -> AudioStreamPlayer:
	return instance._play_sound(stream,volume,pitch_scale, start_time,end_time)
func _play_sound(stream:AudioStream,volume:float = 1.0,pitch_scale=1.0, start_time:float=-1.0,end_time:float=-1.0) -> AudioStreamPlayer:
	
	var new_audio_player = AudioStreamPlayer.new()
	if Main.current_scene_type == Main.Scene.GAME:
		WorldManager.effects_root.add_child(new_audio_player)
	else:
		add_child(new_audio_player)
	new_audio_player.stream = stream
	new_audio_player.volume_linear = volume
	new_audio_player.pitch_scale = pitch_scale
	
	if end_time > 0:
		var _timer = get_tree().create_timer((end_time - max(0,start_time)) * (1/pitch_scale)).timeout.connect(func():new_audio_player.queue_free())
	else:
		new_audio_player.finished.connect(func():new_audio_player.queue_free())
	
	if start_time > 0:
		new_audio_player.call_deferred("play",start_time)
	else:
		new_audio_player.call_deferred("play")
	
	return new_audio_player
	
