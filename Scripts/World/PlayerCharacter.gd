class_name PlayerCharacter extends MovingAgent
static var instance : PlayerCharacter = null
const DEBUG_NAME : String = "[b][PlayerCharacter][/b] "

@export var player_move_target : Node2D

@export var is_using_tool : bool = false

@export_category("READ ONLY")
@export var base_movement_speed : float = 0.0

var _click_held_down: bool = false


func _enter_tree() -> void:
	instance = self
	base_movement_speed = movement_speed
	if player_move_target != null: player_move_target.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		_click_held_down = true
	elif event.is_action_released("Click"):
		_click_held_down = false

func _physics_process(delta):
	if _click_held_down:
		set_movement_target(get_global_mouse_position())
		if player_move_target != null:
			player_move_target.set_deferred("global_position", navigation_agent.get_final_position()) #) .global_position = get_global_mouse_position()
			player_move_target.visible = true
	super._physics_process(delta)


func on_navigation_finished() -> void:
	if movement_speed == 0:
		super.on_navigation_finished()
	if player_move_target != null:
			player_move_target.visible = false


static func start_using_tool(speed_modifier:float = 0.5) -> void:
	instance._start_using_tool(speed_modifier)
func _start_using_tool(speed_modifier:float = 0.5) -> void:
	print_rich(DEBUG_NAME,"StartUsingTool > Multiplying speed by " + str(speed_modifier))
	is_using_tool = true
	
	if speed_modifier == 0:
		set_movement_target(global_position)
		
		
	
	movement_speed = base_movement_speed * speed_modifier

static func stop_using_tool() -> void:
	instance._stop_using_tool()
func _stop_using_tool() -> void:
	print_rich(DEBUG_NAME,"StopUsingTool > Resetting speed")
	is_using_tool = false
	movement_speed = base_movement_speed
