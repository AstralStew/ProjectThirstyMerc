class_name InventoryManager extends Node
static var instance : InventoryManager = null
const DEBUG_NAME : String = "[b][InventoryManager][/b] "
func _enter_tree() -> void:
	instance = self
	WorldManager.restart_scene().connect(func():instance = null)

const CT_BOTTLECAP = preload("uid://4jioa8dy36vc")
const CT_BROKEN_LURE = preload("uid://cc0gsuw7favvy")
const CT_OLD_CAN = preload("uid://d14r0bngcw8lo")
const CT_PULL_TAB = preload("uid://cysb1l4todtv8")


static var inventory : Dictionary[CollectableType,int] = {}
	#CT_BOTTLECAP: 10,
	#CT_OLD_CAN: 10,
	#CT_PULL_TAB: 10,
	#CT_BROKEN_LURE:10
#}
signal _on_collectable_added(collectable)
static func on_collectable_added() -> Signal:
	return instance._on_collectable_added

signal _on_inventory_changed(new_total)
static func on_inventory_changed() -> Signal:
	return instance._on_inventory_changed

static var dosh : int = 6:
	get: return dosh
	set(value):
		dosh = clamp(value,0,1000)
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
		inventory[type] = inventory[type] + amount
		if inventory[type] <= 0:
			inventory.erase(type)
	elif amount > 0:
		inventory[type] = amount
	_on_inventory_changed.emit(inventory)
	_on_collectable_added.emit(type)
	#Notepad.update_entries(inventory)
