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

#
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



## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
