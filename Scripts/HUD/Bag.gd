class_name Bag extends Control
static var instance : Bag = null
const DEBUG_NAME : String = "[b][Bag][/b] "
func _enter_tree() -> void:
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)


#const BINOCULARS: PackedScene = preload("uid://b0qruvc8r4wfn")
#const METAL_DETECTOR: PackedScene = preload("uid://dt5agm7wja7gl")
#const SHOVEL: PackedScene = preload("uid://d3v2idfvg2d2q")

#enum ToolType {NONE,BINOCULARS,SHOVEL,METAL_DETECTOR}

@onready var bag_background: Polygon2D = $BagBackground


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
		#if bag_progress == value: return
		bag_progress = clamp(value,0,1)
		if value == 0:
			instance.visible = false
		elif value > 0:
			instance.visible = true
		instance.position.y = 70 * (1-value)
		bag_progress = value

static var is_full:bool:
	get:
		print("is full = " + str(instance.tool_1 != null) + " + " + str(instance.tool_2 != null) + " + " + str(instance.tool_3 != null))
		return (instance.tool_1 != null && instance.tool_2 != null && instance.tool_3 != null)

var index: int :
	get: return (
		(1 if (instance.tool_1!=null) else 0) + 
		(1 if (instance.tool_2!=null) else 0) + 
		(1 if (instance.tool_3!=null) else 0) )

#func _ready() -> void:
	#bag_progress = 0

static func check_if_have_tool(tool_type:ToolType) -> bool:
	match tool_type.name:
		"Long Brush":
			return instance.tool_1 is Brush || instance.tool_2 is Brush || instance.tool_3 is Brush
		"Magnifying Glass":
			return instance.tool_1 is MagnifyingGlass || instance.tool_2 is MagnifyingGlass || instance.tool_3 is MagnifyingGlass
		"Metal Detector":
			return instance.tool_1 is MetalDetector || instance.tool_2 is MetalDetector || instance.tool_3 is MetalDetector
		"Old Shovel":
			return instance.tool_1 is Shovel || instance.tool_2 is Shovel || instance.tool_3 is Shovel
		"Binoculars":
			return instance.tool_1 is Binoculars || instance.tool_2 is Binoculars || instance.tool_3 is Binoculars
	return false


static func set_tools_usable(toggle:bool=true) -> void:
	instance._set_tools_usable(toggle)
func _set_tools_usable(toggle:bool=true) -> void:
	if tool_1:
		tool_1.is_usable = toggle
		print_rich(DEBUG_NAME,"SetToolsUsable > Toggled tool 1 '" + tool_1.name + ("' on" if toggle else "off"))
	if tool_2:
		tool_2.is_usable = toggle
		print_rich(DEBUG_NAME,"SetToolsUsable > Toggled tool 2 '" + tool_2.name + ("' on" if toggle else "off"))
	if tool_3:
		tool_3.is_usable = toggle
		print_rich(DEBUG_NAME,"SetToolsUsable > Toggled tool 3 '" + tool_3.name + ("' on" if toggle else "off"))
	
	phone.is_usable = toggle
	notepad.is_usable = toggle
	print_rich(DEBUG_NAME,"SetToolsUsable > Toggled phone + notepad " + ("on" if toggle else "off"))

static func setup_tool(tool_type:ToolType) -> bool:
	if instance.index >= 3:
		push_error("TOO MANY ITEMS")
		return false
	else:
		instance._setup_tool(tool_type)
		return true
func _setup_tool(tool_type:ToolType) -> void:
	var pivot:Control
	match index:
		0: pivot = tool_pivot_1
		1: pivot = tool_pivot_2
		2: pivot = tool_pivot_3
		_:
			push_error(DEBUG_NAME,"SetupTool > Bad index provided! ("+str(index)+")")
			return
	
	if !pivot.visible:
		pivot.visible = true
		await get_tree().process_frame
		_tool_pivots_moved.emit()
	
	#var prefab = tool_type.prefab # get_tool_prefab_from_tool_type(tool_type)
	var new_tool:Rotator = tool_type.prefab.instantiate()
	bag_background.add_sibling(new_tool)
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

#
#func get_tool_prefab_from_tool_type(tool_type:ToolType) -> PackedScene:
	#match tool_type:
		#ToolType.BINOCULARS: return BINOCULARS
		#ToolType.SHOVEL: return SHOVEL
		#ToolType.METAL_DETECTOR: return METAL_DETECTOR
		#
		#_:
			#push_error(DEBUG_NAME,"SetupTool > Bad tool type provided! ("+str(ToolType.keys()[tool_type])+")")
			#return null
	#
