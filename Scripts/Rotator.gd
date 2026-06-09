class_name Rotator extends Control

@export var position_bounds : Array[Vector2]
@export var rotation_bounds : Vector2

@export var reset_on_inactive : bool

@export_category("READ ONLY")

@export var is_rotating : bool = false

var _total_diff : Vector2
var _current_diff : Vector2
var _weight : float
var _initial_rotation : float

func _ready() -> void:
	_total_diff = position_bounds[1] - position_bounds[0]
	
	if reset_on_inactive: _initial_rotation = rotation_degrees

func set_active(active:bool) -> void:
	is_rotating = active
	
	if reset_on_inactive:
		if active: _initial_rotation = rotation_degrees
		else: rotation_degrees = _initial_rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_rotating: return
	if _total_diff.is_zero_approx(): return 
	
	_current_diff = position - position_bounds[0]
	_weight = _current_diff.dot(_total_diff) / _total_diff.length_squared()
	
	rotation_degrees = lerpf(rotation_bounds.x,rotation_bounds.y,_weight)
