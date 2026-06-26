class_name InstructionsUI extends Control
static var instance : InstructionsUI = null
const DEBUG_NAME : String = "[b][InstructionsUI][/b] "
func _enter_tree() -> void:
	if instance != null:
		instance.queue_free()
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)



@onready var instruction_label: Label = $MarginContainer/InstructionLabel


@export var default_scale: float = 0.65
@export var appear_duration: float = 1.0
@export var appear_ease: Tween.EaseType = Tween.EASE_IN
@export var appear_trans: Tween.TransitionType = Tween.TRANS_SPRING


@export var moving_loop_duration: float = 1.0
@export var moving_loop_translation: float = 10
@export var moving_loop_rotation: float = 10
@export var moving_loop_scale: float = 0.1

@export var disappear_duration: float = 1.0
@export var disappear_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var disappear_trans: Tween.TransitionType = Tween.TRANS_LINEAR




var _tween:Tween
func appear(text:String) -> void:
	instruction_label.text = text
	
	if _tween: _tween.kill()
	
	_tween = create_tween().set_ease(appear_ease).set_trans(appear_trans)
	_tween.tween_interval(0.25)
	_tween.tween_property(instruction_label,"offset_transform_scale",default_scale * Vector2.ONE,appear_duration)
	_tween.parallel().tween_property(instruction_label,"offset_transform_rotation",-deg_to_rad(moving_loop_rotation),appear_duration)
	_tween.parallel().tween_callback(AudioManager.play_sound.bind(AudioManager.INSTRUCTIONS,0.35,1.5)).set_delay(appear_duration/3)
	_tween.tween_callback(moving)

func moving() -> void:
	
	if _tween: _tween.kill()
	
	var rot_tween = create_tween().set_trans(Tween.TRANS_SINE)
	rot_tween.tween_property(instruction_label,"offset_transform_rotation",deg_to_rad(moving_loop_rotation),moving_loop_duration/4)
	rot_tween.tween_property(instruction_label,"offset_transform_rotation",-deg_to_rad(moving_loop_rotation),moving_loop_duration/4)
	rot_tween.tween_property(instruction_label,"offset_transform_rotation",deg_to_rad(moving_loop_rotation),moving_loop_duration/4)
	rot_tween.tween_property(instruction_label,"offset_transform_rotation",-deg_to_rad(moving_loop_rotation),moving_loop_duration/4)
	#rot_tween.tween_property(instruction_label,"offset_transform_rotation",deg_to_rad(rotation),moving_loop_duration/4)
	var scale_tween = create_tween().set_trans(Tween.TRANS_SINE)
	scale_tween.tween_property(instruction_label,"offset_transform_scale",(default_scale + moving_loop_scale) * Vector2.ONE,moving_loop_duration/2)
	scale_tween.tween_property(instruction_label,"offset_transform_scale",default_scale * Vector2.ONE,moving_loop_duration/2)
	
	_tween = create_tween().set_parallel().set_loops()#.set_ease(appear_ease).set_trans(appear_trans)
	_tween.tween_subtween(rot_tween)
	_tween.tween_subtween(scale_tween)
	#_tween.tween_method()


func disappear() -> void:
	if _tween: _tween.kill()
	
	_tween = create_tween().set_ease(disappear_ease).set_trans(disappear_trans)
	_tween.tween_property(instruction_label,"offset_transform_scale",Vector2.ZERO,disappear_duration)
	_tween.parallel().tween_callback(AudioManager.play_sound.bind(AudioManager.INSTRUCTIONS,0.2,0.9)).set_delay(appear_duration/3)
	_tween.tween_callback(queue_free)
