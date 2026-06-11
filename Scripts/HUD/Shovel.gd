class_name Shovel extends Rotator

@export var direction_indicator_prefab : PackedScene 

@export_range(0,1) var movement_speed_modifier : float  = 0

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
	_direction_indicator.indicator_position_y = 0
	
	z_index = -5
	
	call_deferred("digging")

func digging() -> void:
	
	while(is_dragging):
		#print("indicator value = " + str())
		_direction_indicator.indicator_position_y = clamp(remap(value_y_only,0,1,-1,1),-1,1)
		
		await get_tree().process_frame



func stop() -> void:
	PlayerCharacter.stop_using_tool()
	
	z_index = 0
	
	if _direction_indicator != null:
		_direction_indicator.queue_free()
		_direction_indicator = null
