class_name MovingAgent extends CharacterBody2D

@export var body: Sprite2D
@export var head: Sprite2D


@export var movement_speed: float = 50.0
@export var movement_target_position: Vector2 = Vector2.ZERO

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

#@export var texture_change: bool = false
@export var texture_head_bob: float = 0.0
@export var texture_turn_with_movement: bool = true
@export var texture_random_turn: bool = false
@export var texture_random_turn_chance: float = 0.25

@export_group("READ ONLY")
@export var movement_direction : Vector2 = Vector2.ZERO
@export var _safe_velocity : Vector2 = Vector2.ZERO


@export_category("Texture Settings")

@export var body_back: Texture2D = null
@export var body_front: Texture2D = null
@export var body_side: Texture2D = null
@export var head_back: Texture2D = null
@export var head_front: Texture2D = null
@export var head_side: Texture2D = null



func _ready():
	
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 8.0
	navigation_agent.target_desired_distance = 4.0
	navigation_agent.navigation_finished.connect(on_navigation_finished)
	navigation_agent.velocity_computed.connect(on_velocity_computed)

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	
	# Now that the navigation map is no longer empty, set the movement target.
	movement_target_position = global_position
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

@onready var _head_bob_timer: float = randf()
func _physics_process(delta):
	if texture_head_bob > 0: 
		_head_bob_timer += delta
		if _head_bob_timer > texture_head_bob:
			if head.position.y == 1: head.position.y = 0
			else: head.position.y = 1
			_head_bob_timer = 0
	if navigation_agent.is_navigation_finished(): #&& !navigation_agent.avoidance_enabled:
		if texture_random_turn:
			if randf() < (texture_random_turn_chance * delta):
				if randf() < 0.25:
					turn_left()
				elif randf() < 0.5:
					turn_right()
				elif randf() < 0.75:
					turn_back()
				else:
					turn_front()
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	movement_direction = current_agent_position.direction_to(next_path_position)
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = movement_direction * movement_speed * WorldManager.get_speed_at_tile_position(global_position)
	else:
		on_velocity_computed(movement_direction * movement_speed * WorldManager.get_speed_at_tile_position(global_position))
		#velocity = 
		#move_and_slide()
	

func on_velocity_computed(safe_velocity:Vector2) -> void:
	velocity = velocity.move_toward(safe_velocity, 100)
	#velocity = safe_velocity
	move_and_slide()
	
	if texture_turn_with_movement:
		if movement_direction == Vector2.ZERO:
			if !texture_random_turn:
				turn_front()
				#if randf() < texture_random_turn_chance:
					#if randf() < 0.25:
						#turn_left()
					#elif randf() < 0.5:
						#turn_right()
					#elif randf() < 0.75:
						#turn_back()
					#else:
						#turn_front()
			#else:
				#
		elif abs(movement_direction.x) > abs(movement_direction.y):
			if movement_direction.x < 0:
				turn_left()
			else:
				turn_right()
		else:
			if movement_direction.y < 0:
				turn_back()
			else:
				turn_front()

func on_navigation_finished() -> void:
	movement_direction = Vector2.ZERO




func turn_left() -> void:
	if head:
		head.texture = head_side
		head.flip_h = false
	if body:
		body.texture = body_side
		body.flip_h = false
func turn_right() -> void:
	if head:
		head.texture = head_side
		head.flip_h = true
	if body:
		body.texture = body_side
		body.flip_h = true
func turn_front() -> void:
	if head:
		head.texture = head_front
		head.flip_h = false
	if body:
		body.texture = body_front
		body.flip_h = false
func turn_back() -> void:
	if head:
		head.texture = head_back
		head.flip_h = false
	if body:
		body.texture = body_back
		body.flip_h = false
	
