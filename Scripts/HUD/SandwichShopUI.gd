class_name SandwichShopUI extends ShopUI




@onready var options_margin_container: MarginContainer = $Options/OptionsMarginContainer



#var _tween: Tween
func open() -> void:
	AudioManager.play_sound(AudioManager.SHOP_DOOR_BELL,0.25)
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_interval(0.42)
	_tween.tween_property(dialogue_bubble,"position",Vector2(-53,2),0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(options_margin_container,"theme_override_constants/margin_left",0,0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.set_parallel(true)
	_tween.tween_property(options_margin_container,"theme_override_constants/margin_right",0,0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.set_parallel(false)
	_tween.tween_interval(0.42)
	#_tween.tween_property(rent,"visible",true,0)
	_tween.tween_property(leave,"visible",true,0)

func close() -> void:
	AudioManager.play_sound(AudioManager.SHOP_DOOR_BELL,0.25)
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel(true)
	#_tween.tween_property(rent,"visible",false,0)
	_tween.tween_property(leave,"visible",false,0)
	_tween.tween_property(dialogue_bubble,"position",Vector2(-53,-74.5),0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(options_margin_container,"theme_override_constants/margin_left",-130,0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(options_margin_container,"theme_override_constants/margin_right",-130,0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_tween.tween_callback(queue_free).set_delay(0.42)


func on_button_hover(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonHover > Button hovered: '" + button.text + "'")

func on_button_unhover(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonUnhover > Button unhovered: '" + button.text + "'")


func on_button_pressed(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonPress > Button pressed: '" + button.text + "'")
	
	match button.text:
		"Speedy Sandwich":
			InventoryManager.add_dosh(-3)
			PlayerCharacter.instance.base_movement_speed = clamp(PlayerCharacter.instance.base_movement_speed + 6,40,65)
			PlayerCharacter.instance.movement_speed = PlayerCharacter.instance.base_movement_speed
			
		"Muscle Juice":
			InventoryManager.add_dosh(-2)
			PlayerCharacter.instance.base_dig_strength = clamp(PlayerCharacter.instance.base_dig_strength + 1,1,3)
		
	
	update_buttons()
	
	AudioManager.play_sound(AudioManager.CASH_REGISTER)
	
	

func _on_leave_pressed() -> void:
	print_rich(DEBUG_NAME,"OnLeavePressed > Leave pressed!")
	
	AudioManager.play_sound(AudioManager.UI_POP_UP,1,0.8)
	
	HudManager.stop_shop()
	

func update_buttons() -> void:
	var active: bool = false
	for button in button_group.get_buttons():
		match button.text:
			"Speedy Sandwich":
				active = 3 <= InventoryManager.dosh and PlayerCharacter.instance.base_movement_speed < 65
				(button.get_child(0) as Label).text = "$" + str(3)
			"Muscle Juice":
				active = 3 <= InventoryManager.dosh and PlayerCharacter.instance.base_dig_strength < 3
				(button.get_child(0) as Label).text = "$" + str(2)
		
		if active:
			(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.984, 0.776, 0.592, 1.0))
			button.disabled = false
		else:
			(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.82, 0.314, 0.357, 1.0))
			button.disabled = true
		
		if button.disabled:
			button.get_child(0).visible = false
		
		if button_group.get_pressed_button():
			button_group.get_pressed_button().set_pressed_no_signal(false)
		
			#continue
		#else:
			#button.get_child(0).visible = true
			#if _tool_rentable:
				#(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.984, 0.776, 0.592, 1.0))
			#else:
				#(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.82, 0.314, 0.357, 1.0))
		
