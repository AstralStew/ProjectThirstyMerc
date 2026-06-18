class_name MetalDetector extends Rotator

@export var direction_indicator_prefab : PackedScene 

@export_range(0,1) var movement_speed_modifier : float  = 0.5

var _direction_indicator : DirectionIndicator

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
	
	z_index = -5
	
	call_deferred("detecting")

func detecting() -> void:
	while(is_dragging):
		#print("indicator value = " + str())
		_direction_indicator.indicator_rotation = clamp(remap(value,0,1,-1,1),-1,1)
		await get_tree().process_frame



func stop() -> void:
	PlayerCharacter.stop_using_tool()
	
	z_index = 0
	
	if _direction_indicator != null:
		_direction_indicator.queue_free()
		_direction_indicator = null
