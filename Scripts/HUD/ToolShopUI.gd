class_name ToolShopUI extends ShopUI


const TT_BRUSH = preload("uid://c6rt6buagyo5j")
const TT_BINOCULARS = preload("uid://beg2wll35sp7e")
const TT_METAL_DETECTOR = preload("uid://dw1nos3tpluk4")
const TT_SHOVEL = preload("uid://cys46dx7t1gui")


@onready var tools_margin_container: MarginContainer = $Tools/ToolsMarginContainer
@onready var rent: Button = $Rent


	

#var _tween: Tween
func open() -> void:
	AudioManager.play_sound(AudioManager.Sounds.SHOP_DOOR_BELL,0.25)
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_interval(0.42)
	_tween.tween_property(dialogue_bubble,"position",Vector2(-53,2),0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(tools_margin_container,"theme_override_constants/margin_left",0,0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.set_parallel(true)
	_tween.tween_property(tools_margin_container,"theme_override_constants/margin_right",0,0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_tween.set_parallel(false)
	_tween.tween_interval(0.69)
	_tween.tween_property(rent,"visible",true,0)
	_tween.tween_property(leave,"visible",true,0)

func close() -> void:
	AudioManager.play_sound(AudioManager.Sounds.SHOP_DOOR_BELL,0.25)
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(rent,"visible",false,0)
	_tween.tween_property(leave,"visible",false,0)
	_tween.tween_property(dialogue_bubble,"position",Vector2(-53,-74.5),0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(tools_margin_container,"theme_override_constants/margin_left",-130,0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(tools_margin_container,"theme_override_constants/margin_right",-130,0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_tween.tween_callback(queue_free).set_delay(0.42)


func on_button_hover(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonHover > Button hovered: '" + button.text + "'")

func on_button_unhover(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonUnhover > Button unhovered: '" + button.text + "'")


func on_button_pressed(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonPress > Button pressed: '" + button.text + "'")
	if !button_group.get_pressed_button():
		rent.disabled = true
		return
	if Bag.is_full:
		rent.disabled = true
		return
	
	
	match button.text:
		"Old Handbrush":
			rent.disabled = TT_BRUSH.cost > InventoryManager.dosh 
		"Magnifying Glass":
			pass
		"Binoculars":
			rent.disabled = TT_BINOCULARS.cost > InventoryManager.dosh
		"Metal Detector":
			rent.disabled = TT_METAL_DETECTOR.cost > InventoryManager.dosh
		"Old Shovel":
			rent.disabled = TT_SHOVEL.cost > InventoryManager.dosh
		"Zen Rake":
			pass
		"Fishing Rod":
			pass
		"Pickerupper":
			pass
	
	AudioManager.play_sound(AudioManager.Sounds.UI_POP_UP)
	



func _on_rent_pressed() -> void:
	print_rich(DEBUG_NAME,"OnRentPress > Rent pressed!")
	var button:Button = button_group.get_pressed_button()
	
	match button.text:
		"Old Handbrush":
			if TT_BRUSH.cost <= InventoryManager.dosh:
				InventoryManager.add_dosh(-TT_BRUSH.cost)
				Bag.setup_tool(TT_BRUSH)
		"Magnifying Glass":
			pass
		"Binoculars":
			if TT_BINOCULARS.cost <= InventoryManager.dosh:
				InventoryManager.add_dosh(-TT_BINOCULARS.cost)
				Bag.setup_tool(TT_BINOCULARS)
		"Metal Detector":
			if TT_METAL_DETECTOR.cost <= InventoryManager.dosh:
				InventoryManager.add_dosh(-TT_METAL_DETECTOR.cost)
				Bag.setup_tool(TT_METAL_DETECTOR)
		"Old Shovel":
			if TT_SHOVEL.cost <= InventoryManager.dosh:
				InventoryManager.add_dosh(-TT_SHOVEL.cost)
				Bag.setup_tool(TT_SHOVEL)
		"Zen Rake":
			pass
		"Fishing Rod":
			pass
		"Pickerupper":
			pass
	
	reset_button(button,true)
	rent.disabled = true
	update_buttons()
	
	AudioManager.play_sound(AudioManager.Sounds.CASH_REGISTER)


func _on_leave_pressed() -> void:
	print_rich(DEBUG_NAME,"OnLeavePressed > Leave pressed!")
	
	AudioManager.play_sound(AudioManager.Sounds.UI_POP_UP,1,0.8)
	
	HudManager.stop_shop()
	

func update_buttons() -> void:
	var _tool_rentable = false
	var _cost:int= 0
	for button in button_group.get_buttons():
		if button.disabled:
			button.get_child(0).visible = false
			continue
		else:
			button.get_child(0).visible = true
		match button.text:
			"Old Handbrush":
				_tool_rentable = TT_BRUSH.cost <= InventoryManager.dosh 
				(button.get_child(0) as Label).text = "$" + str(TT_BRUSH.cost)
			"Magnifying Glass":
				pass
			"Binoculars":
				_tool_rentable = TT_BINOCULARS.cost <= InventoryManager.dosh 
				(button.get_child(0) as Label).text = "$" + str(TT_BINOCULARS.cost)
			"Metal Detector":
				_tool_rentable = TT_METAL_DETECTOR.cost <= InventoryManager.dosh 
				(button.get_child(0) as Label).text = "$" + str(TT_METAL_DETECTOR.cost)
			"Old Shovel":
				_tool_rentable = TT_SHOVEL.cost <= InventoryManager.dosh 
				(button.get_child(0) as Label).text = "$" + str(TT_SHOVEL.cost)
			"Zen Rake":
				pass
			"Fishing Rod":
				pass
			"Pickerupper":
				pass
		if _tool_rentable:
			(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.984, 0.776, 0.592, 1.0))
		else:
			(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.82, 0.314, 0.357, 1.0))
		
