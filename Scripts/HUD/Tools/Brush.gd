class_name Brush extends Rotator

@export var direction_indicator_prefab : PackedScene 

@export_range(0,1) var movement_speed_modifier : float  = 0.5

@export var audio_motion_strength_bounds : Vector2  = Vector2(15,250)

var _direction_indicator : DirectionIndicator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	on_drag_start.connect(start)
	on_drag_end.connect(stop)


func start() -> void:
	PlayerCharacter.start_using_tool(movement_speed_modifier)
	
	_direction_indicator = direction_indicator_prefab.instantiate()
	(_direction_indicator as BrushIndicator).on_detected.connect(on_detected)
	#WorldManager.effects_root.add_child(_direction_indicator)
	PlayerCharacter.instance.add_child(_direction_indicator)
	_direction_indicator.indicator_rotation = 0
	
	z_index = -5
	
	call_deferred("detecting")

func detecting() -> void:
	var value_above = false
	var audio_min_bound:float = audio_motion_strength_bounds.x ** 2
	var audio_max_bound:float = audio_motion_strength_bounds.y ** 2
	var audio_player : AudioStreamPlayer = null
	while(is_dragging):
		#print("indicator value = " + str())
		_direction_indicator.indicator_rotation = clamp(remap(value,0,1,-1,1),-1,1)
		print("motion strength = " + str(motion_strength) + ", audio min = " + str(audio_min_bound))
		
		if audio_player == null:
			if value > 0.5 and !value_above:
				value_above = true
				audio_player = AudioManager.play_sound(AudioManager.SWEEP,remap(clamp(motion_strength,audio_min_bound,audio_max_bound),audio_min_bound,audio_max_bound,0.1,0.7),0.7 + (randf()/2),0.069,0.35)
			if value < 0.5 and value_above:
				value_above = false
				audio_player = AudioManager.play_sound(AudioManager.SWEEP,remap(clamp(motion_strength,audio_min_bound,audio_max_bound),audio_min_bound,audio_max_bound,0.1,0.7),0.7 + (randf()/2),0.69,0.92)
		await get_tree().process_frame


func on_detected() -> void:
	if instructions_ui == null: return
	if on_drag_end.is_connected(instructions_ui.disappear):
		on_drag_end.disconnect(instructions_ui.disappear)
	instructions_ui.disappear()
	instructions_ui = null
	instructions = ""

func stop() -> void:
	PlayerCharacter.stop_using_tool()
	
	z_index = 0
	
	if _direction_indicator != null:
		_direction_indicator.queue_free()
		_direction_indicator = null
