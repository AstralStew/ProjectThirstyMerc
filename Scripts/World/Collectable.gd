class_name Collectable extends Area2D

@onready var gfx: Node2D = $Gfx



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gfx.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var reveal_tween : Tween
func reveal(duration: float = 1.0):
	
	gfx.visible = true
	gfx.modulate = Color.WHITE
	
	if reveal_tween: reveal_tween.kill()
	reveal_tween = create_tween().set_parallel()
	reveal_tween.tween_property(gfx,"modulate",Color(Color.WHITE,0),duration)
	while reveal_tween.is_running(): await get_tree().process_frame
	
	gfx.visible = false
	
