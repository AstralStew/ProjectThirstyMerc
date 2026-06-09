class_name PlayerCharacter extends MovingAgent

#@export var acceleration: float = 10.0
#@export var min_movement_speed: float = 10.0
#@export var max_movement_speed: float = 50.0

var _target_reached: bool = false
var _click_held_down: bool = false
var _path_length: float = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		_click_held_down = true
	elif event.is_action_released("Click"):
		_click_held_down = false

func _physics_process(delta):
	if _click_held_down:
		set_movement_target(get_global_mouse_position())	
	elif navigation_agent.is_navigation_finished():
		return
	
	#movement_speed = lerpf(close_movement_speed,far_movement_speed,clampf(_path_length/far_distance,0,1))
	
	super._physics_process(delta)
