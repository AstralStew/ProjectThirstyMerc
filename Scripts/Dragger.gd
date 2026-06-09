class_name Dragger extends Control

@export var dragged_object : NodePath
@export var position_bounds : Array[Vector2]

@export var reset_on_drag_end : bool

@export_category("READ ONLY")

@export var is_dragging : bool = false

var _initial_position : Vector2

signal on_drag_start
signal on_drag_end


func _ready() -> void:
	if reset_on_drag_end: _initial_position = get_node(dragged_object).position


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		is_dragging = true
		on_drag_start.emit()
	elif event.is_action_released("Click"):
		is_dragging = false
		if reset_on_drag_end: get_node(dragged_object).position = _initial_position
		on_drag_end.emit()
	
	if is_dragging && event is InputEventMouseMotion:
		var _node = get_node(dragged_object)
		_node.position = ((_node.position as Vector2) + event.relative).clamp(position_bounds[0],position_bounds[1])
