class_name SpawnBox extends ReferenceRect

@export var object_types: Dictionary[CollectableType,int] = {}


func spawn() -> void:
	
	var _total_items:int = 0
	for object_type in object_types:
		_total_items += object_types[object_type]
	var _grid_size = sqrt(_total_items)
	
	var _rect = get_rect()
	var _pos_candidates: Array[Vector2]
	#for x in grid_size:
		#for y in grid_size:
			#
	
	
	#for item in _total_items:
		
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
