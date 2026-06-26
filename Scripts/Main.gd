class_name Main extends Node
static var instance : Main = null
const DEBUG_NAME : String = "[b][Main][/b] "
func _enter_tree() -> void:
	instance = self

enum Scene {MENU,GAME,END_DAY}

const MENU_SCENE : PackedScene = preload("uid://cx8j5ddukoq0l")
const GAME_SCENE : PackedScene = preload("uid://pyahp0w2yidh")
const END_DAY_SCENE : PackedScene = preload("uid://bhil8guw1ebbo")


static var current_scene_prefab : PackedScene = null
static var current_scene : Node = null
static var current_scene_type: Scene :
	get:
		match current_scene_prefab:
			MENU_SCENE:
				return Scene.MENU
			GAME_SCENE:
				return Scene.GAME
			END_DAY_SCENE:
				return Scene.END_DAY
		push_error(DEBUG_NAME,"CurrentSceneType Get > Bad scene returned!")
		return -1


@onready var current_scene_holder: Node = $CurrentSceneHolder


static func change_current_scene(scene:Scene) -> void:
	var _scene:PackedScene = null
	match scene:
		Scene.MENU:
			_scene = MENU_SCENE
		Scene.GAME:
			_scene = GAME_SCENE
		Scene.END_DAY:
			_scene = END_DAY_SCENE
	instance._change_current_scene(_scene)
func _change_current_scene(scene:PackedScene) -> void:
	if current_scene != null:
		current_scene.queue_free()
	await get_tree().process_frame
	
	current_scene_prefab = scene
	current_scene = scene.instantiate()
	current_scene_holder.add_child(current_scene)
	
	

#static func restart_current_scene() -> void:
	#instance._restart_current_scene()
#func _restart_current_scene() -> void:
	#if current_scene == null:
		#push_error(DEBUG_NAME,"No current scene loaded, ignoring.")
	#
	#match current_scene:
		#
	#
	#change_current_scene(current_scene_prefab)

func _ready() -> void:
	call_deferred("_change_current_scene",MENU_SCENE)
