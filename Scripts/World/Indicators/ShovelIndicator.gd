class_name ShovelIndicator extends DirectionIndicator
const DEBUG_NAME : String = "[b][ShovelIndicator][/b] "

@onready var area_2d: Area2D = $Node2D/Area2D

@export var progress_per_dig : int = 1

@export_range(-1,0) var dig_up_threshold : float = -1
@export_range(-1,1) var dig_down_threshold : float = 0.8

@export_group("READ ONLY")
@export var shovel_up : bool = false
@export var ready_to_dig : bool = false


signal dig_up
signal dig_down


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	print_rich(DEBUG_NAME,"PhysicsProcess > shovel_up = " + str(shovel_up) + ", ready to dig = " + str(ready_to_dig))
	if !shovel_up && indicator_position_y <= dig_up_threshold:
		shovel_up = true
		print_rich(DEBUG_NAME,"PhysicsProcess > Shovel up! Indicator pos y = " + str(indicator_position_y))
		dig_up.emit()
	elif shovel_up && indicator_position_y >= dig_down_threshold:
		shovel_up = false
		print_rich(DEBUG_NAME,"PhysicsProcess > Ready to dig! Indicator pos y = " + str(indicator_position_y))
		dig_down.emit()
		if area_2d.has_overlapping_areas():
			for _area in area_2d.get_overlapping_areas():
				_on_area_entered(_area)
				if !ready_to_dig: break


func _on_area_entered(area: Area2D) -> void:
	if area is Collectable:
		print_rich(DEBUG_NAME,"OnAreaEntered")
		area.dig(progress_per_dig)
		ready_to_dig = false
