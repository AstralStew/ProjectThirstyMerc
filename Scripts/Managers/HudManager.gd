class_name HudManager extends Node
static var instance : HudManager = null
const DEBUG_NAME : String = "[b][HudManager][/b] "
func _enter_tree() -> void:
	instance = self

@export var talking_zoom_duration: float = 0.69
@export var talking_zoom_amount: float = 2.15
@export var talking_zoom_black_bar_size: float = 30
@export var talking_zoom_ease: Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var talking_zoom_transition: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR


@export var day_cap_duration: float = 2.0
@export var day_cap_black_background_size: float = 280
@export var day_cap_ease: Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var day_cap_transition: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR


@onready var hud: CanvasLayer = $"../../HUD"
static var hud_root : CanvasLayer :
	get: return instance.hud


@onready var dialogue: Control = $"../../HUD/Dialogue"


@onready var black_bars: VBoxContainer = $"../../HUD/BlackBars"
@onready var black_bars_top: ColorRect = $"../../HUD/BlackBars/BlackBarsTop"
@onready var black_bars_bottom: ColorRect = $"../../HUD/BlackBars/BlackBarsBottom"

static var black_bar_progress: float :
	set(value):
		if black_bar_progress == value: return
		black_bar_progress = clamp(value,0,1)
		if value == 0:
			instance.black_bars.visible = false
		elif value > 0:
			instance.black_bars.visible = true
		instance.black_bars_top.custom_minimum_size.y = instance.talking_zoom_black_bar_size * value
		instance.black_bars_bottom.custom_minimum_size.y = instance.talking_zoom_black_bar_size * value
		black_bar_progress = value

static var black_background_progress: float :
	set(value):
		if black_background_progress == value: return
		black_background_progress = clamp(value,0,1)
		if value == 0:
			instance.black_bars.visible = false
		elif value > 0:
			instance.black_bars.visible = true
		instance.black_bars_top.custom_minimum_size.y = instance.day_cap_black_background_size * value
		instance.black_bars_bottom.custom_minimum_size.y = instance.day_cap_black_background_size * value
		black_background_progress = value


@onready var bag: Control = $"../../HUD/Bag"

static var bag_progress: float :
	set(value):
		if bag_progress == value: return
		bag_progress = clamp(value,0,1)
		if value == 0:
			instance.bag.visible = false
		elif value > 0:
			instance.bag.visible = true
		instance.bag.position.y = 50 * (1-value)
		bag_progress = value


func _ready() -> void:
	#call_deferred("bag_appear")
	WorldManager.day_started().connect(_start_day)
	WorldManager.day_ended().connect(_end_day)

func bag_appear() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(talking_zoom_ease).set_trans(talking_zoom_transition)
	_tween.tween_property(HudManager,"bag_progress",1,talking_zoom_duration)


var _tween: Tween
static func start_dialogue(offset_to_dialogue_target:Vector2) -> void:
	instance._start_dialogue(offset_to_dialogue_target)
func _start_dialogue(offset_to_dialogue_target:Vector2) -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(talking_zoom_ease).set_trans(talking_zoom_transition)
	_tween.tween_property(PlayerCharacter.camera,"zoom",Vector2.ONE * talking_zoom_amount,talking_zoom_duration)
	_tween.tween_property(PlayerCharacter.camera,"offset",offset_to_dialogue_target,talking_zoom_duration)
	_tween.tween_property(HudManager,"black_bar_progress",1,talking_zoom_duration)
	_tween.tween_property(HudManager,"bag_progress",0,talking_zoom_duration)
	_tween.tween_property(dialogue,"visible",true,0).set_delay(talking_zoom_duration)


static func stop_dialogue() -> void:
	instance._stop_dialogue()
func _stop_dialogue() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(talking_zoom_ease).set_trans(talking_zoom_transition)
	_tween.tween_property(dialogue,"visible",false,0)
	_tween.tween_property(PlayerCharacter.camera,"zoom",Vector2.ONE * 2,talking_zoom_duration)
	_tween.tween_property(PlayerCharacter.camera,"offset",PlayerCharacter.instance.camera_base_offset,talking_zoom_duration)
	_tween.tween_property(HudManager,"black_bar_progress",0,talking_zoom_duration)
	_tween.tween_property(HudManager,"bag_progress",1,talking_zoom_duration)
	
	await _tween.finished
	PlayerCharacter.stop_dialogue()


func _start_day() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(day_cap_ease).set_trans(day_cap_transition)
	_tween.tween_property(HudManager,"black_background_progress",0,day_cap_duration).from(1)
	_tween.tween_property(HudManager,"bag_progress",1,day_cap_duration).from(0)

func _end_day() -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(talking_zoom_ease).set_trans(talking_zoom_transition)
	_tween.tween_property(HudManager,"black_background_progress",1,day_cap_duration).from(0)
	_tween.tween_property(HudManager,"bag_progress",0,day_cap_duration).from(1)
	
