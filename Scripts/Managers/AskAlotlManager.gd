class_name AskAlotlManager extends Node
static var instance : AskAlotlManager = null
const DEBUG_NAME : String = "[b][AskAlotlManager][/b] "
func _enter_tree() -> void:
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)


@export var unprompted_list : Array[String] = []
var local_unprompted_list : Array[String] = []

static func pop_random_unprompted_option() -> String:
	if instance.local_unprompted_list.size() == 0:
		instance.local_unprompted_list = instance.unprompted_list.duplicate()
	return instance.local_unprompted_list.pop_at(randi() % instance.local_unprompted_list.size())


@export var pickup_list : Array[String] = []
var local_pickup_list : Array[String] = []

static func pop_random_pickup_option() -> String:
	if instance.local_pickup_list.size() == 0:
		instance.local_pickup_list = instance.pickup_list.duplicate()
	return instance.local_pickup_list.pop_at(randi() % instance.local_pickup_list.size())
