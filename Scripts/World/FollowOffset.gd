class_name FollowOffset extends Node2D

#@export var target_node: Node2D = null

@export var follow_x: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow_x: global_position.x = PlayerCharacter.instance.global_position.x
