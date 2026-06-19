class_name Notepad extends Rotator
static var instance : Notepad = null
#const DEBUG_NAME : String = "[b][Notepad][/b] "
func _enter_tree() -> void:
	instance = self

@onready var notepad_entries: VBoxContainer = $Gfx/PanelContainer/PanelContainer2/ScrollContainer/NotepadEntries

@export var bounce_offset: Vector2 = Vector2(-6,-6)
@export var bounce_offset_per_entry: Vector2 = Vector2(-18,-10)
@export var bounce_rotation: float = 15
@export var bounce_scale: float = 1.1
@export var bounce_duration : float = 1
@export var bounce_wait : float = 0.25
@export var bounce_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var bounce_trans: Tween.TransitionType = Tween.TRANS_QUAD

@export_group("READ ONLY")
@export var is_bouncing: bool = false

func _ready() -> void:
	super._ready()
	InventoryManager.on_inventory_changed().connect(update_entries)
	call_deferred("_update_entries",InventoryManager.inventory)
	#call_deferred("resetting")

static func update_entries(list:Dictionary[CollectableType,int]) -> void:
	instance._update_entries(list)
	instance.bounce(list.size())
func _update_entries(list:Dictionary[CollectableType,int]) -> void:
	#if (notepad_entries.get_children()).size() > list.size():
	var _number_of_children = notepad_entries.get_children().size()
	var _list_size = list.size()
	
	if _number_of_children > _list_size:
		if _list_size > 8:
			for i in range (_list_size, _number_of_children):
				notepad_entries.get_child(i).queue_free()
	elif _list_size > _number_of_children:
		for i in (_list_size - _number_of_children):
			notepad_entries.get_child(0).duplicate()
	
	for i in notepad_entries.get_children().size():
		if i < _list_size:
			(notepad_entries.get_child(i) as RichTextLabel).text = str(list.values()[i]) + "x " + (list.keys()[i] as CollectableType).name
		else:
			(notepad_entries.get_child(i) as RichTextLabel).text = ""
	

func _process(delta: float) -> void:
	if is_bouncing: return
	super._process(delta)

func bounce(_list_size:int) -> void:
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel().set_ease(bounce_ease).set_trans(bounce_trans)
	_tween.tween_property(dragged_object,"global_position",_initial_position + bounce_offset + (_list_size * bounce_offset_per_entry),bounce_duration)
	_tween.tween_property(dragged_object,"rotation",deg_to_rad(bounce_rotation),bounce_duration)
	_tween.tween_property(dragged_object,"scale",bounce_scale * Vector2.ONE,bounce_duration)
	_tween.tween_await(get_tree().create_timer(bounce_wait).timeout)
	
	while(_tween.is_running()): await get_tree().process_frame
	is_bouncing = false
	resetting()

	#super.resetting()
	_tween.tween_property(dragged_object,"scale",Vector2.ONE,reset_duration)
