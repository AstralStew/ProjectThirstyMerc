class_name TchotchkeShopUI extends ShopUI


@onready var options_margin_container: MarginContainer = $Options/OptionsMarginContainer


@export var possible_items: Array[CollectableType] = []




#@onready var rent: Button = $Rent

@export_group("READ ONLY")
@export var chosen_items: Array[CollectableType] = []


func _ready() -> void:
	chosen_items = possible_items.duplicate()
	chosen_items.shuffle()
	chosen_items.resize(8)
	for i in chosen_items.size():
		(button_group.get_buttons()[i] as Button).text = "1 " + chosen_items[i].name
		(button_group.get_buttons()[i] as Button).disabled = InventoryManager.inventory.has(chosen_items[i])
		(button_group.get_buttons()[i].get_child(0) as Label).text = "$" + str(chosen_items[i].price)
		print("button text = " + (button_group.get_buttons()[i] as Button).text)
	super._ready()

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
	var index = button_group.get_buttons().find(button)
	if InventoryManager.inventory.has(chosen_items[index]):
		InventoryManager.add_collectable(chosen_items[index],-1)
		InventoryManager.add_dosh(chosen_items[index].price)
	
	update_buttons()
	
	AudioManager.play_sound(AudioManager.CASH_REGISTER)
	
	

func _on_leave_pressed() -> void:
	print_rich(DEBUG_NAME,"OnLeavePressed > Leave pressed!")
	
	AudioManager.play_sound(AudioManager.UI_POP_UP,1,0.8)
	
	HudManager.stop_shop()
	

func update_buttons() -> void:
	var active: bool = false
	var button: Button = null
	for i in chosen_items.size():
		active = InventoryManager.inventory.has(chosen_items[i]) && InventoryManager.inventory[chosen_items[i]] >= 1
		button = button_group.get_buttons()[i]
		#match button.text:
			#"1 Bottlecap":
				#active = InventoryManager.inventory.has(CT_BOTTLECAP) && InventoryManager.inventory[CT_BOTTLECAP] >= 1
			#"5 Bottlecaps":
				#active = InventoryManager.inventory.has(CT_BOTTLECAP) && InventoryManager.inventory[CT_BOTTLECAP] >= 5
			#"1 Pull Tab":
				#active = InventoryManager.inventory.has(CT_PULL_TAB) && InventoryManager.inventory[CT_PULL_TAB] >= 1
			#"5 Pull Tabs":
				#active = InventoryManager.inventory.has(CT_PULL_TAB) && InventoryManager.inventory[CT_PULL_TAB] >= 5
			#"1 Broken Lure":
				#active = InventoryManager.inventory.has(CT_BROKEN_LURE) && InventoryManager.inventory[CT_BROKEN_LURE] >= 1
			#"5 Broken Lures":
				#active = InventoryManager.inventory.has(CT_BROKEN_LURE) && InventoryManager.inventory[CT_BROKEN_LURE] >= 5
			#"1 Old Can":
				#active = InventoryManager.inventory.has(CT_OLD_CAN) && InventoryManager.inventory[CT_OLD_CAN] >= 1
			#"5 Old Cans":
				#active = InventoryManager.inventory.has(CT_OLD_CAN) && InventoryManager.inventory[CT_OLD_CAN] >= 5
		#
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
		
