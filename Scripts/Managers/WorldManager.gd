class_name WorldManager extends Node
static var instance : WorldManager = null
const DEBUG_NAME : String = "[b][WorldManager][/b] "
func _enter_tree() -> void:
	instance = self

@onready var level: Node2D = $"../../World/Level"
static var level_root : Node2D :
	get: return instance.level

@onready var tile_map_layer: TileMapLayer = $"../../World/Level/TileMapLayer"


@onready var entities: Node2D = $"../../World/Entities"
static var entities_root : Node2D :
	get: return instance.entities

@onready var effects: Node2D = $"../../World/Effects"
static var effects_root : Node2D :
	get: return instance.effects

@export var day_duration: float = 120
@export var day_start_in_mins: float = 480
@export var day_end_in_mins: float = 480
# total mins = 1440

#@export_category("READ ONLY")
static var is_daytime : bool = false

var day_progress: float = 0 :
	get: return day_progress
	set(value):
		day_progress = clamp(value,0,1)
var day_fake_time: float = 0 :
	get:
		
		return day_progress
	set(value):
		day_progress = clamp(value,0,1)

signal _day_started
static func day_started() -> Signal:
	return instance._day_started
signal _day_ended
static func day_ended() -> Signal:
	return instance._day_ended


func get_fake_mins_from_progress(progress:float) -> void:
	return remap(day_progress,0,1,day_start_in_mins,day_end_in_mins)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_daytime: 
		progress_day(delta)

func progress_day(delta: float) -> void:
	
	day_progress += 1 / day_duration * delta
	
	if day_progress >= 1:
		end_day()

static func start_day() -> void:
	instance.day_progress = 0
	is_daytime = true
	day_started().emit()

static func end_day() -> void:
	instance.day_progress = 1
	is_daytime = false
	day_ended().emit()

static func get_speed_at_tile_position(global_position:Vector2) -> float:
	var current_tile_pos = instance.tile_map_layer.local_to_map(instance.tile_map_layer.to_local(global_position))
	var _data_at_pos = instance.tile_map_layer.get_cell_tile_data(current_tile_pos)
	if _data_at_pos && _data_at_pos.has_custom_data("Speed"):
		#print("speed = " + str(_data_at_pos.get_custom_data("Speed") as float))
		return _data_at_pos.get_custom_data("Speed") as float
	else:
		return 1.0

#var nav_regions: Array[NavigationRegion2D]
#var rand_point_gens: Array[PolygonRandomPointGenerator]
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#for nav_region in get_tree().get_nodes_in_group("SpawnRegions"):
		#nav_regions.append(nav_region as NavigationRegion2D)
		#var _polygon = (nav_region as NavigationRegion2D).navigation_polygon.get_outline()
		#var _new_rand_point_gen = PolygonRandomPointGenerator.new()
	#
