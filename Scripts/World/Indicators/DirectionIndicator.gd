class_name DirectionIndicator extends Node2D
static var instance : DirectionIndicator = null
func _enter_tree() -> void:
	if instance != null:
		instance.queue_free()
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)

@export var global_offset : Vector2 = Vector2.ZERO

@export var rotate_to_movement_direction : bool = false
@export var position_x_range : float = 0
@export var position_y_range : float = 0
@export_range(0,360) var rotation_range : float = 0

@export_group("READ ONLY")
@export_range(-1,1) var indicator_position_x : float :
	set(value):
		(get_child(0) as Node2D).position.x = value * position_x_range
		indicator_position_x = value
@export_range(-1,1) var indicator_position_y : float :
	set(value):
		(get_child(0) as Node2D).position.y = value * position_y_range
		indicator_position_y = value
@export_range(-1,1) var indicator_rotation : float :
	set(value):
		(get_child(0) as Node2D).rotation_degrees = value * rotation_range
		indicator_rotation = value

# NOTE - Could be useful in the future, leave it here
#var indicator_direction : Vector2 :
	#get:
		#return (get_child(0) as Node2D).transform.y

func _ready() -> void:
	global_position = PlayerCharacter.instance.global_position + global_offset
	if rotate_to_movement_direction:
		rotation = PlayerCharacter.instance.movement_direction.rotated(-PI/2).angle()

func _physics_process(delta: float) -> void:
	global_position = PlayerCharacter.instance.global_position + global_offset
	if rotate_to_movement_direction:
		rotation = PlayerCharacter.instance.movement_direction.rotated(-PI/2).angle()
