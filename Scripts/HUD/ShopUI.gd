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
	open()
	

func reset_button(button:Button,disabled:bool) -> void:
	button.set_pressed_no_signal(false)
	button.disabled = disabled
	

var _tween: Tween
func open() -> void:
	pass

func close() -> void:
	pass


func on_button_hover(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonHover > Button hovered: '" + button.text + "'")

func on_button_unhover(button:Button) -> void:
	print_rich(DEBUG_NAME,"OnButtonUnhover > Button unhovered: '" + button.text + "'")


func on_button_pressed(button:Button) -> void:
	pass

func _on_leave_pressed() -> void:
	print_rich(DEBUG_NAME,"OnLeavePressed > Leave pressed!")
	
	AudioManager.play_sound(AudioManager.Sounds.UI_POP_UP,1,0.8)
	
	HudManager.stop_shop()
	

func update_buttons() -> void:
	pass
