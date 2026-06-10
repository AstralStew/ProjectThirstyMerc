class_name Rotator extends Dragger

#@export var position_bounds : Array[Vector2]
@export var rotation_bounds : Vector2

#@export var reset_on_inactive : bool

#@export_category("READ ONLY")

#@export var is_rotating : bool = false

#var _total_diff : Vector2
#var _current_diff : Vector2
#var _weight : float

var _initial_rotation : float

func _ready() -> void:
	super._ready()
	
	if reset_on_drag_end: _initial_rotation = rotation_degrees
	
	on_drag_start.connect(set_active.bind(true))
	on_drag_end.connect(set_active.bind(false))

func set_active(active:bool) -> void:
	
	if active: _initial_rotation = rotation_degrees
	else: rotation_degrees = _initial_rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	if !is_dragging: return
	if _total_diff.is_zero_approx(): return 
	
	rotation_degrees = lerpf(rotation_bounds.x,rotation_bounds.y,value)
