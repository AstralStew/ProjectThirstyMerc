class_name Rotator extends Dragger

enum RotateSource {VALUE,VALUE_X_ONLY,VALUE_Y_ONLY}

@export var rotation_bounds : Vector2
@export var rotate_source : RotateSource = RotateSource.VALUE

var _initial_rotation : float

func _ready() -> void:
	super._ready()
	
	#on_drag_start.connect(set_active.bind(true))
	#on_drag_end.connect(set_active.bind(false))

func setup(pivot:Control) -> void:
	super.setup(pivot)
	_initial_rotation = dragged_object.rotation_degrees


#func set_active(active:bool) -> void:
	
	#if active: _initial_rotation = _dragged_object.rotation_degrees
	#else: _dragged_object.rotation_degrees = _initial_rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if is_resetting: return
	if !is_dragging: return
	if _total_diff.is_zero_approx(): return 
	
	match rotate_source:
		RotateSource.VALUE:
			dragged_object.rotation_degrees = lerpf(rotation_bounds.x,rotation_bounds.y,value)
		RotateSource.VALUE_X_ONLY:
			dragged_object.rotation_degrees = lerpf(rotation_bounds.x,rotation_bounds.y,value_x_only)
		RotateSource.VALUE_Y_ONLY:
			dragged_object.rotation_degrees = lerpf(rotation_bounds.x,rotation_bounds.y,value_y_only)
	


func resetting() -> void:
	super.resetting()
	_tween.tween_property(dragged_object,"rotation_degrees",_initial_rotation,reset_duration)
