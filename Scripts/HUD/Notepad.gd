class_name Notepad extends Rotator
static var instance : Notepad = null
#const DEBUG_NAME : String = "[b][Notepad][/b] "
func _enter_tree() -> void:
	instance = self

@onready var notepad_entries: VBoxContainer = $Gfx/PanelContainer/PanelContainer2/ScrollContainer/NotepadEntries

func _ready() -> void:
	super._ready()
	InventoryManager.on_inventory_changed().connect(update_entries)

static func update_entries(list:Dictionary[CollectableType,int]) -> void:
	instance._update_entries(list)
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

#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
