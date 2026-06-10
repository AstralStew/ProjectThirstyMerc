class_name Dragger extends Control

@export var dragged_object : NodePath
@export var position_bounds : Array[Vector2]

@export var reset_on_drag_end : bool

@export_category("READ ONLY")

@export var is_dragging : bool = false
@export var value : float

var _dragged_object : CanvasItem
var _initial_position : Vector2

var _total_diff : Vector2
var _current_diff : Vector2

signal on_drag_start
signal on_drag_end


func _ready() -> void:
	_dragged_object = get_node(dragged_object)
	if reset_on_drag_end: _initial_position = _dragged_object.position
	
	_total_diff = position_bounds[1] - position_bounds[0]

func _process(delta: float) -> void:
	if !is_dragging: return
	if _total_diff.is_zero_approx(): return 
	
	_current_diff = _dragged_object.position - position_bounds[0]
	value = _current_diff.dot(_total_diff) / _total_diff.length_squared()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		is_dragging = true
		on_drag_start.emit()
	elif event.is_action_released("Click"):
		is_dragging = false
		if reset_on_drag_end: _dragged_object.position = _initial_position
		on_drag_end.emit()
	
	if is_dragging && event is InputEventMouseMotion:
		_dragged_object.position = ((_dragged_object.position as Vector2) + event.relative).clamp(position_bounds[0],position_bounds[1])
