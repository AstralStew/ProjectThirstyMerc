class_name Phone extends Rotator
static var instance : Phone = null
#const DEBUG_NAME : String = "[b][Phone][/b] "
func _enter_tree() -> void:
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)



const ALOTL_IDLE = preload("uid://cj757bbo2w6ww")
const ALOTL_THINK = preload("uid://bt7t5a0oe1r65")



@onready var balance_label: Label = $Gfx/PanelContainer/VBoxContainer/PanelContainer/PurpleBorder/NotificationHolder/BalanceLabel
@onready var time_label: RichTextLabel = $Gfx/PanelContainer/VBoxContainer/PanelContainer/PurpleBorder/NotificationHolder/TimeLabel

@onready var phone_screen_1: VBoxContainer = $Gfx/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/MarginContainer/MarginContainer/PhoneScreen1
@onready var alotl_speech_label: RichTextLabel = $Gfx/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/MarginContainer/MarginContainer/PhoneScreen1/AlotlSpeechLabel
@onready var alotl_texture: TextureRect = $Gfx/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/MarginContainer/MarginContainer/PhoneScreen1/AlotlTexture

@onready var ask_question_button: Button = $Gfx/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/MarginContainer/MarginContainer/PhoneScreen1/Buttons/AskQuestionButton
@onready var buy_tokens_button: Button = $Gfx/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/MarginContainer/MarginContainer/PhoneScreen1/Buttons/BuyTokensButton


@export var idle_wait_range: Vector2 = Vector2(30,60)
@export var on_collectable_chance: float = 0.3


@export var alotl_speech_speed : float = 1.0

@export var time_since_buzz_up: float = 0.0

func _ready() -> void:
	super._ready()
	
	ask_question_button.pressed.connect(ask_question)
	buy_tokens_button.pressed.connect(buy_token)
	
	InventoryManager.on_dosh_changed().connect(update_dosh)
	balance_label.text = "$" + str(InventoryManager.dosh)
	
	InventoryManager.on_collectable_added().connect(on_collectable_added)
	
	randomly_prompting()

func _process(delta: float) -> void:
	if WorldManager.is_daytime:
		if time_label.text != WorldManager.day_fake_time:
			if time_label.text.split(":")[0] != WorldManager.day_fake_time.split(":")[0]:
				pulse_time()
			time_label.text = WorldManager.day_fake_time
			

var _time_tween:Tween
func pulse_time() -> void:
	time_label.modulate = Color.WHITE * 3
	time_label.offset_transform_scale = Vector2(1.45,1.45)
	if _time_tween: _time_tween.kill()
	_time_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	_time_tween.tween_property(time_label,"modulate",Color.WHITE, 1)
	_time_tween.tween_property(time_label,"offset_transform_scale",Vector2.ONE, 1)

func update_dosh(new_amount:int) -> void:
	balance_label.text = "$" + str(new_amount)
	pulse_dosh()

var _dosh_tween:Tween
var _waiting_to_flash_dosh:bool = false
func pulse_dosh() -> void:
	if _waiting_to_flash_dosh: return
	while(Bag.bag_progress < 1):
		_waiting_to_flash_dosh = true
		if !is_instance_valid(get_tree()): return
		await get_tree().create_timer(0.25).timeout
	_waiting_to_flash_dosh = false
	
	AudioManager.play_sound(AudioManager.Sounds.COINS)
	balance_label.modulate = Color.WHITE * 3
	balance_label.offset_transform_scale = Vector2(1.45,1.45)
	if _dosh_tween: _dosh_tween.kill()
	_dosh_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	_dosh_tween.tween_property(balance_label,"modulate",Color.WHITE, 1)
	_dosh_tween.tween_property(balance_label,"offset_transform_scale",Vector2.ONE, 1)
	

static func alotl_speech(speech:String,delay:float=0.5) -> void:
	instance._alotl_speech(speech)
var _text_tween : Tween
func _alotl_speech(speech:String) -> void:
	if _text_tween: _text_tween.kill()
	alotl_speech_label.visible_ratio = 0
	await get_tree().process_frame
	alotl_speech_label.text = speech
	_text_tween = create_tween()
	_text_tween.tween_property(alotl_speech_label,"visible_ratio",1,(alotl_speech_label.get_total_character_count() as float) / (alotl_speech_speed as float))


func on_collectable_added(type:CollectableType) -> void:
	if randf() > on_collectable_chance: return
	
	
	buzz_up(AskAlotlManager.pop_random_pickup_option())
	


func ask_question() -> void:
	alotl_speech(AskAlotlManager.pop_random_unprompted_option())
	if randi() % 2: alotl_texture.texture = ALOTL_IDLE
	else: alotl_texture.texture = ALOTL_THINK
	WorldManager.day_progress += 0.1


func buy_token() -> void:
	if InventoryManager.dosh < 5:
		alotl_speech("You have insufficient funds, please try again in a few minutes")
		return
	InventoryManager.add_dosh(-5)
	alotl_speech(AskAlotlManager.pop_random_token_option())
	if randi() % 2: alotl_texture.texture = ALOTL_IDLE
	else: alotl_texture.texture = ALOTL_THINK



func randomly_prompting() -> void:
	var random_time: float = 0.0
	await get_tree().create_timer(3.5).timeout
	while(true):
		random_time = randf_range(idle_wait_range.x,idle_wait_range.y)
		while (time_since_buzz_up < random_time):
			time_since_buzz_up += get_physics_process_delta_time()
			if !is_inside_tree() || !is_instance_valid(get_tree()):
				return
			await get_tree().physics_frame
				
		#alotl_speech()
		buzz_up(AskAlotlManager.pop_random_unprompted_option())
		

func buzz_up(text:String) -> void:
	
	time_since_buzz_up = 0
	
	if is_resetting: return
	if is_dragging: return
	if PlayerCharacter.instance.is_talking: return
	
	alotl_speech(text)
	
	if randi() % 2: alotl_texture.texture = ALOTL_IDLE
	else: alotl_texture.texture = ALOTL_THINK
	
	#await get_tree().create_timer(3.5).timeout
	var duration = 0.4
	var target_translation_y = -(dragged_object.position.y - 250) if dragged_object.position.y > 250 else 0
	#if dragged_object.position.y > 250:
	
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_loops(3)
	
	
	_tween.tween_property(dragged_object,"position",Vector2(0, target_translation_y / _tween.get_loops_left()),duration).as_relative().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	_tween.tween_property(dragged_object,"rotation_degrees",3,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	_tween.tween_property(dragged_object,"rotation_degrees",-3,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay(duration/6)
	_tween.tween_property(dragged_object,"rotation_degrees",0,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay((duration/6)*2)
	_tween.tween_property(dragged_object,"rotation_degrees",2,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay((duration/6)*3)
	_tween.tween_property(dragged_object,"rotation_degrees",-2,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay((duration/6)*4)
	_tween.tween_property(dragged_object,"rotation_degrees",0,duration/6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_delay((duration/6)*5)
	_tween.tween_callback(AudioManager.play_sound.bind(AudioManager.Sounds.PHONE_VIBRATION,0.7,0.95,-1.0,0.6))
	_tween.tween_interval(duration*1.5)
	
	
