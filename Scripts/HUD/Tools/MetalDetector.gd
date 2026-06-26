class_name MetalDetector extends Rotator

@export var direction_indicator_prefab : PackedScene 
@onready var light: ColorRect = $Gfx/Light
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var beep_range_near: float = 20
@export var beep_range_far: float = 100

@export var beep_frequency_near: float = 0.05
@export var beep_frequency_far: float = 2.0

@export_range(0,1) var movement_speed_modifier : float  = 0.5

var _direction_indicator : DirectionIndicator

@export_group("READ ONLY")
@export var light_on:bool = false
var pitch_target = 1.0
var volume_target = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	on_drag_start.connect(start)
	on_drag_end.connect(stop)


func start() -> void:
	PlayerCharacter.start_using_tool(movement_speed_modifier)
	
	_direction_indicator = direction_indicator_prefab.instantiate()
	#WorldManager.effects_root.add_child(_direction_indicator)
	PlayerCharacter.instance.add_child(_direction_indicator)
	_direction_indicator.indicator_rotation = 0
	(_direction_indicator as MetalDetectorIndicator).beep_range_near = beep_range_near
	(_direction_indicator as MetalDetectorIndicator).on_detected.connect(on_detected)
	
	audio_stream_player.play()
	
	z_index = -5
	
	call_deferred("detecting")


func on_detected() -> void:
	if instructions_ui == null: return
	if on_drag_end.is_connected(instructions_ui.disappear):
		on_drag_end.disconnect(instructions_ui.disappear)
	instructions_ui.disappear()
	instructions_ui = null
	instructions = ""


func detecting() -> void:
	var _elapsed_time:float = 0.0
	var _beep_off_time:float = 0.0
	var _beep_on_time:float = 0.25
	var _distance:float = 0.0
	var old_distance:float = 0.0
	var near_range_sqr:float = beep_range_near ** 2
	var far_range_sqr:float = beep_range_far ** 2
	
	control_pitch()
	while(is_dragging):
		#print("indicator value = " + str())
		_direction_indicator.indicator_rotation = clamp(remap(value,0,1,-1,1),-1,1)
		old_distance = _distance
		_distance = (_direction_indicator as MetalDetectorIndicator).current_distance
		
		#audio_stream_player.pitch_scale = remap(clamp(_distance,near_range_sqr,far_range_sqr),near_range_sqr,far_range_sqr,1.5,0.5)
				
		#print("pitch_target = " + str(pitch_target) + ", actual pitch = " + str(audio_stream_player.pitch_scale))
		_elapsed_time += get_process_delta_time()
		if _distance < near_range_sqr:
			if !light_on:
				_elapsed_time = 0
				turn_light_on()
				#audio_stream_player.pitch_scale = 2.0
				#audio_stream_player.volume_db = -35
			#audio_stream_player.pitch_scale = 2.0
			pitch_target = 2.0
			volume_target = 1.0
		elif _distance < far_range_sqr:
			if old_distance == 100000:
				_elapsed_time = 0
				turn_light_on()
				#audio_stream_player.pitch_scale = 1.0
				pitch_target = clamp(remap(_distance,near_range_sqr,far_range_sqr,1.25,0.5),0.5,1.25)
				volume_target = 1.0
				#audio_stream_player.volume_db = -35
				
			elif light_on:
				_beep_on_time = clamp(remap(_distance,near_range_sqr,far_range_sqr,beep_frequency_near,beep_frequency_far),beep_frequency_near,beep_frequency_far)
				pitch_target = clamp(remap(_distance,near_range_sqr,far_range_sqr,1.25,0.5),0.5,1.25)
				if _elapsed_time > _beep_on_time:
					_elapsed_time = 0
					turn_light_half()
					pitch_target = 0.75
					volume_target = 0.0
					#audio_stream_player.volume_db = -50
				#audio_stream_player.pitch_scale = 0.5
				
			else:
				_beep_off_time = clamp(remap(_distance,near_range_sqr,far_range_sqr,beep_frequency_near,beep_frequency_far),beep_frequency_near,beep_frequency_far)
				if _elapsed_time > _beep_off_time:
					_elapsed_time = 0
					turn_light_on()
					#audio_stream_player.volume_db = -35
					#audio_stream_player.pitch_scale = 1.0
					pitch_target = clamp(remap(_distance,near_range_sqr,far_range_sqr,1.25,0.5),0.5,1.25)
					volume_target = 1.0
		else:
			turn_light_off()
			#audio_stream_player.pitch_scale = 1.0
			pitch_target = 0.1
			volume_target = 0.0
			#audio_stream_player.volume_db = -80
		
		#print("_elapsed_time = " + str(_elapsed_time) + ", beep time = " + str(_beep_time) + ", _distance = " + str(_distance))
		await get_tree().process_frame
	
	
	_elapsed_time = 0

func turn_light_on() -> void:
	light_on = true
	light.color = Color(0.824, 0.925, 0.6, 1.0) 

func turn_light_half() -> void:
	light_on = false
	light.color = Color(0.329, 0.604, 0.553, 1.0)

func turn_light_off() -> void:
	light_on = false
	light.color = Color(0.82, 0.314, 0.357, 1.0)

func control_pitch() -> void:
	while (is_dragging):
		if !is_equal_approx(audio_stream_player.pitch_scale, pitch_target):
			#if pitch_target == 2.0:
				#audio_stream_player.pitch_scale = pitch_target
				#audio_stream_player.volume_linear = 0.2 * volume_target
			#elif pitch_target == 0.1:
				#audio_stream_player.pitch_scale = pitch_target
				#audio_stream_player.volume_linear = volume_target
			#else:
				#audio_stream_player.pitch_scale = move_toward(audio_stream_player.pitch_scale,pitch_target,0.5 * get_process_delta_time())
				audio_stream_player.pitch_scale = lerpf(audio_stream_player.pitch_scale,pitch_target,0.1)  #* get_process_delta_time())
				audio_stream_player.volume_linear = 0.2 * clamp(lerpf(audio_stream_player.volume_linear,volume_target,0.1),0,1)  #0.05 * linear_to_db(clamp(audio_stream_player.pitch_scale,0,1)) #  lerpf(audio_stream_player.volume_db,linear_to_db(0.1 * remap(clamp(audio_stream_player.pitch_scale,0.5,1),0.5,1,0,1)),0.2)  #* get_process_delta_time())
		await get_tree().process_frame

func stop() -> void:
	PlayerCharacter.stop_using_tool()
	
	turn_light_off() 
	audio_stream_player.stop()
	
	z_index = 0
	
	if _direction_indicator != null:
		_direction_indicator.queue_free()
		_direction_indicator = null
