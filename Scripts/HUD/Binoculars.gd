class_name Binoculars extends Rotator

#@export var direction_indicator_prefab : PackedScene 

@export_range(0,1) var movement_speed_modifier : float  = 0

#var _direction_indicator : DirectionIndicator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	on_drag_start.connect(start)
	on_drag_end.connect(stop)


func start() -> void:
	PlayerCharacter.start_using_tool(movement_speed_modifier)
	
	#_direction_indicator = direction_indicator_prefab.instantiate()
	#PlayerCharacter.instance.add_child(_direction_indicator)
	#_direction_indicator.indicator_position_y = 0
	
	call_deferred("digging")

func digging() -> void:
	
	PlayerCharacter.camera.position_smoothing_enabled = true
	PlayerCharacter.camera.position_smoothing_speed = 2.0
	while(is_dragging):
		#print("indicator value = " + str())
		#_direction_indicator.indicator_position_y = clamp(remap(value_y_only,0,1,-1,1),-1,1)
		PlayerCharacter.camera.position = Vector2.ZERO.lerp(dragged_object.global_position - Vector2(180,120),0.5) #- PlayerCharacter.instance.global_position
		#print("offset = " + str(dragged_object.global_position - PlayerCharacter.instance.global_position))
		
		await get_tree().process_frame
	
	PlayerCharacter.camera.position_smoothing_speed = 10
	PlayerCharacter.camera.position = Vector2.ZERO
	await get_tree().create_timer(0.4).timeout
	#while (PlayerCharacter.instance.global_position - PlayerCharacter.camera.get_screen_center_position()).length_squared() > 4:
		#await get_tree().process_frame
	
	PlayerCharacter.camera.position_smoothing_enabled = false
	
#func _process(delta: float) -> void:
	#print(str())


func stop() -> void:
	PlayerCharacter.stop_using_tool()
	
	#if _direction_indicator != null:
		#_direction_indicator.queue_free()
		#_direction_indicator = null
