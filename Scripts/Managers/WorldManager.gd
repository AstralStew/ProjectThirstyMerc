class_name WorldManager extends Node
static var instance : WorldManager = null
const DEBUG_NAME : String = "[b][WorldManager][/b] "
func _enter_tree() -> void:
	instance = self
	#WorldManager.restart_scene().connect(func():instance = null)


#region PERSISTANT DATA

const DS_BETTING_LADS = preload("uid://bmgsdfulpehaw")
const DS_GENEROUS_BENEFACTORS = preload("uid://dd2nielo8ni6w")
const DS_GROOM_TO_BE = preload("uid://csmb60o0kj3ea")
const DS_LOST_NECKLACE = preload("uid://35ita73ayoir")
const DS_PROSPECTIVE_PROFESSOR = preload("uid://c6f3q77t0owhk")
const DS_SEAGLASS_COLLECTOR = preload("uid://dya4ayqs6r6lm")
const DS_THE_SEA_CAPTAIN = preload("uid://2m12td75roo3")
const DS_THE_PPPP = preload("uid://c1yau71kendsr")
const DS_THE_FISHER_KING = preload("uid://i0dhngucu2u0")
const DS_A_GHOST_MAYBE = preload("uid://ca1fdpnlcfcl5")







static var completed_betting_lads : bool = false
static var completed_generous_benefactors : bool = false
static var completed_groom_to_be : bool = false
static var completed_lost_necklace : bool = false
static var completed_prospective_professor : bool = false
static var completed_seaglass_collector : bool = false
static var completed_the_sea_captain : bool = false
static var completed_the_pppp : bool = false
static var completed_the_fisher_king : bool = false
static var completed_a_ghost_maybe : bool = false


var on_boardwalk:bool = false

var in_water:bool = false

#endregion

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
	



static func get_speed_at_tile_position(global_position:Vector2) -> float:
	return instance._get_speed_at_tile_position(global_position)
func _get_speed_at_tile_position(global_position:Vector2) -> float:
	
	var boardwalk:TileMapLayer = tilemap.find_child("Boardwalk")
	var current_pos = boardwalk.local_to_map(boardwalk.to_local(global_position))
	var _data_at_pos = boardwalk.get_cell_tile_data(current_pos)
	if _data_at_pos && _data_at_pos.has_custom_data("Speed"):
		if _data_at_pos.get_custom_data("Speed") > -1:
			on_boardwalk = true
			in_water = false
			return _data_at_pos.get_custom_data("Speed") as float
	
	on_boardwalk = false
	
	var beach:TileMapLayer = tilemap.find_child("Beach")
	current_pos = beach.local_to_map(beach.to_local(global_position))
	_data_at_pos = beach.get_cell_tile_data(current_pos)
	if _data_at_pos && _data_at_pos.has_custom_data("Speed"):
		if _data_at_pos.get_custom_data("Speed") > -1:
			if _data_at_pos.get_custom_data("Speed") == 0.69:
				in_water = true
			else:
				in_water = false
			return _data_at_pos.get_custom_data("Speed") as float
	
	# Nothing found somehow, return normal speed
	return 1.0



func spawn_collectables() -> void:
	for spawner:SpawnBox in get_tree().get_nodes_in_group("spawners"):
		await spawner.spawn()



static func complete_dialogue(dialogue_setting:DialogueSettings) -> void:
	match dialogue_setting:
		DS_BETTING_LADS:
			completed_betting_lads  = true
		DS_GENEROUS_BENEFACTORS:
			completed_generous_benefactors  = true
		DS_GROOM_TO_BE:
			completed_groom_to_be  = true
		DS_LOST_NECKLACE:
			completed_lost_necklace  = true
		DS_PROSPECTIVE_PROFESSOR:
			completed_prospective_professor  = true
		DS_SEAGLASS_COLLECTOR:
			completed_seaglass_collector  = true
		DS_THE_SEA_CAPTAIN:
			completed_the_sea_captain  = true
		DS_THE_PPPP:
			completed_the_pppp  = true
		DS_THE_FISHER_KING:
			completed_the_fisher_king = true
		DS_A_GHOST_MAYBE:
			completed_a_ghost_maybe = true
			
			
