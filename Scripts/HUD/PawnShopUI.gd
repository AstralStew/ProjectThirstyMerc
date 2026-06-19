class_name PawnShopUI extends ShopUI

const CT_BOTTLECAP = preload("uid://4jioa8dy36vc")


@onready var options_margin_container: MarginContainer = $Options/OptionsMarginContainer

@onready var rent: Button = $Rent




#var _tween: Tween
func open() -> void:
	AudioManager.play_sound(AudioManager.Sounds.SHOP_DOOR_BELL,0.25)
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_interval(0.42)
	_tween.tween_property(dialogue_bubble,"position",Vector2(-53,2),0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(options_margin_container,"theme_override_constants/margin_left",0,0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.set_parallel(true)
	_tween.tween_property(options_margin_container,"theme_override_constants/margin_right",0,0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.set_parallel(false)
	_tween.tween_interval(0.42)
	_tween.tween_property(rent,"visible",true,0)
	_tween.tween_property(leave,"visible",true,0)

func close() -> void:
	AudioManager.play_sound(AudioManager.Sounds.SHOP_DOOR_BELL,0.25)
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(rent,"visible",false,0)
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
		"1 Bottlecap":
			InventoryManager.add_collectable(CT_BOTTLECAP,-1)
			InventoryManager.add_dosh(1)
		"10 Bottlecaps":
			InventoryManager.add_collectable(CT_BOTTLECAP,-10)
			InventoryManager.add_dosh(15)
	
	update_buttons()
	
	AudioManager.play_sound(AudioManager.Sounds.CASH_REGISTER)
	
	
	#AudioManager.play_sound(AudioManager.Sounds.UI_POP_UP)
	


#
#func _on_rent_pressed() -> void:
	#print_rich(DEBUG_NAME,"OnRentPress > Rent pressed!")
	#var button:Button = button_group.get_pressed_button()
	#
	#match button.text:
		#"Long Brush":
			#if TT_BRUSH.cost <= InventoryManager.dosh:
				#InventoryManager.add_dosh(-TT_BRUSH.cost)
				#Bag.setup_tool(TT_BRUSH)
		#"Magnifying Glass":
			#if TT_MAGNIFYING_GLASS.cost <= InventoryManager.dosh:
				#InventoryManager.add_dosh(-TT_MAGNIFYING_GLASS.cost)
				#Bag.setup_tool(TT_MAGNIFYING_GLASS)
		#"Binoculars":
			#if TT_BINOCULARS.cost <= InventoryManager.dosh:
				#InventoryManager.add_dosh(-TT_BINOCULARS.cost)
				#Bag.setup_tool(TT_BINOCULARS)
		#"Metal Detector":
			#if TT_METAL_DETECTOR.cost <= InventoryManager.dosh:
				#InventoryManager.add_dosh(-TT_METAL_DETECTOR.cost)
				#Bag.setup_tool(TT_METAL_DETECTOR)
		#"Old Shovel":
			#if TT_SHOVEL.cost <= InventoryManager.dosh:
				#InventoryManager.add_dosh(-TT_SHOVEL.cost)
				#Bag.setup_tool(TT_SHOVEL)
		#"Zen Rake":
			#pass
		#"Fishing Rod":
			#pass
		#"Pickerupper":
			#pass
	#
	#reset_button(button,true)
	#rent.disabled = true
	#update_buttons()
	#
	#AudioManager.play_sound(AudioManager.Sounds.CASH_REGISTER)


func _on_leave_pressed() -> void:
	print_rich(DEBUG_NAME,"OnLeavePressed > Leave pressed!")
	
	AudioManager.play_sound(AudioManager.Sounds.UI_POP_UP,1,0.8)
	
	HudManager.stop_shop()
	

func update_buttons() -> void:
	for button in button_group.get_buttons():
		match button.text:
			"1 Bottlecap":
				if InventoryManager.inventory.has(CT_BOTTLECAP) && InventoryManager.inventory[CT_BOTTLECAP] >= 1:
					(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.984, 0.776, 0.592, 1.0))
					button.disabled = false
				else:
					(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.82, 0.314, 0.357, 1.0))
					button.disabled = true
				
			"10 Bottlecaps":
				if InventoryManager.inventory.has(CT_BOTTLECAP) && InventoryManager.inventory[CT_BOTTLECAP] >= 10:
					(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.984, 0.776, 0.592, 1.0))
					button.disabled = false
				else:
					(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.82, 0.314, 0.357, 1.0))
					button.disabled = true
		if button.disabled:
			button.get_child(0).visible = false
			#continue
		#else:
			#button.get_child(0).visible = true
			#if _tool_rentable:
				#(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.984, 0.776, 0.592, 1.0))
			#else:
				#(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.82, 0.314, 0.357, 1.0))
		
