class_name Footprints extends Node2D

@export var steps : Array[Sprite2D] = []
@export var distance_between_footsteps : float = 5
@export var time_before_footprint_removed : float = 5

@export var footsteps_before_sound : int = 1

@export_group("READ ONLY")
@export var step_index : int = 0
var steps_since_audio: int = 0

var _last_pos : Vector2 = Vector2.ZERO
var _sqr_distance_between_footsteps : float = -1

func _ready() -> void:
	_last_pos = PlayerCharacter.instance.global_position
	_sqr_distance_between_footsteps = distance_between_footsteps * distance_between_footsteps

func add_footstep() -> void:
	
	var size : int = steps.size()
	
	step_index = (step_index + 1) % size
	steps[step_index].global_position = _last_pos
	steps[step_index].rotation = PlayerCharacter.instance.movement_direction.angle()
	steps[step_index].flip_h = randi() % 2
	steps[step_index].flip_v = randi() % 2
	steps[step_index].visible = true
	for i in size:
		if steps[(step_index - i) % size].visible:
			steps[(step_index - i) % size].modulate = Color(Color.WHITE,(size - i) as float/size)
	
	steps_since_audio = (steps_since_audio + 1) % footsteps_before_sound
	if steps_since_audio == 0:
		AudioManager.play_sound(AudioManager.Sounds.FOOTSTEP,0.35,0.93 + randf(),3.55,4.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if PlayerCharacter.instance.movement_direction == Vector2.ZERO: return
	
	if _last_pos.distance_squared_to(PlayerCharacter.instance.global_position) >= _sqr_distance_between_footsteps:
		_last_pos = PlayerCharacter.instance.global_position
		add_footstep()
		
	
