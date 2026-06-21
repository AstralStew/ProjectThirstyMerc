class_name NPCharacter extends MovingAgent
var DEBUG_NAME : String = "[b][NPCharacter("+name+")][/b] "

const QUESTION_MARK = preload("uid://c8t2d6fhdj1y0")

@export var dialogue_settings:DialogueSettings = null

@export var do_wander : bool = false
@export var wander_wait_time : float = 5.0

@export var wander_points : Array[Vector2] = [Vector2.ZERO,Vector2.ONE]


@export_group("READ ONLY")
@export var is_wandering : bool = false
@export var wander_point_index : int = 0
@export var is_talking: bool = false

var initial_pos: Vector2
var question_mark : Node2D = null

func _ready() -> void:
	super._ready()
	initial_pos = global_position
	if dialogue_settings and !dialogue_settings.is_completed:
		#dialogue_settings = dialogue_settings #.duplicate()
		
		question_mark = QUESTION_MARK.instantiate()
		add_child(question_mark)
		question_mark.position = Vector2.ZERO
		call_deferred("display_question_mark")
		dialogue_settings.complete.connect(stop_displaying_question_mark)
		

func actor_setup():
	await super.actor_setup()
	if do_wander:
		is_wandering = true
		wandering()

func wandering() -> void:
	await get_tree().create_timer(wander_wait_time).timeout
	if !is_wandering: return
	wander_point_index = (wander_point_index + 1) % wander_points.size()
	set_movement_target(initial_pos + wander_points[wander_point_index])

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

func on_navigation_finished() -> void:
	super.on_navigation_finished()
	wandering()



func start_talking() -> void:
	is_talking = true
	if do_wander:
		is_wandering = false
	set_movement_target(global_position)
	
	call_deferred("turn_to_face_direction",global_position.direction_to(PlayerCharacter.instance.global_position))

func stop_talking() -> void:
	is_talking = false
	if do_wander:
		is_wandering = true
		set_movement_target(initial_pos + wander_points[wander_point_index])


func _on_gui_input(event: InputEvent) -> void:
	if !dialogue_settings: return
	if PlayerCharacter.instance.is_talking: return
	
	if event.is_action_pressed("Click"):
		# any checks that happen here
		PlayerCharacter.move_to_start_dialogue(self)
