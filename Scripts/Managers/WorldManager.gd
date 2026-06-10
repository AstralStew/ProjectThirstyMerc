class_name WorldManager extends Node
static var instance : WorldManager = null
const DEBUG_NAME : String = "[b][WorldManager][/b] "
func _enter_tree() -> void:
	instance = self

@onready var level: Node2D = $"../../World/Level"
static var level_root : Node2D :
	get: return instance.level

@onready var entities: Node2D = $"../../World/Entities"
static var entities_root : Node2D :
	get: return instance.entities

@onready var effects: Node2D = $"../../World/Effects"
static var effects_root : Node2D :
	get: return instance.effects


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
