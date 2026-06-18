class_name Shop extends Control
var DEBUG_NAME: String:
	get: return "[b][" + name + "][/b] "

const TT_BINOCULARS = preload("uid://beg2wll35sp7e")
const TT_METAL_DETECTOR = preload("uid://dw1nos3tpluk4")
const TT_SHOVEL = preload("uid://cys46dx7t1gui")


@export var button_group: ButtonGroup = null

@onready var purchase: Button = $Tools/Purchase
@onready var leave: Button = $Tools/Leave



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_group.pressed.connect(on_button_pressed)
	for button in button_group.get_buttons():
		button.mouse_entered.connect(on_button_hover.bind(button))
		button.mouse_exited.connect(on_button_unhover.bind(button))
		
		
		
	
	#InventoryManager.on_dosh_changed().connect(on_dosh_updated)
	
	#on_dosh_updated(InventoryManager.dosh)
	

func reset_button(button:Button,disabled:bool) -> void:
	button.set_pressed_no_signal(false)
	button.disabled = disabled
	button.get_child(0).visible = !disabled
	
	



func on_button_hover(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonHover > Button hovered: '" + button.text + "'")

func on_button_unhover(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonUnhover > Button unhovered: '" + button.text + "'")


func on_button_pressed(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonPress > Button pressed: '" + button.text + "'")
	if !button_group.get_pressed_button():
		purchase.disabled = true
		return
	if Bag.is_full:
		purchase.disabled = true
		return
	
	
	match button.text:
		"Old Handbrush":
			pass 
		"Magnifying Glass":
			pass
		"Binoculars":
			#print("result = " + str(TT_BINOCULARS.cost) + ">" + str(InventoryManager.dosh) + "? " + str(TT_BINOCULARS.cost > InventoryManager.dosh))
			purchase.disabled = TT_BINOCULARS.cost > InventoryManager.dosh
		"Metal Detector":
			#print("result = " + str(TT_METAL_DETECTOR.cost) + ">" + str(InventoryManager.dosh) + "? " + str(TT_METAL_DETECTOR.cost > InventoryManager.dosh))
			purchase.disabled = TT_METAL_DETECTOR.cost > InventoryManager.dosh
		"Old Shovel":
			#print("result = " + str(TT_SHOVEL.cost) + ">" + str(InventoryManager.dosh) + "? " + str(TT_SHOVEL.cost > InventoryManager.dosh))
			purchase.disabled = TT_SHOVEL.cost > InventoryManager.dosh
		"Zen Rake":
			pass
		"Fishing Rod":
			pass
		"Pickerupper":
			pass
	
	#reset_button(button,true)
	



func _on_purchase_pressed() -> void:
	print_rich(DEBUG_NAME,"OnPurchasePress > Purchase pressed!")
	var button:Button = button_group.get_pressed_button()
	
	match button.text:
		"Old Handbrush":
			pass
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
	purchase.disabled = true


func _on_leave_pressed() -> void:
	print_rich(DEBUG_NAME,"OnLeavePressed > Leave pressed!")
	
	HudManager.stop_shop()
	

#func on_dosh_updated(dosh_remaining:int) -> void:
	#for button in button_group.get_buttons():
		#match button.text:
			#"Old Handbrush":
				#pass 
			#"Magnifying Glass":
				#pass
			#"Binoculars":
				#if TT_BINOCULARS.cost > dosh_remaining:
					#button.disabled = true
			#"Metal Detector":
				#if TT_METAL_DETECTOR.cost > dosh_remaining:
					#button.disabled = true
			#"Old Shovel":
				#if TT_SHOVEL.cost > dosh_remaining:
					#button.disabled = true
			#"Zen Rake":
				#pass
			#"Fishing Rod":
				#pass
			#"Pickerupper":
				#pass
