class_name PlayerCharacter extends MovingAgent
static var instance : PlayerCharacter = null
const DEBUG_NAME : String = "[b][PlayerCharacter][/b] "

static var camera : Camera2D = null
@onready var animated_body: AnimatedSprite2D = $AnimatedBody


@export var camera_base_offset : Vector2  = Vector2(0,16)
@export var player_move_target : Node2D

@export var move_to_shopping_start_distance: float = 20.0
@export var move_to_dialogue_start_distance: float = 20.0
@export var move_to_dialogue_static_start_distance: float = 20.0

@export_group("READ ONLY")
@export var base_movement_speed : float = 0.0
@export var base_dig_strength : int = 1
@export var is_using_tool : bool = false
@export var is_talking: bool = false
@export var is_walking: bool = false
@export var sqr_distance_to_target : float = 0.0

var _click_held_down: bool = false
var _npc_target:NPCharacter = null
var _npc_static_target:NPCharacterStatic = null
var _shop_target:ShopCharacter = null



func _enter_tree() -> void:
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)
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
	await get_tree().create_timer(3.1).timeout
	
	is_talking = false
	#start_shopping()
	

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
		elif sqr_distance_to_target < move_to_dialogue_start_distance**2:
			start_talking()
		else: #if _npc_target.do_wander:
			set_movement_target(_npc_target.global_position + Vector2(0,6))
	elif _npc_static_target:
		if _click_held_down:
			_npc_static_target = null
		elif sqr_distance_to_target < move_to_dialogue_static_start_distance**2:
			start_talking()
		else: # _npc_target.do_wander:
			set_movement_target(_npc_static_target.global_position + Vector2(0,6))
	elif _shop_target:
		if _click_held_down:
			_shop_target = null
		elif sqr_distance_to_target < move_to_shopping_start_distance**2:
			start_shopping()
		#else: set_movement_target(_shop_target.global_position + Vector2(0,6))
	
	if _click_held_down:
		set_movement_target(get_global_mouse_position())
	if player_move_target != null:
		if navigation_agent.is_navigation_finished(): 
			player_move_target.visible = false
		else:
			player_move_target.set_deferred("global_position", navigation_agent.get_final_position()) #) .global_position = get_global_mouse_position()
			player_move_target.visible = true
	#print(str(sqr_distance_to_target))
	if sqr_distance_to_target > 15 && !is_walking:
		is_walking = true
		set_animation()

	super._physics_process(delta)
	
	



#region Shopping

static func move_to_start_shopping(shop:ShopCharacter) -> void:
	instance._move_to_start_shopping(shop)
func _move_to_start_shopping(shop:ShopCharacter) -> void:
	if _click_held_down: return
	print_rich(DEBUG_NAME,"MoveToStartShopping > hmm...")
	if is_using_tool: return
	if is_talking: return
	_click_held_down = false
	print_rich(DEBUG_NAME,"MoveToStartShopping > Setting target shop...")
	
	if _npc_target: _npc_target = null
	if _npc_static_target: _npc_static_target = null
	_shop_target = shop
	set_movement_target(_shop_target.global_position + Vector2(0,6))

func start_shopping() -> void:
	_shop_target.is_shopping = true
	set_deferred("is_talking", true)
	set_movement_target(global_position)
	set_deferred("is_walking",false)
	call_deferred("turn_back")
	
	WorldManager.pause_day()
	Bag.set_tools_usable(false)
	HudManager.start_shop(_shop_target) # .start_dialogue((_npc_target.global_position - global_position)/2)
	#is_walking = false

static func stop_shopping() -> void:
	instance._stop_shopping()
func _stop_shopping() -> void:
	_shop_target.is_shopping = false
	_shop_target = null
	WorldManager.resume_day()
	Bag.set_tools_usable(true)
	is_talking = false

#endregion

#region Talking

static func move_to_start_dialogue(npc:NPCharacter) -> void:
	instance._move_to_start_dialogue(npc)
func _move_to_start_dialogue(npc:NPCharacter) -> void:
	if _click_held_down: return
	if is_using_tool: return
	if is_talking: return
	_click_held_down = false
	print(DEBUG_NAME,"MoveToStartDialogue > Setting target npc...")
	
	if _shop_target: _shop_target = null	
	if _npc_static_target: _npc_static_target = null
	_npc_target = npc
	set_movement_target(_npc_target.global_position)


