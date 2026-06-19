class_name MetalDetector extends Rotator

@export var direction_indicator_prefab : PackedScene 
@onready var light: ColorRect = $Gfx/Light

@export var beep_range_near: float = 20
@export var beep_range_far: float = 100

@export var beep_frequency_near: float = 0.25
@export var beep_frequency_far: float = 3.0

@export_range(0,1) var movement_speed_modifier : float  = 0.5

var _direction_indicator : DirectionIndicator

@export_group("READ ONLY")
@export var light_on:bool = false

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
	
	z_index = -5
	
	call_deferred("detecting")

func detecting() -> void:
	var _elapsed_time:float = 0.0
	var _beep_off_time:float = 0.0
	var _beep_on_time:float = 0.25
	var _distance:float = 0.0
	var old_distance:float = 0.0
	while(is_dragging):
		#print("indicator value = " + str())
		_direction_indicator.indicator_rotation = clamp(remap(value,0,1,-1,1),-1,1)
		old_distance = _distance
		_distance = (_direction_indicator as MetalDetectorIndicator).current_distance
		

		
		_elapsed_time += get_process_delta_time()
		if _distance < beep_range_near ** 2:
			if !light_on:
				_elapsed_time = 0
				turn_light_on()
		elif _distance < beep_range_far ** 2:
			if old_distance == 100000:
				_elapsed_time = 0
				turn_light_on()
			if light_on:
				if _elapsed_time > _beep_on_time:
					_elapsed_time = 0
					turn_light_off()
			else:
				_beep_off_time = clamp(remap(_distance,beep_range_near**2,beep_range_far**2,beep_frequency_near,beep_frequency_far),beep_frequency_near,beep_frequency_far)
				if _elapsed_time > _beep_off_time:
					_elapsed_time = 0
					turn_light_on()
		else:
			turn_light_off()
		
		#print("_elapsed_time = " + str(_elapsed_time) + ", beep time = " + str(_beep_time) + ", _distance = " + str(_distance))
		await get_tree().process_frame
	
	
	_elapsed_time = 0

func turn_light_on() -> void:
	light_on = true
	light.color = Color(0.824, 0.925, 0.6, 1.0) 

func turn_light_off() -> void:
	light_on = false
	light.color = Color(0.82, 0.314, 0.357, 1.0)

func stop() -> void:
	PlayerCharacter.stop_using_tool()
	
	turn_light_off() 
	
	z_index = 0
	
	if _direction_indicator != null:
		_direction_indicator.queue_free()
		_direction_indicator = null
