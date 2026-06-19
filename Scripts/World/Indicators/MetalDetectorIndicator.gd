class_name MetalDetectorIndicator extends DirectionIndicator




@onready var area_2d: Area2D = $Node2D/Area2D

@export_group("READ ONLY")
@export var current_distance: float
@export var beep_range_near: float = 1000

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _physics_process(delta: float) -> void:
	if area_2d.has_overlapping_areas():
		#print("yep")
		var _closest_area: Area2D = null
		var _new_distance: float = 0
		for _area in area_2d.get_overlapping_areas():
			if _area is Collectable:
				if !_area.collectable_type.is_metal:
					continue
				#print("also yep, _new_distance = " + str(_new_distance) +", ")
				_new_distance = area_2d.global_position.distance_squared_to(_area.global_position)
				if _new_distance < current_distance:
					current_distance = _new_distance
					_closest_area = _area
				#print("current_distance = " + str(current_distance) + ", _new_distance = " + str(_new_distance) + ", beep range near = " + str(beep_range_near ** 2))
				
					
		if _closest_area != null && current_distance < beep_range_near ** 2: 
			print("area found at " + str(current_distance))
			_closest_area.reveal()
			
		
	else:
		current_distance = 100000

#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area is Collectable:
		#current_distance = global_position.distance_squared_to(area.global_position)
		#if current_distance < beep_range_near: 
			#area.reveal()
			
