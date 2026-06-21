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
	#button_group.pressed.connect(on_button_pressed)
	#for button in button_group.get_buttons():
		#button.mouse_entered.connect(on_button_hover.bind(button))
		#button.mouse_exited.connect(on_button_unhover.bind(button))
	
	#gated_response.mouse_entered.connect(on_button_hover.bind(gated_response))
	#gated_response.mouse_exited.connect(on_button_unhover.bind(gated_response))
	#leave.mouse_entered.connect(on_button_hover.bind(leave))
	#leave.mouse_exited.connect(on_button_unhover.bind(leave))
	
	
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
	else:
		var number_gone_through: int = 0
		var has_requirements:bool = true
		var requirements_msg:String = ""
		for requirement in dialogue_settings.requirements:
			number_gone_through += 1
			requirements_msg += (
				(" and " if (number_gone_through > 1 and number_gone_through == dialogue_settings.requirements.size()) else (", " if requirements_msg != "" else "")) +
				"[color=fbc697]" + str(dialogue_settings.requirements[requirement]) + " " + requirement.name + "[/color]"
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
	

func reset_button(button:Button,disabled:bool) -> void:
	button.set_pressed_no_signal(false)
	button.disabled = disabled
	

var _tween: Tween
func open() -> void:
	
	#AudioManager.play_sound(AudioManager.Sounds.SHOP_DOOR_BELL,0.25)
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_interval(0.42)
	#_tween.tween_property(dialogue_bubble,"position",Vector2(-53,2),0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(margin_container,"theme_override_constants/margin_left",20,0.42).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	_tween.set_parallel(true)
	_tween.tween_property(margin_container,"theme_override_constants/margin_right",20,0.42).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	_tween.set_parallel(false)
	_tween.tween_interval(0.42)
	#_tween.tween_property(rent,"visible",true,0)
	_tween.tween_property(leave,"visible",true,0)

func close() -> void:
	#AudioManager.play_sound(AudioManager.Sounds.SHOP_DOOR_BELL,0.25)
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
	
	_dialogue_settings.complete_dialogue()
	
	for requirement in _dialogue_settings.requirements:
		InventoryManager.add_collectable(requirement,-_dialogue_settings.requirements[requirement])
	
	gated_response.modulate.a = 0
	gated_response.disabled = true
	dialogue_label.text = _dialogue_settings.npc_complete_text
	leave.text = _dialogue_settings.player_leave_complete_text


func _on_leave_pressed() -> void:
	print_rich(DEBUG_NAME,"OnLeavePressed > Leave pressed!")
	
	AudioManager.play_sound(AudioManager.Sounds.UI_POP_UP,1,0.8)
	
	HudManager.stop_dialogue()
	

func update_buttons() -> void:
	pass
