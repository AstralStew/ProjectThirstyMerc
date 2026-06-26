class_name ScreenBars extends VBoxContainer
static var instance : ScreenBars = null
const DEBUG_NAME : String = "[b][ScreenBars][/b] "
func _enter_tree() -> void:
	instance = self

@onready var screen_bars_top: ColorRect = $ScreenBarsTop
@onready var screen_bars_bottom: ColorRect = $ScreenBarsBottom


static var screen_bar_progress: float = 1:
	set(value):
		if !instance: return
		screen_bar_progress = clamp(value,0,1)
		if value == 0:
			instance.visible = false
		elif value > 0:
			instance.visible = true
		instance.screen_bars_top.custom_minimum_size.y = 150 * value
		instance.screen_bars_bottom.custom_minimum_size.y = 150 * value
		screen_bar_progress = value



static func change_color(color:Color=Color(0.231, 0.075, 0.169, 1.0)) -> void:
	if !instance: return
	instance._change_color(color)
func _change_color(color:Color) -> void:
	screen_bars_top.modulate = color
	screen_bars_bottom.modulate = color


var _tween:Tween
static func activate(value:float,duration:float = 3.0,ease_type:Tween.EaseType=Tween.EASE_OUT,trans_type:Tween.TransitionType=Tween.TRANS_SINE) -> void:
	if !instance: return
	instance._activate(value,duration,ease_type,trans_type)
func _activate(value:float,duration:float,ease_type:Tween.EaseType,trans_type) -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_ease(ease_type).set_trans(trans_type)
	_tween.tween_property(self,"screen_bar_progress",value,duration)
	
 