static func move_to_start_dialogue_static(npc_static:NPCharacterStatic) -> void:
	instance._move_to_start_dialogue_static(npc_static)
func _move_to_start_dialogue_static(npc_static:NPCharacterStatic) -> void:
	if _click_held_down: return
	if is_using_tool: return
	if is_talking: return
	_click_held_down = false
	print(DEBUG_NAME,"MoveToStartDialogue > Setting target npc static...")
	
	if _npc_target: _npc_target = null
	if _shop_target: _shop_target = null
	_npc_static_target = npc_static
	set_movement_target(_npc_static_target.global_position)


#var _talking_tween: Tween
func start_talking() -> void:
	var target: Node2D = null
	var dialogue_settings: DialogueSettings = null
	if _npc_target:
		target = _npc_target
		dialogue_settings = _npc_target.dialogue_settings
	elif _npc_static_target:
		target = _npc_static_target
		dialogue_settings = _npc_static_target.dialogue_settings
	else:
		push_error(DEBUG_NAME,"StartTalking > No target defined! Ignoring...")
		return
	
	set_deferred("is_talking", true)
	set_movement_target(global_position)
	WorldManager.pause_day()
	Bag.set_tools_usable(false)
	set_deferred("is_walking",false)
	
	call_deferred("turn_to_face_direction",global_position.direction_to(target.global_position))
	target.start_talking()
	HudManager.start_dialogue((target.global_position - global_position)/2,dialogue_settings)
	
	is_walking = false

static func stop_talking() -> void:
	instance._stop_talking()
func _stop_talking() -> void:
	if _npc_target:
		_npc_target.stop_talking()
		_npc_target = null
	elif _npc_static_target:
		_npc_static_target.stop_talking()
		_npc_static_target = null
	else:
		push_error(DEBUG_NAME,"StartTalking > No target defined! Ignoring...")
		return

	WorldManager.resume_day()
	Bag.set_tools_usable(true)
	is_talking = false

#endregion


func on_navigation_finished() -> void:
	if is_walking:
		is_walking = false
		set_animation()
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
		if is_walking:
			is_walking = false
			set_animation()




func adjusting_move_target() -> void:
	var _circle: Panel = player_move_target.get_child(0)
	var _colour_dark = Color(0.329, 0.604, 0.553) 
	var _colour_light = Color(0.824, 0.925, 0.6)
	var _target_colour = _colour_dark
	#var _is_light = false
	var _elapsed = 0
	while true:
		if !is_inside_tree() || !is_instance_valid(get_tree()):
			return
		await get_tree().process_frame
		if player_move_target.visible:
			if _npc_target || _npc_static_target: 	_circle.size = Vector2.ONE * 12
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




func on_velocity_computed(safe_velocity:Vector2) -> void:
	if is_talking: return
	super.on_velocity_computed(safe_velocity)



enum Facing{LEFT,RIGHT,FORWARD,BACK}
var facing:Facing = Facing.FORWARD
func turn_left() -> void:
	if head:
		head.texture = head_side
		head.flip_h = false
	animated_body.flip_h = false
	facing = Facing.LEFT
	set_animation()

func turn_right() -> void:
	if head:
		head.texture = head_side
		head.flip_h = true
	animated_body.flip_h = true
	facing = Facing.RIGHT
	set_animation()

func turn_front() -> void:
	if head:
		head.texture = head_front
		head.flip_h = false
	facing = Facing.FORWARD
	set_animation()

func turn_back() -> void:
	if head:
		head.texture = head_back
		head.flip_h = false
	facing = Facing.BACK
	set_animation()
	

func set_animation() -> void:
	match facing:
		Facing.LEFT:
			if is_walking:
				animated_body.play("walk_side")
			else:
				animated_body.play("idle_side")
		Facing.RIGHT:
			if is_walking:
				animated_body.play("walk_side")
			else:
				animated_body.play("idle_side")
		Facing.FORWARD:
			if is_walking:
				animated_body.play("walk_forward")
			else:
				animated_body.play("idle_forward")
		Facing.BACK:
			if is_walking:
				animated_body.play("walk_back")
			else:
				animated_body.play("idle_back")
