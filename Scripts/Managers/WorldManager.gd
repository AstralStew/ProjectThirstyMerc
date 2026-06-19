class_name WorldManager extends Node
static var instance : WorldManager = null
const DEBUG_NAME : String = "[b][WorldManager][/b] "
func _enter_tree() -> void:
	instance = self
	#WorldManager.restart_scene().connect(func():instance = null)

@onready var level: Node2D = $"../../World/Level"
static var level_root : Node2D :
	get: return instance.level

@onready var tilemap: Node = $"../../World/Level/Tilemap"


@onready var entities: Node2D = $"../../World/Entities"
static var entities_root : Node2D :
	get: return instance.entities
	
@onready var collectables: Node2D = $"../../World/Entities/Collectables"
static var collectables_root : Node2D :
	get: return instance.collectables

@onready var effects: Node2D = $"../../World/Effects"
static var effects_root : Node2D :
	get: return instance.effects

@export var day_duration: float = 20
@export var day_start_in_mins: float = 480
@export var day_end_in_mins: float = 1201
# total mins = 1440

#@export_category("READ ONLY")
static var is_daytime : bool = false
static var is_paused : bool = false

static var day_progress: float = 0 :
	get: return day_progress
	set(value):
		day_progress = clamp(value,0,1)
static var day_fake_mins: int :
	get: return instance.get_fake_mins_from_progress(day_progress)
static var day_fake_time: String :
	get: return instance.convert_fake_mins_to_fake_time(day_fake_mins)

signal _day_started
static func day_started() -> Signal:
	return instance._day_started
signal _day_paused
static func day_paused() -> Signal:
	return instance._day_paused
signal _day_resumed
static func day_resumed() -> Signal:
	return instance._day_resumed
signal _day_ended
static func day_ended() -> Signal:
	return instance._day_ended
signal _restart_scene
static func restart_scene() -> Signal:
	return instance._restart_scene

func get_fake_mins_from_progress(progress:float) -> int:
	#print("fake mins = " + str(remap(progress,0,1,day_start_in_mins,day_end_in_mins)))
	return floori(remap(progress,0,1,day_start_in_mins,day_end_in_mins))

func convert_fake_mins_to_fake_time(mins:int) -> String:
	return str(mins/60) + ":" + str(floor((mins % 60) / 10)) + "0"


func _ready() -> void:
	call_deferred("start_day")





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_daytime && !is_paused: 
		progress_day(delta)

func progress_day(delta: float) -> void:	
	day_progress += 1 / day_duration * delta
	
	if day_progress >= 1:
		end_day()

static func start_day() -> void:
	
	await instance.spawn_collectables()
	
	instance.day_progress = 0
	is_daytime = true
	day_started().emit()
	print(DEBUG_NAME,"StartDay > Starting day!")




static func pause_day() -> void:
	is_paused = true
	day_paused().emit()
	print(DEBUG_NAME,"PauseDay > Pausing day!")

static func resume_day() -> void:
	is_paused = false
	day_resumed().emit()
	print(DEBUG_NAME,"ResumeDay > Resuming day!")

static func end_day() -> void:
	instance.day_progress = 1
	is_daytime = false
	day_ended().emit()
	print(DEBUG_NAME,"EndDay > Ending day!")
	
	await instance.get_tree().create_timer(4).timeout
	instance._restart_scene.emit()
	instance.get_tree().call_deferred("reload_current_scene") # .reload_current_scene.call_deferred() # .call_deferred("reload_current_scene")
	



static func get_speed_at_tile_position(global_position:Vector2) -> float:
	return instance._get_speed_at_tile_position(global_position)
func _get_speed_at_tile_position(global_position:Vector2) -> float:
	
	var boardwalk:TileMapLayer = tilemap.find_child("Boardwalk")
	var current_pos = boardwalk.local_to_map(boardwalk.to_local(global_position))
	var _data_at_pos = boardwalk.get_cell_tile_data(current_pos)
	if _data_at_pos && _data_at_pos.has_custom_data("Speed"):
		if _data_at_pos.get_custom_data("Speed") > -1:
			return _data_at_pos.get_custom_data("Speed") as float
	
	var beach:TileMapLayer = tilemap.find_child("Beach")
	current_pos = beach.local_to_map(beach.to_local(global_position))
	_data_at_pos = beach.get_cell_tile_data(current_pos)
	if _data_at_pos && _data_at_pos.has_custom_data("Speed"):
		if _data_at_pos.get_custom_data("Speed") > -1:
			return _data_at_pos.get_custom_data("Speed") as float
	
	# Nothing found somehow, return normal speed
	return 1.0



func spawn_collectables() -> void:
	for spawner:SpawnBox in get_tree().get_nodes_in_group("spawners"):
		await spawner.spawn()
