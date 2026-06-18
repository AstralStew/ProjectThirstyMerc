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
	
	(_direction_indicator as ShovelIndicator).dig_down.connect(dig_flash)
	(_direction_indicator as ShovelIndicator).dig_up.connect(dig_flash)
	
	z_index = -5
	
	call_deferred("digging")

func digging() -> void:
	
	while(is_dragging):
		#print("indicator value = " + str())
		_direction_indicator.indicator_position_y = clamp(remap(value_y_only,0,1,-1,1),-1,1)
		
		await get_tree().process_frame

var _dig_tween:Tween
func dig_flash() -> void:
	print("derp")
	modulate = Color.WHITE * 2
	if _dig_tween: _dig_tween.kill()
	_dig_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_dig_tween.tween_property(self,"modulate",Color.WHITE,0.42)

func stop() -> void:
	PlayerCharacter.stop_using_tool()
	
	z_index = 0
	
	if _direction_indicator != null:
		_direction_indicator.queue_free()
		_direction_indicator = null
