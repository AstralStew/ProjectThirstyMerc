class_name TchotchkeShopUI extends ShopUI


@onready var options_margin_container: MarginContainer = $Options/OptionsMarginContainer


@export var possible_items: Array[CollectableType] = []




#@onready var rent: Button = $Rent

static var today_items: Array[CollectableType] = []
static var tomorrow_items: Array[CollectableType] = []


func _ready() -> void:
	if today_items.size() == 0:
		today_items = populate_four_items()
		print("today items = " + str(today_items))
	if tomorrow_items.size() == 0:
		tomorrow_items = populate_four_items()
		print("tomorrow items = " + str(tomorrow_items))
	
	for i in 8:
		if i < 4:
			(button_group.get_buttons()[i] as Button).text = "1 " + today_items[i].name
			(button_group.get_buttons()[i] as Button).disabled = InventoryManager.inventory.has(today_items[i])
			(button_group.get_buttons()[i].get_child(0) as Label).text = "$" + str(today_items[i].price)
			print("today button text = " + (button_group.get_buttons()[i] as Button).text)
		else:
			(button_group.get_buttons()[i] as Button).text = "1 " + tomorrow_items[i-4].name
			(button_group.get_buttons()[i] as Button).disabled = InventoryManager.inventory.has(tomorrow_items[i-4])
			(button_group.get_buttons()[i].get_child(0) as Label).text = "$" + str(tomorrow_items[i-4].price)
			print("today button text = " + (button_group.get_buttons()[i] as Button).text)
	
	if !WorldManager.day_ended().is_connected(wipe_chosen_items):
		WorldManager.day_ended().connect(wipe_chosen_items)
	
	super._ready()

func populate_four_items() -> Array[CollectableType]:
	var items:Array[CollectableType] = []
	var chosen_item:CollectableType = null
	for i in 3:
		chosen_item = null
		while chosen_item == null:
			chosen_item = possible_items[randi_range(0,9)]
			if items.has(chosen_item) || today_items.has(chosen_item) || tomorrow_items.has(chosen_item):
				print("already has "+chosen_item.name+", redoing choice #"+str(i))
				chosen_item = null
				continue
		print("common choice #"+str(i)+" = "+chosen_item.name)
		items.append(chosen_item)
	chosen_item = null
	while chosen_item == null:
		chosen_item = possible_items[randi_range(8,16)]
		if items.has(chosen_item) || today_items.has(chosen_item) || tomorrow_items.has(chosen_item):
			print("already has "+chosen_item.name+", redoing choice")
			chosen_item = null
			continue
	print("rare choice = "+chosen_item.name)
	items.append(chosen_item)
	return items



static func wipe_chosen_items() -> void:
	print_rich("[TchotchkeShopUI(Static)] WipeChosenItems > Completed!")
	today_items = tomorrow_items.duplicate()
	tomorrow_items.clear()

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
	if index < 4:
		if InventoryManager.inventory.has(today_items[index]):
			InventoryManager.add_collectable(today_items[index],-1)
			InventoryManager.add_dosh(today_items[index].price)
	else:
		if InventoryManager.inventory.has(tomorrow_items[index-4]):
			InventoryManager.add_collectable(tomorrow_items[index-4],-1)
			InventoryManager.add_dosh(tomorrow_items[index-4].price)
	
	update_buttons()
	
	AudioManager.play_sound(AudioManager.CASH_REGISTER)
	
	

func _on_leave_pressed() -> void:
	print_rich(DEBUG_NAME,"OnLeavePressed > Leave pressed!")
	
	AudioManager.play_sound(AudioManager.UI_POP_UP,1,0.8)
	
	HudManager.stop_shop()
	

func update_buttons() -> void:
	var active: bool = false
	var button: Button = null
	for i in 8:
		if i < 4:
			active = InventoryManager.inventory.has(today_items[i]) && InventoryManager.inventory[today_items[i]] >= 1
			button = button_group.get_buttons()[i]
		else:
			active = InventoryManager.inventory.has(tomorrow_items[i-4]) && InventoryManager.inventory[tomorrow_items[i-4]] >= 1
			button = button_group.get_buttons()[i]

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
		
