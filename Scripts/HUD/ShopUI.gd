class_name ShopUI extends Control
var DEBUG_NAME: String:
	get: return "[b][" + name + "][/b] "

@onready var dialogue_bubble: Panel = $DialogueBanner/DialogueBubble

@export var button_group: ButtonGroup = null

@onready var leave: Button = $Leave



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_group.pressed.connect(on_button_pressed)
	for button in button_group.get_buttons():
		button.mouse_entered.connect(on_button_hover.bind(button))
		button.mouse_exited.connect(on_button_unhover.bind(button))
		
	update_buttons()
	#InventoryManager.on_dosh_changed().connect(on_dosh_updated)
	open()
	#on_dosh_updated(InventoryManager.dosh)
	

func reset_button(button:Button,disabled:bool) -> void:
	button.set_pressed_no_signal(false)
	button.disabled = disabled
	#button.get_child(0).visible = !disabled
	

var _tween: Tween
func open() -> void:
	pass
	#
	#AudioManager.play_sound(AudioManager.Sounds.SHOP_DOOR_BELL,0.25)
	#if _tween: _tween.kill()
	#_tween = create_tween()
	#_tween.tween_interval(0.42)
	#_tween.tween_property(dialogue_bubble,"position",Vector2(-53,2),0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#_tween.tween_property(tools_margin_container,"theme_override_constants/margin_left",0,0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#_tween.set_parallel(true)
	#_tween.tween_property(tools_margin_container,"theme_override_constants/margin_right",0,0.69).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#_tween.set_parallel(false)
	#_tween.tween_interval(0.69)
	#_tween.tween_property(purchase,"visible",true,0)
	#_tween.tween_property(leave,"visible",true,0)

func close() -> void:
	pass
	#AudioManager.play_sound(AudioManager.Sounds.SHOP_DOOR_BELL,0.25)
	#if _tween: _tween.kill()
	#_tween = create_tween().set_parallel(true)
	#_tween.tween_property(purchase,"visible",true,0)
	#_tween.tween_property(leave,"visible",true,0)
	#_tween.tween_property(dialogue_bubble,"position",Vector2(-53,-74.5),0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	#_tween.tween_property(tools_margin_container,"theme_override_constants/margin_left",-130,0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	#_tween.tween_property(tools_margin_container,"theme_override_constants/margin_right",-130,0.42).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	#_tween.tween_callback(queue_free).set_delay(0.42)


func on_button_hover(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonHover > Button hovered: '" + button.text + "'")

func on_button_unhover(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonUnhover > Button unhovered: '" + button.text + "'")


func on_button_pressed(button:Button) -> void:
	pass
	#print_rich(DEBUG_NAME,"OnButtonPress > Button pressed: '" + button.text + "'")
	#if !button_group.get_pressed_button():
		#purchase.disabled = true
		#return
	#if Bag.is_full:
		#purchase.disabled = true
		#return
	#
	#
	#match button.text:
		#"Old Handbrush":
			#purchase.disabled = TT_BRUSH.cost > InventoryManager.dosh 
		#"Magnifying Glass":
			#pass
		#"Binoculars":
			##print("result = " + str(TT_BINOCULARS.cost) + ">" + str(InventoryManager.dosh) + "? " + str(TT_BINOCULARS.cost > InventoryManager.dosh))
			#purchase.disabled = TT_BINOCULARS.cost > InventoryManager.dosh
		#"Metal Detector":
			##print("result = " + str(TT_METAL_DETECTOR.cost) + ">" + str(InventoryManager.dosh) + "? " + str(TT_METAL_DETECTOR.cost > InventoryManager.dosh))
			#purchase.disabled = TT_METAL_DETECTOR.cost > InventoryManager.dosh
		#"Old Shovel":
			##print("result = " + str(TT_SHOVEL.cost) + ">" + str(InventoryManager.dosh) + "? " + str(TT_SHOVEL.cost > InventoryManager.dosh))
			#purchase.disabled = TT_SHOVEL.cost > InventoryManager.dosh
		#"Zen Rake":
			#pass
		#"Fishing Rod":
			#pass
		#"Pickerupper":
			#pass
	#
	#AudioManager.play_sound(AudioManager.Sounds.UI_POP_UP)
	##reset_button(button,true)
	


#
#func _on_purchase_pressed() -> void:
	#print_rich(DEBUG_NAME,"OnPurchasePress > Purchase pressed!")
	#var button:Button = button_group.get_pressed_button()
	#
	#match button.text:
		#"Old Handbrush":
			#if TT_BRUSH.cost <= InventoryManager.dosh:
				#InventoryManager.add_dosh(-TT_BRUSH.cost)
				#Bag.setup_tool(TT_BRUSH)
		#"Magnifying Glass":
			#pass
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
	#purchase.disabled = true
	#update_buttons()
	#
	#AudioManager.play_sound(AudioManager.Sounds.CASH_REGISTER)


func _on_leave_pressed() -> void:
	print_rich(DEBUG_NAME,"OnLeavePressed > Leave pressed!")
	
	AudioManager.play_sound(AudioManager.Sounds.UI_POP_UP,1,0.8)
	
	HudManager.stop_shop()
	

func update_buttons() -> void:
	pass
	#var _tool_purchasable = false
	#var _cost:int= 0
	#for button in button_group.get_buttons():
		#if button.disabled:
			#button.get_child(0).visible = false
			#continue
		#else:
			#button.get_child(0).visible = true
		#match button.text:
			#"Old Handbrush":
				#_tool_purchasable = TT_BRUSH.cost <= InventoryManager.dosh 
				#(button.get_child(0) as Label).text = "$" + str(TT_BRUSH.cost)
			#"Magnifying Glass":
				#pass
			#"Binoculars":
				#_tool_purchasable = TT_BINOCULARS.cost <= InventoryManager.dosh 
				#(button.get_child(0) as Label).text = "$" + str(TT_BINOCULARS.cost)
			#"Metal Detector":
				#_tool_purchasable = TT_METAL_DETECTOR.cost <= InventoryManager.dosh 
				#(button.get_child(0) as Label).text = "$" + str(TT_METAL_DETECTOR.cost)
			#"Old Shovel":
				#_tool_purchasable = TT_SHOVEL.cost <= InventoryManager.dosh 
				#(button.get_child(0) as Label).text = "$" + str(TT_SHOVEL.cost)
			#"Zen Rake":
				#pass
			#"Fishing Rod":
				#pass
			#"Pickerupper":
				#pass
		#if _tool_purchasable:
			##button.disabled = false
			#(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.984, 0.776, 0.592, 1.0))
		#else:
			##button.disabled = true
			#(button.get_child(0) as Label).add_theme_color_override("font_color",Color(0.82, 0.314, 0.357, 1.0))
		#
