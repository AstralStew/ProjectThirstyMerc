class_name Phone extends Rotator
static var instance : Phone = null
#const DEBUG_NAME : String = "[b][Phone][/b] "
func _enter_tree() -> void:
	instance = self

@onready var balance_label: Label = $Gfx/PanelContainer/VBoxContainer/PanelContainer/PurpleBorder/NotificationHolder/BalanceLabel
@onready var time_label: RichTextLabel = $Gfx/PanelContainer/VBoxContainer/PanelContainer/PurpleBorder/NotificationHolder/TimeLabel

@onready var phone_screen_1: VBoxContainer = $Gfx/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/MarginContainer/MarginContainer/PhoneScreen1
@onready var alotl_speech_label: RichTextLabel = $Gfx/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/MarginContainer/MarginContainer/PhoneScreen1/AlotlSpeechLabel


@export var alotl_speech_speed : float = 1.0

func _ready() -> void:
	super._ready()
	InventoryManager.on_dosh_changed().connect(update_dosh)
	update_dosh(InventoryManager.dosh)
	
	buzzing_up()

func _process(delta: float) -> void:
	if WorldManager.is_daytime:
		time_label.text = WorldManager.day_fake_time

func update_dosh(new_amount:int) -> void:
	balance_label.text = "$" + str(new_amount)

static func alotl_speech(speech:String) -> void:
	instance._alotl_speech(speech)
var _text_tween : Tween
func _alotl_speech(speech:String) -> void:
	if _text_tween: _text_tween.kill()
	alotl_speech_label.visible_ratio = 0
	await get_tree().process_frame
	alotl_speech_label.text = speech
	_text_tween = create_tween()
	_text_tween.tween_property(alotl_speech_label,"visible_ratio",1,(alotl_speech_label.get_total_character_count() as float) / (alotl_speech_speed as float))


func buzzing_up() -> void:
	
	await get_tree().create_timer(3.5).timeout
	while(true):
		buzz_up()
		await get_tree().create_timer(7).timeout

func buzz_up() -> void:
	if is_resetting: return
	if is_dragging: return
	
	await get_tree().create_timer(3.5).timeout
	var duration = 0.4
	#if dragged_object.position.y > 250:
	
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_loops(3)
	
	print("a = " + str(-(dragged_object.position.y - 250)) + ", b = " + str((1 + _tween.get_loops_left())))
	
	
	_tween.tween_property(dragged_object,"position",Vector2(0,-(dragged_object.position.y - 250) / _tween.get_loops_left()),duration).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	_tween.tween_property(dragged_object,"rotation_degrees",3,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	_tween.tween_property(dragged_object,"rotation_degrees",-3,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay(duration/6)
	_tween.tween_property(dragged_object,"rotation_degrees",0,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay((duration/6)*2)
	_tween.tween_property(dragged_object,"rotation_degrees",2,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay((duration/6)*3)
	_tween.tween_property(dragged_object,"rotation_degrees",-2,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay((duration/6)*4)
	_tween.tween_property(dragged_object,"rotation_degrees",0,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay((duration/6)*5)
	_tween.tween_interval(duration*1.5)
	
	
	
