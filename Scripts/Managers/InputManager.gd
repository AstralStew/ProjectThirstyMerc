class_name InputManager extends Node
static var instance : InputManager = null
const DEBUG_NAME : String = "[b][InputManager][/b] "
func _enter_tree() -> void:
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)

@export var is_using_tool: bool = false
@export var current_tool: Rotator = null

var last_tool_position : Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_using_tool:
		if current_tool == Bag.get_tool_1 and !Input.is_action_pressed("UseTool1"):
			stop_using_tool()
		elif current_tool == Bag.get_tool_2 and !Input.is_action_pressed("UseTool2"):
			stop_using_tool()
		elif current_tool == Bag.get_tool_3 and !Input.is_action_pressed("UseTool3"):
			stop_using_tool()
		else:
			current_tool.dragging()
	else:
		if Input.is_action_just_pressed("UseTool1") and Bag.get_tool_1 != null:
			start_using_tool(Bag.get_tool_1)
		elif Input.is_action_just_pressed("UseTool2") and Bag.get_tool_2 != null:
			start_using_tool(Bag.get_tool_2)
		elif Input.is_action_just_pressed("UseTool3") and Bag.get_tool_3 != null:
			start_using_tool(Bag.get_tool_3)

func start_using_tool(tool:Rotator) -> void:
	is_using_tool = true
	current_tool = tool
	current_tool.is_controlled_by_keyboard = true
	current_tool.start_drag()

func stop_using_tool() -> void:
	current_tool.end_drag()
	current_tool.is_controlled_by_keyboard = false
	current_tool = null
	is_using_tool = false
