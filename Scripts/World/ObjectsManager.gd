class_name ObjectsManager extends Node
static var instance : ObjectsManager = null
const DEBUG_NAME : String = "[b][ObjectsManager][/b] "
func _enter_tree() -> void:
	instance = self

@onready var objects: Node2D = $"../../World/Entities/Objects"
static var objects_root : Node2D :
	get: return instance.objects

var middle_top_enabled:bool = true
@onready var middle_top_objects: Array[Node2D] = [
	$"../../World/Entities/Objects/MiddleTop",
	$"../../World/Level/Tilemap/UnderBoardwalkObjects/MiddleTop",
	$"../../World/Entities/Characters/MiddleTop",
]
var middle_enabled:bool = true
@onready var middle_objects: Array[Node2D] = [
	$"../../World/Entities/Objects/Middle",
	$"../../World/Entities/Characters/Middle",
	
]
var middle_bottom_enabled:bool = true
@onready var middle_bottom_objects: Array[Node2D] = [
	$"../../World/Level/Tilemap/UnderBoardwalkObjects/MiddleBottom",
	$"../../World/Entities/Objects/MiddleBottom",
	$"../../World/Entities/Characters/MiddleBottom"
]
var left_enabled:bool = true
@onready var left_objects: Array[Node2D] = [
	$"../../World/Entities/Objects/Left",
	$"../../World/Entities/Characters/Left",
]
var left_far_enabled:bool = true
@onready var left_far_objects: Array[Node2D] = [
	$"../../World/Entities/Objects/LeftFar",
	$"../../World/Level/Tilemap/UnderCliffsObjects/LeftFar",
	$"../../World/Level/Tilemap/UnderBoardwalkObjects/LeftFar",
	$"../../World/Entities/Characters/LeftFar",
]
var right_enabled:bool = true
@onready var right_objects: Array[Node2D] = [
	$"../../World/Entities/Objects/Right",
	$"../../World/Entities/Characters/Right",
]
var right_far_enabled:bool = true
@onready var right_far_objects: Array[Node2D] = [
	$"../../World/Entities/Objects/RightFar",
	$"../../World/Entities/Characters/RightFar"
]

func _ready() -> void:
	call_deferred("watching")

func watching() -> void:
	var player_pos:Vector2 = Vector2.ZERO #= PlayerCharacter.instance.global_position
	await get_tree().create_timer(0.25).timeout
	while (true):
		await get_tree().create_timer(0.69).timeout
		if !is_instance_valid(get_tree()): return
		if PlayerCharacter.instance.global_position == player_pos:
			print_rich(DEBUG_NAME,"Watching > Same position, ignoring.")
			continue
		player_pos = PlayerCharacter.instance.global_position
		
		print_rich(DEBUG_NAME,"Watching > New position = " + str(player_pos))
		if player_pos.x > -400 and player_pos.x < 450  and player_pos.y < -200:
			if !middle_top_enabled:
				enable_node(middle_top_objects)
				middle_top_enabled = true
		else:
			if middle_top_enabled:
				disable_node(middle_top_objects)
				middle_top_enabled = false
		
		if player_pos.x > -650 and player_pos.x < 550  and player_pos.y < 100:
			if !middle_enabled:
				enable_node(middle_objects)
				middle_enabled = true
		else:
			if middle_enabled:
				disable_node(middle_objects)
				middle_enabled = false
	
		if player_pos.x > -650 and player_pos.x < 550  and player_pos.y > -150:
			if !middle_bottom_enabled:
				enable_node(middle_bottom_objects)
				middle_bottom_enabled = true
		else:
			if middle_bottom_enabled:
				disable_node(middle_bottom_objects)
				middle_bottom_enabled = false
		
		
		if  player_pos.x < -800 and player_pos.y < -50:
			if !left_far_enabled:
				enable_node(left_far_objects)
				left_far_enabled = true
		else:
			if left_far_enabled:
				disable_node(left_far_objects)
				left_far_enabled = false
		
		if player_pos.x < -200 and player_pos.y > -250:
			if !left_enabled:
				enable_node(left_objects)
				left_enabled = true
		else:
			if left_enabled:
				disable_node(left_objects)
				left_enabled = false
		
		
		if player_pos.x > 200 and player_pos.y > -250:
			if !right_enabled:
				enable_node(right_objects)
				right_enabled = true
		else:
			if right_enabled:
				disable_node(right_objects)
				right_enabled = false
		
		if player_pos.x > 700 and player_pos.y < -50:
			if !right_far_enabled:
				enable_node(right_far_objects)
				right_far_enabled = true
		else:
			if right_far_enabled:
				disable_node(right_far_objects)
				right_far_enabled = false
		


func enable_node(nodes:Array[Node2D]):
	
	print_rich(DEBUG_NAME,"EnableNode > Nodes = " + str(nodes))
	for child in nodes:
		child.process_mode = PROCESS_MODE_INHERIT
		child.set_deferred("visible", true)

func disable_node(nodes:Array[Node2D]):
	for child in nodes:
		child.visible = false
		child.process_mode = PROCESS_MODE_DISABLED
