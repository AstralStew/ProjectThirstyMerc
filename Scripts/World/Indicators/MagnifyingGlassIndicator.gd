class_name MagnifyingGlassIndicator extends DirectionIndicator

@onready var area_2d: Area2D = $Node2D/Area2D
@onready var radius_gfx: PanelContainer = $Node2D/CenterContainer/RadiusGfx
#@onready var blur_gfx: PanelContainer = $Node2D/CenterContainer/BlurGfx
#@onready var blur_gfx: Polygon2D = $Node2D/CenterContainer/BlurGfx
@onready var blur_gfx: Polygon2D = $Node2D/BlurGfx


@export var radius : float = 150.0:
	set(value):
		if radius_gfx: radius_gfx.custom_minimum_size = Vector2(value*2,value*2)
		#if blur_gfx: blur_gfx.custom_minimum_size = Vector2(value*2-5,value*2-5)
		if blur_gfx: blur_gfx.scale = Vector2(value / 100,value / 100)
		radius = value
		_sqr_radius = radius * radius

@export var radius_colour : Color = Color.BLUE

var _sqr_radius : float = 0.0

@export_group("READ ONLY")
@export var is_near : bool = false

signal on_near
signal on_far

func _ready() -> void:
	super._ready()
	radius = radius
	_sqr_radius = radius * radius
	radius_gfx.modulate = radius_colour
	
	area_2d.area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	
	if (get_global_mouse_position() - PlayerCharacter.instance.global_position).length_squared() < _sqr_radius:
		if !is_near:
			is_near = true
			area_2d.monitoring = true
			on_near.emit()
		area_2d.global_position = get_global_mouse_position()
	elif is_near:
		is_near = false
		area_2d.monitoring = false
		area_2d.global_position = PlayerCharacter.instance.global_position
		on_far.emit()



func _on_area_entered(area: Area2D) -> void:
	if area is Collectable:
		area.reveal(0.5,false)
