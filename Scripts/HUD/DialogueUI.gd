class_name DialogueUI extends Control
var DEBUG_NAME: String:
	get: return "[b][" + name + "][/b] "

@onready var dialogue_label: RichTextLabel = $MarginContainer/PanelContainer/DialogueLabel
#@onready var default_text: String = dialogue_label.text

@onready var gated_response: Button = $MarginContainer/PlayerResponses/GatedResponse

@onready var leave: Button = $MarginContainer/PlayerResponses/Leave

@onready var margin_container: MarginContainer = $MarginContainer


var completed:bool = false

var _dialogue_settings: DialogueSettings


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	gated_response.pressed.connect(_on_gated_response_pressed)
	leave.pressed.connect(_on_leave_pressed)
	
	update_buttons()
	open()
	

func setup(dialogue_settings:DialogueSettings) -> void:
	_dialogue_settings = dialogue_settings
	dialogue_label.text = dialogue_settings.npc_default_text
	
	if _dialogue_settings.is_completed:
		dialogue_label.text = dialogue_settings.npc_complete_text
		leave.text = dialogue_settings.player_leave_complete_text
		gated_response.modulate.a = 0
		gated_response.disabled = true
	elif dialogue_settings.requirements.size() > 0:
		var number_gone_through: int = 0
		var has_requirements:bool = true
		var requirements_msg:String = ""
		for requirement in dialogue_settings.requirements:
			number_gone_through += 1
			requirements_msg += (
				(" and " if (number_gone_through > 1 and number_gone_through == dialogue_settings.requirements.size()) else (", " if requirements_msg != "" else "")) +
				"[color=fbc697]" + (str(dialogue_settings.requirements[requirement]) if dialogue_settings.requirements[requirement] > 1 else "a") + " " + requirement.name + "[/color]"
			)
			print ("number = " + str(number_gone_through) +" requirements.size = " + str(dialogue_settings.requirements.size()))
			if InventoryManager.inventory.has(requirement) && InventoryManager.inventory[requirement] >= dialogue_settings.requirements[requirement]:
				continue
			has_requirements = false
			gated_response.disabled = true
		if has_requirements:
			gated_response.text = dialogue_settings.player_has_requirements_text
			gated_response.disabled = false
		else:
			gated_response.text = "I don't have that..."
		dialogue_label.text = dialogue_settings.npc_default_text % requirements_msg
		leave.text = dialogue_settings.player_leave_incomplete_text
	else:
		gated_response.visible = false
		dialogue_label.text = dialogue_settings.npc_default_text
		leave.text = dialogue_settings.player_leave_incomplete_text
	

func reset_button(button:Button,disabled:bool) -> void:
	button.set_pressed_no_signal(false)
	button.disabled = disabled
	

var _tween: Tween
func open() -> void:
	
	#AudioManager.play_sound(AudioManager.SHOP_DOOR_BELL,0.25)
	ScreenBars.activate(0.225,0.69)
	
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_interval(0.42)
	_tween.tween_callback(AudioManager.play_hmmm)
	_tween.tween_property(margin_container,"theme_override_constants/margin_left",20,0.42).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	_tween.set_parallel(true)
	_tween.tween_property(margin_container,"theme_override_constants/margin_right",20,0.42).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	_tween.set_parallel(false)
	_tween.tween_interval(0.42)
	_tween.tween_property(leave,"visible",true,0)

func close() -> void:
	
	#AudioManager.play_sound(AudioManager.SHOP_DOOR_BELL,0.25)
	ScreenBars.activate(0,0.69)
	
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel(true)
	#_tween.tween_property(rent,"visible",false,0)
	_tween.tween_property(leave,"visible",false,0)
	#_tween.tween_property(dialogue_bubble,"position",Vector2(-53,-74.5),0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(margin_container,"theme_override_constants/margin_left",-300,0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(margin_container,"theme_override_constants/margin_right",-300,0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_tween.tween_callback(queue_free).set_delay(0.42)

#
#func on_button_hover(button:Button) -> void:
	#print_rich(DEBUG_NAME,"OnButtonHover > Button hovered: '" + button.text + "'")
#
#func on_button_unhover(button:Button) -> void:
	#print_rich(DEBUG_NAME,"OnButtonUnhover > Button unhovered: '" + button.text + "'")


func _on_gated_response_pressed() -> void:
	
	AudioManager.play_sound(AudioManager.SUCCESS,1,0.8)
	
	_dialogue_settings.complete_dialogue()
	
	completed = true
	
	for requirement in _dialogue_settings.requirements:
		InventoryManager.add_collectable(requirement,-_dialogue_settings.requirements[requirement])
	
	gated_response.modulate.a = 0
	gated_response.disabled = true
	dialogue_label.text = _dialogue_settings.npc_complete_text
	leave.text = _dialogue_settings.player_leave_complete_text


func _on_leave_pressed() -> void:
	print_rich(DEBUG_NAME,"OnLeavePressed > Leave pressed!")
	
	AudioManager.play_sound(AudioManager.UI_POP_UP,1,0.8)
	
	HudManager.stop_dialogue()
	if completed:
		HudManager.complete_quest(_dialogue_settings.reward)
	
	

func update_buttons() -> void:
	pass
