class_name NPCharacterStatic extends Node2D
var DEBUG_NAME : String = "[b][NPCharacterStatic("+name+")][/b] "

const QUESTION_MARK = preload("uid://c8t2d6fhdj1y0")

@export var body: Sprite2D
@export var head: Sprite2D

@export var dialogue_settings:DialogueSettings = null

@export var texture_head_bob: float = 0.0
@export var texture_turn_with_movement: bool = true
@export var texture_random_turn: bool = false
@export var texture_random_turn_chance: float = 0.25

@export_category("Texture Settings")

@export var body_back: Texture2D = null
@export var body_front: Texture2D = null
@export var body_side: Texture2D = null
@export var head_back: Texture2D = null
@export var head_front: Texture2D = null
@export var head_side: Texture2D = null

@export_group("READ ONLY")
@export var is_talking: bool = false
var question_mark : Node2D = null

func _ready() -> void:
	if dialogue_settings and !dialogue_settings.is_completed:
		
		question_mark = QUESTION_MARK.instantiate()
		add_child(question_mark)
		question_mark.position = Vector2.ZERO
		call_deferred("display_question_mark")
		dialogue_settings.complete.connect(stop_displaying_question_mark)

@onready var _head_bob_timer: float = randf()
func _physics_process(delta):
	if texture_head_bob > 0: 
		_head_bob_timer += delta
		if _head_bob_timer > texture_head_bob:
			if head.position.y == 1: head.position.y = 0
			else: head.position.y = 1
			_head_bob_timer = 0
	if !is_talking and texture_random_turn:
			if randf() < (texture_random_turn_chance * delta):
				if randf() < 0.25:
					turn_left()
				elif randf() < 0.5:
					turn_right()
				elif randf() < 0.75:
					turn_back()
				else:
					turn_front()

func start_talking() -> void:
	is_talking = true
	call_deferred("turn_to_face_direction",global_position.direction_to(PlayerCharacter.instance.global_position))

func stop_talking() -> void:
	is_talking = false

func _on_gui_input(event: InputEvent) -> void:
	if !dialogue_settings: return
	#if dialogue_settings.is_completed: return
	if PlayerCharacter.instance.is_talking: return
	
	if event.is_action_pressed("Click"):
		# any checks that happen here
		PlayerCharacter.move_to_start_dialogue_static(self)


var _tween:Tween
func display_question_mark() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_loops()
	_tween.tween_property(question_mark,"position",Vector2(0,-4),1.5).as_relative()#.from_current()
	#_tween.tween_interval(0.1)
	_tween.tween_property(question_mark,"position",Vector2(0,4),1.5).as_relative()
	#_tween.tween_interval(0.1)

func stop_displaying_question_mark() -> void:
	if _tween: _tween.kill()
	question_mark.queue_free()

func turn_to_face_direction(direction:Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x < 0:
			turn_left()
		else:
			turn_right()
	else:
		if direction.y < 0:
			turn_back()
		else:
			turn_front()

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
