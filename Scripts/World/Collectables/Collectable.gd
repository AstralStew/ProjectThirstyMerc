class_name Collectable extends Area2D

@onready var buried_gfx: Node2D = $BuriedGfx
@onready var real_gfx: Control = $RealGfx
@onready var object_gfx: Control = $RealGfx/ObjectGfx
@onready var ground_gfx: ColorRect = $RealGfx/GroundGfx


@export var collectable_type: CollectableType = null
#@export var digs_required: int = 3
@export var player_y_offset_on_start_digging: float = 10
@export var player_y_offset_on_collect: float = -10
@export var mirage_strength: float = 7


@export_group("READ ONLY")
@export var is_collected: bool = false
@export var is_buried: bool = true
@export_range(0,1) var dig_progress: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buried_gfx.visible = false
	real_gfx.visible = false
	real_gfx.modulate = Color(Color.WHITE,0)
	


var _tween : Tween
func reveal(duration: float = 1.0,mirage: bool = false):
	if is_collected || !is_buried: return
	
	buried_gfx.visible = true
	buried_gfx.modulate = Color.WHITE
	buried_gfx.position = Vector2.ZERO
	buried_gfx.rotation = 0
	buried_gfx.get_child(0).position = Vector2.ZERO
	buried_gfx.get_child(0).rotation = 0
	
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel()
	_tween.tween_property(buried_gfx,"modulate",Color(Color(0.231, 0.075, 0.169, 1.0)*2.5,0),duration)
	if mirage: 
		_tween.tween_property(buried_gfx,"position",Vector2.ONE * randf() * mirage_strength,duration).set_trans(Tween.TRANS_SINE).from(Vector2.ONE * randf() * mirage_strength).set_ease(Tween.EASE_OUT_IN)
		_tween.tween_property(buried_gfx,"rotation",(randf()-1) * mirage_strength,duration).set_trans(Tween.TRANS_SINE).from((randf()-1) * mirage_strength).set_ease(Tween.EASE_IN_OUT)
		_tween.tween_property(buried_gfx.get_child(0),"position",Vector2.ONE * randf() * mirage_strength,duration).set_trans(Tween.TRANS_SINE).from(Vector2.ONE * randf() * mirage_strength).set_ease(Tween.EASE_IN_OUT)
		_tween.tween_property(buried_gfx.get_child(0),"rotation",(randf()-1) * mirage_strength,duration).set_trans(Tween.TRANS_SINE).from((randf()-1) * mirage_strength).set_ease(Tween.EASE_OUT_IN)
	
	
	while _tween.is_running() && is_buried && !is_collected:
		await get_tree().process_frame
	buried_gfx.visible = false
	buried_gfx.position = Vector2.ZERO
	



func dig(progress:int = 1) -> void:
	if is_collected: return
	
	if is_buried:
		is_buried = false
		global_position = global_position.lerp(PlayerCharacter.instance.global_position + Vector2(0,player_y_offset_on_start_digging),0.5)
		real_gfx.set_deferred("visible",true)
	
	dig_progress += progress  # clamp(, 0, max(digs_required - 1,1))
	
	if dig_progress >= collectable_type.digs_required:
		collect()
	
	real_gfx.modulate = Color(Color.WHITE,0.5).lerp(Color.WHITE,dig_progress as float / max(collectable_type.digs_required - 1,1))
	
	object_gfx.position = Vector2(5,9 - (dig_progress as float / max(collectable_type.digs_required - 1,1) * 4))
	

func collect() -> void:
	if is_collected: return
	is_collected = true
	
	var initial_pos = object_gfx.global_position
	object_gfx.reparent(self)
	
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT)
	_tween.tween_property(object_gfx,"global_position",PlayerCharacter.instance.global_position + Vector2(0,player_y_offset_on_collect),0.55).from(initial_pos)
	_tween.tween_property(object_gfx,"modulate",Color(Color.WHITE,0),0.5).set_delay(0.35)
	_tween.tween_property(ground_gfx,"modulate",Color(Color.WHITE,0),0.75)
	_tween.tween_callback(InventoryManager.add.bind(collectable_type,1)).set_delay(0.65)
	_tween.tween_callback(create_gain_text).set_delay(0.65)
	while _tween.is_running(): await get_tree().process_frame
	
	queue_free()

func create_gain_text() -> void:
	var _gain_text : GainText = preload("res://Scenes/Prefabs/UI/gain_text.tscn").instantiate()
	HudManager.hud_root.add_child(_gain_text)
	_gain_text.gain("+ " + collectable_type.name.to_upper())
