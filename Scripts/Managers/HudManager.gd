class_name HudManager extends Node
static var instance : HudManager = null
const DEBUG_NAME : String = "[b][HudManager][/b] "
func _enter_tree() -> void:
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)


const DIALOGUE_UI = preload("uid://d1mkaywhdbvgk")
const INSTRUCTIONS_UI = preload("uid://t7ey4k3bnh57")



@export_group("Shop Settings")
@export var shop_zoom_duration: float = 0.69
@export var shop_zoom_amount: float = 2.15
@export var shop_zoom_black_bar_size: float = 30
@export var shop_zoom_ease: Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var shop_zoom_transition: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var shop_zoom_camera_offset: Vector2 = Vector2(0,-20)


@export_group("Talking Settings")
@export var talking_zoom_duration: float = 0.69
@export var talking_zoom_amount: float = 2.15
@export var talking_zoom_black_bar_size: float = 30
@export var talking_zoom_ease: Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var talking_zoom_transition: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR


@export_group("Day Cap Settings")
@export var day_cap_duration: float = 2.0
@export var day_cap_black_background_size: float = 280
@export var day_cap_ease: Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var day_cap_transition: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR


@onready var hud: CanvasLayer = $"../../HUD"
static var hud_root : CanvasLayer :
	get: return instance.hud

var current_shop:ShopUI = null
var current_dialogue:DialogueUI = null



func _ready() -> void:
	
	WorldManager.day_started().connect(_start_day)
	WorldManager.day_ended().connect(_end_day)



var _tween: Tween
static func start_dialogue(offset_to_dialogue_target:Vector2,dialogue_settings:DialogueSettings) -> void:
	instance._start_dialogue(offset_to_dialogue_target,dialogue_settings)
func _start_dialogue(offset_to_dialogue_target:Vector2,dialogue_settings:DialogueSettings) -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(talking_zoom_ease).set_trans(talking_zoom_transition)
	_tween.tween_property(PlayerCharacter.camera,"zoom",Vector2.ONE * talking_zoom_amount,talking_zoom_duration)
	_tween.tween_property(PlayerCharacter.camera,"offset",offset_to_dialogue_target,talking_zoom_duration)
	_tween.tween_property(Bag,"bag_progress",0,talking_zoom_duration)
	
	current_dialogue = DIALOGUE_UI.instantiate()
	hud.add_child(current_dialogue)
	current_dialogue.setup(dialogue_settings)
	


static func stop_dialogue() -> void:
	instance._stop_dialogue()
func _stop_dialogue() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(talking_zoom_ease).set_trans(talking_zoom_transition)
	_tween.tween_callback(current_dialogue.close) # tween_property(shop_ui,"visible",false,0)
	_tween.tween_property(PlayerCharacter.camera,"zoom",Vector2.ONE * 2,talking_zoom_duration)
	_tween.tween_property(PlayerCharacter.camera,"offset",PlayerCharacter.instance.camera_base_offset,talking_zoom_duration)
	_tween.tween_property(Bag,"bag_progress",1,talking_zoom_duration)
	
	await _tween.finished
	PlayerCharacter.stop_talking()

static func complete_quest(reward:int) -> void:
	instance._complete_quest(reward)
func _complete_quest(reward:int) -> void:
	if reward > 0:
		await get_tree().create_timer(0.69).timeout
		InventoryManager.add_dosh(reward)

static func start_shop(shop_character:ShopCharacter) -> void:
	instance._start_shop(shop_character)
func _start_shop(shop_character:ShopCharacter) -> void:
	if _tween: _tween.kill()
	
	_tween = create_tween().set_parallel().set_ease(shop_zoom_ease).set_trans(shop_zoom_transition)
	_tween.tween_property(PlayerCharacter.camera,"zoom",Vector2.ONE * shop_zoom_amount,shop_zoom_duration)
	_tween.tween_property(PlayerCharacter.camera,"offset",shop_zoom_camera_offset,shop_zoom_duration)
	Phone.instance.resetting()
	Notepad.instance.resetting()
	
	current_shop = shop_character.shop_ui.instantiate()
	hud.add_child(current_shop)
	

static func stop_shop() -> void:
	instance._stop_shop()
func _stop_shop() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(shop_zoom_ease).set_trans(shop_zoom_transition)
	_tween.tween_callback(current_shop.close) # tween_property(shop_ui,"visible",false,0)
	_tween.tween_property(PlayerCharacter.camera,"zoom",Vector2.ONE * 2,shop_zoom_duration)
	_tween.tween_property(PlayerCharacter.camera,"offset",PlayerCharacter.instance.camera_base_offset,shop_zoom_duration)

	await _tween.finished
	PlayerCharacter.stop_shopping()






func _start_day() -> void:
	#pass
	if _tween: _tween.kill()
	Bag.bag_progress = 0
	_tween = create_tween().set_parallel().set_ease(day_cap_ease).set_trans(day_cap_transition)
	_tween.tween_callback(ScreenBars.activate.bind(0,day_cap_duration))
	_tween.tween_property(Bag,"bag_progress",1,day_cap_duration/2).from(0).set_delay(day_cap_duration/2)

	

func _end_day() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(talking_zoom_ease).set_trans(talking_zoom_transition)
	_tween.tween_callback(ScreenBars.activate.bind(1,day_cap_duration))
	_tween.tween_property(Bag,"bag_progress",0,day_cap_duration).from(1)
	_tween.set_parallel(false)
	_tween.tween_interval(1.15)
	_tween.tween_callback(display_last_screen)

func display_last_screen() -> void:
	WorldManager.restart_scene().emit()
	Main.change_current_scene(Main.Scene.END_DAY)
	#var end_day_ui = END_DAY_UI.instantiate()
	#hud.add_child(end_day_ui)
	


static func add_instructions(text:String) -> InstructionsUI:
	var new_instructions : InstructionsUI = INSTRUCTIONS_UI.instantiate()
	hud_root.add_child(new_instructions)
	new_instructions.appear(text)
	return new_instructions
