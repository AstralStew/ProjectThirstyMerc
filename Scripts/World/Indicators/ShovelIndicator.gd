class_name ShovelIndicator extends DirectionIndicator
const DEBUG_NAME : String = "[b][ShovelIndicator][/b] "



@onready var area_2d: Area2D = $Node2D/Area2D


@export var progress_per_dig : int = 1

@export_range(-1,0) var dig_up_threshold : float = -1
@export_range(-1,1) var dig_down_threshold : float = 0.8

@export_group("READ ONLY")
@export var shovel_up : bool = false
@export var ready_to_dig : bool = false

#signal on_ready_to_dig
#signal on_dig

#signal dig_down
#signal dig_up


func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !ready_to_dig && !shovel_up && indicator_position_y <= dig_up_threshold:
		shovel_up = true
		print_rich(DEBUG_NAME,"PhysicsProcess > Shovel up! Indicator pos y = " + str(indicator_position_y))
	elif shovel_up && indicator_position_y >= dig_down_threshold:
		ready_to_dig = true
		shovel_up = false
		print_rich(DEBUG_NAME,"PhysicsProcess > Ready to dig! Indicator pos y = " + str(indicator_position_y))
		
		if area_2d.has_overlapping_areas():
			for _area in area_2d.get_overlapping_areas():
				_on_area_entered(_area)
				if !ready_to_dig: break
		
		#on_ready_to_dig.emit()


func _on_area_entered(area: Area2D) -> void:
	if ready_to_dig && area is Collectable:
		print_rich(DEBUG_NAME,"OnAreaEntered")
		area.dig(progress_per_dig)
		ready_to_dig = false
		#on_dig.emit()
