class_name MagnifyingGlass extends Rotator

@export var direction_indicator_prefab : PackedScene 

@export_range(0,1) var movement_speed_modifier : float  = 0

@export var camera_scale : float  = 2.25
@export var camera_duration : float  = 0.69

@export var transition_duration : float = 0.1
@export var near_scale : float = 1.25
@export var far_scale : float = 0.5

var _direction_indicator : DirectionIndicator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	on_drag_start.connect(start)
	on_drag_end.connect(stop)

#func setup(initial_pos:Vector2) -> void:
	#super.setup(initial_pos)

func start() -> void:
	PlayerCharacter.start_using_tool(movement_speed_modifier)
	
	_direction_indicator = direction_indicator_prefab.instantiate()
	PlayerCharacter.instance.add_child(_direction_indicator)
	_direction_indicator.rotation_degrees = 0
	
	(_direction_indicator as MagnifyingGlassIndicator).on_near.connect(on_near)
	(_direction_indicator as MagnifyingGlassIndicator).on_far.connect(on_far)
	
	z_index = -5
	
	call_deferred("seeing")

func on_near() -> void:
	if is_resetting: return
	print("on near, scale = " + str(Vector2.ONE * near_scale))
	
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_property(dragged_object,"scale",Vector2.ONE * near_scale,transition_duration)

func on_far() -> void:
	if is_resetting: return
	print("on far, scale = " + str(Vector2.ONE * far_scale))
	
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_property(dragged_object,"scale",Vector2.ONE * far_scale,transition_duration)


var _zoom_tween:Tween
func seeing() -> void:
	
	#var original_offset : Vector2 = PlayerCharacter.camera.offset
	#PlayerCharacter.camera.offset = Vector2.ZERO
	#PlayerCharacter.camera.position_smoothing_enabled = true
	#PlayerCharacter.camera.position_smoothing_speed = 2.0
	
	var _original_zoom: Vector2 = PlayerCharacter.camera.zoom
	
	if _zoom_tween: _tween.kill()
	_zoom_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_zoom_tween.tween_property(PlayerCharacter.camera,"zoom",Vector2.ONE * camera_scale,camera_duration)
	
	while(is_dragging):
		#print("indicator value = " + str())
		#_direction_indicator.indicator_position_y = clamp(remap(value_y_only,0,1,-1,1),-1,1)
		#PlayerCharacter.camera.position = Vector2.ZERO.lerp(dragged_object.global_position - Vector2(180,120),camera_move_multiplier) #- PlayerCharacter.instance.global_position
		#print("offset = " + str(dragged_object.global_position - PlayerCharacter.instance.global_position))
		
		await get_tree().process_frame
	
	
	if _zoom_tween: _zoom_tween.kill()
	_zoom_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_zoom_tween.tween_property(PlayerCharacter.camera,"zoom",_original_zoom,camera_duration)
	print("what")
	
	#PlayerCharacter.camera.offset = PlayerCharacter.instance.camera_base_offset
	#PlayerCharacter.camera.position_smoothing_speed = 10
	#PlayerCharacter.camera.position = Vector2.ZERO
	#await get_tree().create_timer(0.4).timeout
	#
	#PlayerCharacter.camera.position_smoothing_enabled = false



func stop() -> void:
	PlayerCharacter.stop_using_tool()
	
	z_index = 0
	
	if _direction_indicator != null:
		_direction_indicator.queue_free()
		_direction_indicator = null

func resetting() -> void:
	super.resetting()
	_tween.tween_property(dragged_object,"scale",Vector2.ONE * 0.8,reset_duration)
