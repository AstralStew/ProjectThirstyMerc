extends Node

const STONES = preload("uid://tko0goc1w3yl")

@onready var parent : AudioStreamPlayer2D = get_parent()

var is_playing: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playing_rocks() 



func playing_rocks() -> void:
	var times:Array[Vector2] = [Vector2(0,6.3),Vector2(6.3,13.5),Vector2(13.5,17.2),Vector2(17.2,27)]
	var chosen_time:Vector2 = Vector2.ZERO
	while true:
		await get_tree().create_timer(randf_range(8,16)).timeout
		if PlayerCharacter.instance.global_position.distance_squared_to(parent.global_position) < parent.max_distance ** 2:
			chosen_time = times.pick_random()
			AudioManager.play_sound(STONES,0.25 * parent.volume_linear,0.8 + (4*randf()),chosen_time.x,chosen_time.y)
