class_name Bag extends Control
static var instance : Bag = null
const DEBUG_NAME : String = "[b][Bag][/b] "
func _enter_tree() -> void:
	instance = self

const BINOCULARS: PackedScene = preload("uid://b0qruvc8r4wfn")
const METAL_DETECTOR: PackedScene = preload("uid://dt5agm7wja7gl")
const SHOVEL: PackedScene = preload("uid://d3v2idfvg2d2q")

enum ToolType {NONE,BINOCULARS,SHOVEL,METAL_DETECTOR}

@onready var tool_pivot_1: Control = $ToolPivots/ToolPivot1
@onready var tool_pivot_2: Control = $ToolPivots/ToolPivot2
@onready var tool_pivot_3: Control = $ToolPivots/ToolPivot3

@onready var phone: Phone = $Phone
@onready var notepad: Notepad = $Notepad


@export_group("READ ONLY")
@export var tool_1:Rotator = null
@export var tool_2:Rotator = null
@export var tool_3:Rotator = null

signal _tool_pivots_moved
static func tool_pivots_moved() -> Signal:
	return instance._tool_pivots_moved

static var bag_progress: float = 1 :
	set(value):
		if bag_progress == value: return
		bag_progress = clamp(value,0,1)
		if value == 0:
			instance.visible = false
		elif value > 0:
			instance.visible = true
		instance.position.y = 50 * (1-value)
		bag_progress = value

#
func _ready() -> void:
	bag_progress = 0

#func test() -> void:
	#await get_tree().create_timer(3.0).timeout
	#setup_tool(0,ToolType.SHOVEL)
	#await get_tree().create_timer(1.0).timeout
	#setup_tool(1,ToolType.METAL_DETECTOR)
	#await get_tree().create_timer(1.0).timeout
	#setup_tool(2,ToolType.BINOCULARS)


static func set_tools_usable(toggle:bool=true) -> void:
	instance._set_tools_usable(toggle)
func _set_tools_usable(toggle:bool=true) -> void:
	if tool_1: tool_1.is_usable = toggle
	if tool_2: tool_2.is_usable = toggle
	if tool_3: tool_3.is_usable = toggle
	
	phone.is_usable = toggle
	notepad.is_usable = toggle

static func setup_tool(index:int,tool_type:ToolType) -> void:
	instance._setup_tool(index,tool_type)
func _setup_tool(index:int,tool_type:ToolType) -> void:
	var pivot:Control
	match index:
		0: pivot = tool_pivot_1
		1: pivot = tool_pivot_2
		2: pivot = tool_pivot_3
		_:push_error(DEBUG_NAME,"SetupTool > Bad index provided! ("+str(index)+")")
	
	if !pivot.visible:
		pivot.visible = true
		await get_tree().process_frame
		_tool_pivots_moved.emit()
	
	var prefab = get_tool_prefab_from_tool_type(tool_type)
	var new_tool:Rotator = prefab.instantiate()
	add_child(new_tool)
	new_tool.setup(pivot)
	_tool_pivots_moved.connect(func(): new_tool.setup(pivot))
	
	match index:
		0: tool_1 = new_tool
		1: tool_2 = new_tool
		2: tool_3 = new_tool
		_:push_error(DEBUG_NAME,"SetupTool > Bad index provided! ("+str(index)+")")
	

#var _tween: Tween
#func bag_appear() -> void:
	#if _tween: _tween.kill()
	#_tween = create_tween().set_parallel().set_ease(talking_zoom_ease).set_trans(talking_zoom_transition)
	#_tween.tween_property(HudManager,"bag_progress",1,talking_zoom_duration)


func get_tool_prefab_from_tool_type(tool_type:ToolType) -> PackedScene:
	match tool_type:
		ToolType.BINOCULARS: return BINOCULARS
		ToolType.SHOVEL: return SHOVEL
		ToolType.METAL_DETECTOR: return METAL_DETECTOR
		
		_:
			push_error(DEBUG_NAME,"SetupTool > Bad tool type provided! ("+str(ToolType.keys()[tool_type])+")")
			return null
	
