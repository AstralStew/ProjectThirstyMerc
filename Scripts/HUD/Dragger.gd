class_name Dragger extends Control
var DEBUG_NAME: String:
	get: return "[b][" + name + "][/b] "

@export var dragged_object : CanvasItem 
@export var position_bounds : Array[Vector2]

@export var initial_position_offset: Vector2 = Vector2.ZERO
@export var respect_grab_position : bool = false

@export var setup_on_ready : bool = false
@export var reset_on_drag_end : bool
@export var reset_duration : float = 0.25
@export var reset_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var reset_trans: Tween.TransitionType = Tween.TRANS_LINEAR

@export var instructions: String = ""
var instructions_ui : InstructionsUI = null

@export_group("READ ONLY")

@export var is_usable : bool = false :
	get: return is_usable
	set(value):
		is_usable = value
		if value && is_dragging:
			is_dragging = false
			if reset_on_drag_end:
				resetting()
			on_drag_end.emit()
@export var is_dragging : bool = false
@export var value : float
@export var value_x_only : float
@export var value_y_only : float
@export var motion_strength : float
@export var is_resetting : bool = false
@export var is_controlled_by_keyboard: bool = false


#var _dragged_object : CanvasItem
var _initial_position : Vector2

var _total_diff : Vector2
#var _total_diff_x : float
#var _total_diff_y : float
var _current_diff : Vector2

var _grab_pos : Vector2

signal on_drag_start
signal on_drag_end


func _ready() -> void:
	#_dragged_object = get_node(dragged_object)
	
	if setup_on_ready: setup(null)
	
	_total_diff = position_bounds[1] - position_bounds[0]
	
	gui_input.connect(_on_gui_input)
	

func setup(pivot:Control) -> void:
	if pivot:
		print_rich(DEBUG_NAME,"Setup > pivot = " + pivot.name + ", global pos = " + str(pivot.global_position))
		_initial_position = pivot.global_position
		dragged_object.global_position = _initial_position + initial_position_offset
	else:
		_initial_position = dragged_object.global_position
	



func _process(delta: float) -> void:
	if !is_usable: return
	if is_resetting: return
	if !is_dragging: return
	if _total_diff.is_zero_approx(): return 
	
	_current_diff = dragged_object.position - position_bounds[0]
	value = _current_diff.dot(_total_diff) / _total_diff.length_squared()
	value_x_only = clamp(remap(dragged_object.position.x, position_bounds[0].x,position_bounds[1].x,0,1),0,1)
	value_y_only = clamp(remap(dragged_object.position.y, position_bounds[0].y,position_bounds[1].y,0,1),0,1)

var _tween : Tween
func resetting() -> void:
	if is_resetting: return
	is_resetting = true
	
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(reset_ease).set_trans(reset_trans)
	_tween.tween_property(dragged_object,"global_position",_initial_position + initial_position_offset,reset_duration)
	
	while(_tween.is_running()): await get_tree().process_frame
	is_resetting = false

func _on_gui_input(event: InputEvent) -> void:
	if !is_usable: return
	if is_resetting: return
	if is_controlled_by_keyboard: return
	
	if event.is_action_pressed("Click"):
		start_drag()
		
	elif event.is_action_released("Click"):
		end_drag()
	
	if is_dragging:
		dragging()
		
		if event is InputEventMouseMotion and !(event as InputEventMouseMotion).screen_relative.is_zero_approx():
			motion_strength = (event as InputEventMouseMotion).screen_relative.length_squared()
		else:
			motion_strength = 0
		


func start_drag() -> void:
	is_dragging = true
	
	if respect_grab_position:
		_grab_pos = dragged_object.get_local_mouse_position()
	else:
		_grab_pos = Vector2.ZERO
	
	if is_controlled_by_keyboard:
		if _tween: _tween.kill()
		_tween = create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		_tween.tween_property(dragged_object,"position",(get_global_mouse_position() - _grab_pos).clamp(position_bounds[0],position_bounds[1]),reset_duration/3)
		#await get_tree().create_timer(reset_duration/2).timeout2
	else:
		dragged_object.position = (get_global_mouse_position() - _grab_pos).clamp(position_bounds[0],position_bounds[1])
	
	if instructions != "":
		instructions_ui = HudManager.add_instructions(instructions)
		on_drag_end.connect(instructions_ui.disappear)
	
	on_drag_start.emit()

func end_drag() -> void:
	is_dragging = false
	if reset_on_drag_end:
		resetting()
	on_drag_end.emit()

func dragging() -> void:
	dragged_object.position = (get_global_mouse_position() - _grab_pos).clamp(position_bounds[0],position_bounds[1])
