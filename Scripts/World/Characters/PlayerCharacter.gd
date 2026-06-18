class_name PlayerCharacter extends MovingAgent
static var instance : PlayerCharacter = null
const DEBUG_NAME : String = "[b][PlayerCharacter][/b] "

static var camera : Camera2D = null

@export var camera_base_offset : Vector2  = Vector2(0,16)
@export var player_move_target : Node2D

@export var move_to_dialogue_start_distance: float = 20.0

@export_group("READ ONLY")
@export var base_movement_speed : float = 0.0
@export var is_using_tool : bool = false
@export var is_talking: bool = false
@export var sqr_distance_to_target : float = 0.0

var _click_held_down: bool = false
var _npc_target:NPCharacter = null

func _enter_tree() -> void:
	instance = self
	base_movement_speed = movement_speed
	if player_move_target != null: player_move_target.visible = false

func _ready():
	super._ready()
	camera = $Camera2D
	camera.offset = camera_base_offset
	adjusting_move_target()
	
	WorldManager.day_started().connect(start_day)
	WorldManager.day_ended().connect(end_day)



func start_day() -> void:
	is_talking = true
	await get_tree().create_timer(3.5).timeout
	
	start_shopping()
	

func end_day() -> void:
	is_talking = true
	_click_held_down = false
	
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		_click_held_down = true
	elif event.is_action_released("Click"):
		_click_held_down = false

func _physics_process(delta):
	if is_talking: return
	sqr_distance_to_target = global_position.distance_squared_to(navigation_agent.target_position)
	if _npc_target:
		if _click_held_down:
			_npc_target = null
		#elif global_position.distance_squared_to(_npc_target.global_position) < move_to_dialogue_start_distance**2:
		elif sqr_distance_to_target < move_to_dialogue_start_distance**2:
			start_talking()
		else:
			set_movement_target(_npc_target.global_position + Vector2(0,6))
			#if player_move_target != null:
				#player_move_target.visible = false
	if _click_held_down:
		set_movement_target(get_global_mouse_position())
	if player_move_target != null:
		if navigation_agent.is_navigation_finished(): 
			player_move_target.visible = false
		else:
			player_move_target.set_deferred("global_position", navigation_agent.get_final_position()) #) .global_position = get_global_mouse_position()
			player_move_target.visible = true
	super._physics_process(delta)




func start_shopping() -> void:
	#get_tree().paused = true
	set_deferred("is_talking", true)
	set_movement_target(global_position)
	WorldManager.pause_day()
	Bag.set_tools_usable(false)
	HudManager.start_shop() # .start_dialogue((_npc_target.global_position - global_position)/2)

static func stop_shopping() -> void:
	instance._stop_shopping()
func _stop_shopping() -> void:
	WorldManager.resume_day()
	Bag.set_tools_usable(true)
	is_talking = false



var _talking_tween: Tween
func start_talking() -> void:
	#get_tree().paused = true
	set_deferred("is_talking", true)
	set_movement_target(global_position)
	_npc_target.start_talking()
	WorldManager.pause_day()
	Bag.set_tools_usable(false)
	HudManager.start_dialogue((_npc_target.global_position - global_position)/2)


static func move_to_start_dialogue(npc:NPCharacter) -> void:
	instance._move_to_start_dialogue(npc)
func _move_to_start_dialogue(npc:NPCharacter) -> void:
	if _click_held_down: return
	if is_using_tool: return
	if is_talking: return
	_click_held_down = false
	print(DEBUG_NAME,"StartDialogue > Got here!")
	
	_npc_target = npc
	set_movement_target(_npc_target.global_position)

static func stop_dialogue() -> void:
	instance._stop_dialogue()
func _stop_dialogue() -> void:
	_npc_target.stop_talking()
	_npc_target = null
	WorldManager.resume_day()
	Bag.set_tools_usable(true)
	is_talking = false


func on_navigation_finished() -> void:
	if movement_speed == 0:
		super.on_navigation_finished()
	if player_move_target != null:
		player_move_target.visible = false

func set_movement_target(movement_target: Vector2):
	super.set_movement_target(movement_target)
	if is_talking: return
	if movement_target.distance_squared_to(PlayerCharacter.instance.global_position) < navigation_agent.target_desired_distance ** 2:
		movement_direction = movement_target.direction_to(PlayerCharacter.instance.global_position)
		player_move_target.visible = true
		player_move_target.set_deferred("visible",false)



func adjusting_move_target() -> void:
	var _circle: Panel = player_move_target.get_child(0)
	var _colour_dark = Color(0.329, 0.604, 0.553) 
	var _colour_light = Color(0.824, 0.925, 0.6)
	var _target_colour = _colour_dark
	#var _is_light = false
	var _elapsed = 0
	while true:
		await get_tree().physics_frame
		if player_move_target.visible:
			if _npc_target: 	_circle.size = Vector2.ONE * 12
			else: 			_circle.size = Vector2.ONE * 6
			_elapsed += get_physics_process_delta_time()
			if _elapsed > 1.0:
				_elapsed = 0
				_target_colour = _colour_dark if _target_colour == _colour_light else _colour_light
			player_move_target.modulate = Color(_target_colour,clampf(sqr_distance_to_target/1000,0.25,1.25) - 0.25)
			#print("dist = " + str(clampf(sqr_distance_to_target/1000,0.5,1.5) - 0.5))
			#_is_light = !_is_light




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
