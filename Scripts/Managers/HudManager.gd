class_name HudManager extends Node
static var instance : HudManager = null
const DEBUG_NAME : String = "[b][HudManager][/b] "
func _enter_tree() -> void:
	instance = self

@onready var hud: CanvasLayer = $"../../HUD"
static var hud_root : CanvasLayer :
	get: return instance.hud
