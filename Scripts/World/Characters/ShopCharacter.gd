class_name ShopCharacter extends Node2D

@onready var question_mark: Label = $QuestionMark

@export var shop_ui:PackedScene = null

@export_group("READ ONLY")
@export var has_talked : bool = false

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
	

var _tween:Tween
func display_question_mark() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_loops()
	_tween.tween_property(question_mark,"position",Vector2(0,-4),1.5).as_relative()#.from_current()
	#_tween.tween_interval(0.1)
	_tween.tween_property(question_mark,"position",Vector2(0,4),1.5).as_relative()
	#_tween.tween_interval(0.1)


func _on_gui_input(event: InputEvent) -> void:
	#if _tween: _tween.kill()
	#question_mark.call_deferred("queue_free")
	
	if event.is_action_pressed("Click"):
		# any checks that happen here
		question_mark.visible = false
		PlayerCharacter.move_to_start_shopping(self)
		#has_talked = true
		#if _tween: _tween.kill()
		
