class_name Phone extends Rotator
static var instance : Phone = null
const DEBUG_NAME : String = "[b][Phone][/b] "
func _enter_tree() -> void:
	instance = self

@onready var balance_label: Label = $Gfx/PanelContainer/VBoxContainer/PanelContainer/PurpleBorder/NotificationHolder/BalanceLabel
@onready var time_label: RichTextLabel = $Gfx/PanelContainer/VBoxContainer/PanelContainer/PurpleBorder/NotificationHolder/TimeLabel

@onready var phone_screen_1: VBoxContainer = $Gfx/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/MarginContainer/MarginContainer/PhoneScreen1
@onready var alotl_speech_label: RichTextLabel = $Gfx/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/MarginContainer/MarginContainer/PhoneScreen1/AlotlSpeechLabel


@export var alotl_speech_speed : float = 1.0


func _process(delta: float) -> void:
	if WorldManager.is_daytime:
		time_label.text = WorldManager.day_fake_time


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
