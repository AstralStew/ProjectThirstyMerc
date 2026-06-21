class_name ShopCharacter extends Node2D

@onready var question_mark: Label = $QuestionMark
@onready var character: Sprite2D = $Character


@export var shop_ui:PackedScene = null

@export var texture_bob: float = 2.0
@export var texture_turn_with_movement: bool = true
@export var texture_random_turn: bool = false
@export var texture_random_turn_chance: float = 0.25

@export_group("READ ONLY")
@export var has_talked : bool = false
@export var is_shopping: bool = false

@onready var _bob_timer: float = randf()

@onready var _default_pos: Vector2 = character.position

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("display_question_mark")
	

#var _tween:Tween
#func display_question_mark() -> void:
	#while (!has_talked):
		#if _tween: _tween.kill()
		#_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_loops()
		#_tween.tween_property(question_mark,"position",Vector2(0,-7),1).as_relative()
		#_tween.tween_property(question_mark,"position",Vector2(0,-7),1).as_relative().set_delay(1)
		#await get_tree().create_timer(1).timeout
		#if has_talked: break
		#if _tween: _tween.kill()
		#_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		#_tween.tween_property(question_mark,"position",Vector2(0,7),1).as_relative()
		#await get_tree().create_timer(1).timeout

func _process(delta: float) -> void:
	
	
	if texture_bob > 0: 
		_bob_timer += delta
		if _bob_timer > texture_bob:
			if character.position.y == _default_pos.y - 1: character.position.y = _default_pos.y
			else: character.position.y = _default_pos.y - 1
			_bob_timer = 0
	
	if is_shopping: return
	
	if texture_random_turn:
		if randf() < (texture_random_turn_chance * delta):
			if randf() < 0.5:
				character.flip_h = true
			else:
				character.flip_h = false

var _tween:Tween
func display_question_mark() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_loops()
	_tween.tween_property(question_mark,"position",Vector2(0,-4),1.5).as_relative()#.from_current()
	#_tween.tween_interval(0.1)
	_tween.tween_property(question_mark,"position",Vector2(0,4),1.5).as_relative()
	#_tween.tween_interval(0.1)


func _on_gui_input(event: InputEvent) -> void:	
	if PlayerCharacter.instance.is_talking: return
	#if _tween: _tween.kill()
	#question_mark.call_deferred("queue_free")
	
	if event.is_action_pressed("Click"):
		# any checks that happen here
		question_mark.visible = false
		PlayerCharacter.move_to_start_shopping(self)
		#has_talked = true
		#if _tween: _tween.kill()
		
