class_name NPCharacter extends MovingAgent
var DEBUG_NAME : String = "[b][NPCharacter("+name+")][/b] "

@export var do_wander : bool = false
@export var wander_wait_time : float = 5.0


@export var wander_points : Array[Vector2] = [Vector2.ZERO,Vector2.ONE]

@export_category("READ ONLY")
@export var is_wandering : bool = false
@export var wander_point_index : int = 0



func actor_setup():
	await super.actor_setup()
	if do_wander:
		is_wandering = true
		wandering()

func wandering() -> void:
	await get_tree().create_timer(wander_wait_time).timeout
	if !is_wandering: return
	wander_point_index = (wander_point_index + 1) % wander_points.size()
	set_movement_target(wander_points[wander_point_index])


func on_navigation_finished() -> void:
	super.on_navigation_finished()
	#print("beep")
	wandering()





func _on_gui_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("Click"):
		# any checks that happen here
		
		PlayerCharacter.start_dialogue()
