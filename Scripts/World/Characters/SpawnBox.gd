class_name SpawnBox extends ReferenceRect
var DEBUG_NAME: String:
	get: return "[b][" + name + "][/b] "
	
const COLLECTABLE_PREFAB = preload("uid://cqo6tqnt78qv8")


@export var object_types: Dictionary[CollectableType,int] = {}

@export var number_of_chance_items:int = 0
@export var chance_items: Dictionary[CollectableType,float]= {}


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#call_deferred("spawn")

func spawn() -> void:
	
	var _total_items:int = 0
	for _object_type in object_types:
		_total_items += object_types[_object_type]
	_total_items += number_of_chance_items
	var _grid_number:float = sqrt(_total_items)
	print("total items = " + str(_total_items))
	
	var _rect:Rect2 = get_rect()
	var _x_ratio = roundi(_grid_number * (_rect.size.x/_rect.size.y)) +1
	var _y_ratio = roundi(_grid_number * (_rect.size.y/_rect.size.x)) +1
	#print("_x_ratio = " + str(_x_ratio) + "_y_ratio = " + str(_y_ratio))
	var _grid_x_size:float = _rect.size.x / _x_ratio
	var _grid_y_size:float = _rect.size.y / _y_ratio
	#print("_grid_x_size = " + str(_grid_x_size) + "_grid_y_size = " + str(_grid_y_size))
	
	var _pos_candidates: Array[Vector2]
	for x in _x_ratio:
		for y in _y_ratio:
			_pos_candidates.append(Vector2(x * _grid_x_size, y * _grid_y_size))
	_pos_candidates.shuffle()
	print_rich(DEBUG_NAME,"Spawn > Spawning normal object types...")
		
	var _grid_size = Vector2(_grid_x_size,_grid_y_size)
	for _object_type in object_types:
		#var color = Color.from_hsv(randf(),1,1,1)
		print_rich(DEBUG_NAME,"Spawn > Normal spawning " + str(object_types[_object_type]) + " " + _object_type.name)
		for _object_index in object_types[_object_type]:
			#var _new_item:ColorRect = ColorRect.new()
			#_new_item.size = Vector2.ONE * 5
			#_new_item.color = color
			var _new_collectable:Collectable = COLLECTABLE_PREFAB.instantiate()
			_new_collectable.setup(_object_type)
			WorldManager.collectables_root.add_child(_new_collectable)
			_new_collectable.global_position = global_position + _pos_candidates.pop_back() + (_grid_size/2) + (rand_vector(_grid_size * 0.35)) 
			_new_collectable.name = "Spawned_" + _object_type.name
			await get_tree().process_frame
	
	print_rich(DEBUG_NAME,"Spawn > Chance spawning " + str(number_of_chance_items) + " chance items...")
	
	var total_chance:float = 0.0
	var result: float = 0.0
	for i in chance_items.size():
		total_chance += chance_items.values()[i]
	for i in number_of_chance_items:
		var current_total:float= 0.0
		result = randf_range(0,total_chance)
		var _object_type:CollectableType = null
		print_rich(DEBUG_NAME,"Spawn > Chance spawn " + str(i) + " result = " + str(result) + "...")
		for j in chance_items.size():
			print_rich(DEBUG_NAME,"Spawn > Checking chance item " + chance_items.keys()[j].name + " with chance " + str(chance_items.values()[j]) + "...")
			if result < current_total + chance_items.values()[j]:
				print_rich(DEBUG_NAME,"Spawn > Chance Spawning 1 " + chance_items.keys()[j].name)
				_object_type = chance_items.keys()[j]
				var _new_collectable:Collectable = COLLECTABLE_PREFAB.instantiate()
				_new_collectable.setup(_object_type)
				WorldManager.collectables_root.add_child(_new_collectable)
				_new_collectable.global_position = global_position + _pos_candidates.pop_back() + (_grid_size/2) + (rand_vector(_grid_size * 0.35)) 
				_new_collectable.name = "Spawned_" + _object_type.name
				break
				await get_tree().process_frame
			current_total += chance_items.values()[j]
	
var ran_vect: Vector2
func rand_vector(mult:Vector2) -> Vector2:
	ran_vect = Vector2((-1 if randi() % 2 else 1) * randf_range(0.1, 1), (-1 if randi() % 2 else 1) * randf_range(0.1, 1)).normalized()
	return Vector2(ran_vect.x * mult.x,ran_vect.y * mult.y)
