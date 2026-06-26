class_name Notepad extends Rotator
static var instance : Notepad = null
#const DEBUG_NAME : String = "[b][Notepad][/b] "
func _enter_tree() -> void:
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)

@onready var scroll_container: ScrollContainer = $Gfx/PanelContainer/PanelContainer2/ScrollContainer
@onready var notepad_entries: VBoxContainer = $Gfx/PanelContainer/PanelContainer2/ScrollContainer/NotepadEntries

@export var scroll_move_duration: float = 0.05
@export var scroll_linger_duration: float = 1.0

@export var bounce_offset: Vector2 = Vector2(-6,-6)
@export var bounce_offset_per_entry: Vector2 = Vector2(-3,-2)
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
	on_drag_start.connect(scroll_list)
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
				print("too many notepad items, removing 1")
				notepad_entries.get_child(i).queue_free()
	elif _list_size > _number_of_children:
		for i in (_list_size - _number_of_children):
			var new_entry = notepad_entries.get_child(0).duplicate()
			notepad_entries.add_child(new_entry)
			print("not enough notepad items, adding 1")
	
	for i in notepad_entries.get_children().size():
		if i < _list_size:
			(notepad_entries.get_child(i) as RichTextLabel).text = str(list.values()[-i-1]) + "x " + (list.keys()[-i-1] as CollectableType).name
		else:
			(notepad_entries.get_child(i) as RichTextLabel).text = ""
	

func scroll_list() -> void:
	var moving_down:bool = true
	while (is_dragging):
		if moving_down:
			if scroll_container.scroll_vertical != scroll_container.get_v_scroll_bar().max_value - scroll_container.size.y:
				scroll_container.set_deferred("scroll_vertical", scroll_container.scroll_vertical + 1)
				print("scroll = " + str(scroll_container.scroll_vertical) +", bar max =" + str(scroll_container.get_v_scroll_bar().max_value - scroll_container.size.y))
			
			else:
				moving_down = false
				await get_tree().create_timer(scroll_linger_duration).timeout
		else:
			if scroll_container.scroll_vertical != 0:
				scroll_container.set_deferred("scroll_vertical", scroll_container.scroll_vertical - 1)
			else:
				moving_down = true
				await get_tree().create_timer(scroll_linger_duration).timeout
		await get_tree().create_timer(scroll_move_duration).timeout
	scroll_container.scroll_vertical = 0

func _process(delta: float) -> void:
	if is_bouncing: return
	super._process(delta)

func bounce(_list_size:int) -> void:
	if !is_usable: return
	if is_bouncing: return
	is_bouncing = true
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
