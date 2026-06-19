class_name Collectable extends Area2D

const BURIED_HINT_GRADIENT = preload("uid://6dxrw8q72rvw")


var buried_gfx: Node2D # = $BuriedGfx
var real_gfx: Control # = $RealGfx
var object_gfx: Control  #= $RealGfx/ObjectGfx
var ground_gfx: ColorRect # = $RealGfx/GroundGfx
var real_sprite: Sprite2D = null # = $RealGfx/ObjectGfx/RealSprite


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
	if collectable_type != null: setup(collectable_type)
	#buried_gfx.visible = false
	#real_gfx.visible = false
	#real_gfx.modulate = Color(Color.WHITE,0)

func setup(type:CollectableType) -> void:	
	buried_gfx = $BuriedGfx
	real_gfx = $RealGfx
	object_gfx = $RealGfx/ObjectGfx
	ground_gfx = $RealGfx/GroundGfx
	#real_sprite = $RealGfx/ObjectGfx/RealSprite
	
	buried_gfx.visible = false
	real_gfx.visible = false
	real_gfx.modulate = Color(Color.WHITE,0)
	
	collectable_type = type


var _tween : Tween
var _sample: float = 0
func reveal(duration: float = 1.0,mirage: bool = false):
	if is_collected || !is_buried: return
	
	buried_gfx.visible = true
	buried_gfx.modulate = Color.WHITE
	buried_gfx.position = Vector2.ZERO
	buried_gfx.rotation = 0
	buried_gfx.get_child(0).position = Vector2.ZERO
	buried_gfx.get_child(0).rotation = 0
	
	_sample = 0
	
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel()
	#_tween.tween_property(buried_gfx,"modulate.a",0,duration)
	_tween.tween_property(self,"_sample",1,duration)
	if mirage: 
		_tween.tween_property(buried_gfx,"position",Vector2.ONE * randf() * mirage_strength,duration).set_trans(Tween.TRANS_SINE).from(Vector2.ONE * randf() * mirage_strength).set_ease(Tween.EASE_OUT_IN)
		_tween.tween_property(buried_gfx,"rotation",(randf()-1) * mirage_strength,duration).set_trans(Tween.TRANS_SINE).from((randf()-1) * mirage_strength).set_ease(Tween.EASE_IN_OUT)
		_tween.tween_property(buried_gfx.get_child(0),"position",Vector2.ONE * randf() * mirage_strength,duration).set_trans(Tween.TRANS_SINE).from(Vector2.ONE * randf() * mirage_strength).set_ease(Tween.EASE_IN_OUT)
		_tween.tween_property(buried_gfx.get_child(0),"rotation",(randf()-1) * mirage_strength,duration).set_trans(Tween.TRANS_SINE).from((randf()-1) * mirage_strength).set_ease(Tween.EASE_OUT_IN)
	
	
	while _tween.is_running() && is_buried && !is_collected:
		buried_gfx.modulate = Color(BURIED_HINT_GRADIENT.sample(_sample),min(1,1.5*(1-_sample)))
		await get_tree().process_frame
	buried_gfx.visible = false
	buried_gfx.position = Vector2.ZERO
	



func dig(progress:int = 1) -> void:
	if is_collected: return
	
	if is_buried:
		is_buried = false
		global_position = global_position.lerp(PlayerCharacter.instance.global_position + Vector2(0,player_y_offset_on_start_digging),0.5)
		real_sprite = Sprite2D.new()
		object_gfx.add_child(real_sprite)
		real_sprite.position = Vector2(0,0)
		real_sprite.scale = Vector2(0.5,0.5)
		real_sprite.texture = collectable_type.small_texture
		
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
	_tween.tween_callback(move_to_inventory).set_delay(0.65)
	_tween.tween_callback(create_gain_text).set_delay(0.65)
	while _tween.is_running(): await get_tree().process_frame
	
	queue_free()

func create_gain_text() -> void:
	var _gain_text : GainText = preload("res://Scenes/Prefabs/UI/gain_text.tscn").instantiate()
	HudManager.hud_root.add_child(_gain_text)
	_gain_text.gain("+ " + collectable_type.name.to_upper())

func move_to_inventory() -> void:
	if collectable_type.name == "Coin":
		InventoryManager.add_dosh(1)
	else:
		InventoryManager.add_collectable(collectable_type,1)
