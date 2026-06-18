class_name InventoryManager extends Node
static var instance : InventoryManager = null
const DEBUG_NAME : String = "[b][InventoryManager][/b] "
func _enter_tree() -> void:
	instance = self



static var inventory : Dictionary[CollectableType,int] = {}
signal _on_inventory_changed(new_total)
static func on_inventory_changed() -> Signal:
	return instance._on_inventory_changed

static var dosh : int = 15:
	get: return dosh
	set(value):
		dosh = clamp(value,0,1)
signal _on_dosh_changed(new_total)
static func on_dosh_changed() -> Signal:
	return instance._on_dosh_changed


static func add_dosh(amount:int) -> void:
	instance._add_dosh(amount)
func _add_dosh(amount:int) -> void:
	dosh += amount
	_on_dosh_changed.emit(dosh)


static func add_collectable(type:CollectableType,amount:int=1) -> void:
	instance._add_collectable(type,amount)
func _add_collectable(type:CollectableType,amount:int) -> void:
	if inventory.has(type):
		inventory[type] = inventory[type] + 1
	else:
		inventory[type] = 1
	_on_inventory_changed.emit(inventory)
	#Notepad.update_entries(inventory)
