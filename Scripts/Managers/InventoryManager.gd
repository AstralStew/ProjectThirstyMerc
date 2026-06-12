class_name InventoryManager extends Node
static var instance : InventoryManager = null
const DEBUG_NAME : String = "[b][InventoryManager][/b] "
func _enter_tree() -> void:
	instance = self



@export var inventory : Dictionary[CollectableType,int] = {}




static func add(type:CollectableType,amount:int=1) -> void:
	instance._add(type,amount)
func _add(type:CollectableType,amount:int) -> void:
	if inventory.has(type):
		inventory[type] = inventory[type] + 1
	else:
		inventory[type] = 1
	Notepad.update_entries(inventory)
