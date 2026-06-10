class_name DirectionIndicator extends Node2D

@export var offset : Vector2 = Vector2.ZERO
@export_range(0,360) var rotation_range : float = 180

@export_category("READ ONLY")
@export_range(-1,1) var indicator_rotation : float :
	set(value):
		(get_child(0) as Node2D).rotation_degrees = value * rotation_range

var indicator_direction : Vector2 :
	get:
		return (get_child(0) as Node2D).transform.y

func _physics_process(delta: float) -> void:
	global_position = PlayerCharacter.instance.global_position + offset
	rotation = PlayerCharacter.instance.movement_direction.rotated(-PI/2).angle()
