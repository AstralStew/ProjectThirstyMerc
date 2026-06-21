class_name InventoryManager extends Node
static var instance : InventoryManager = null
const DEBUG_NAME : String = "[b][InventoryManager][/b] "
func _enter_tree() -> void:
	instance = self
	if dosh < 6: dosh = 6
	WorldManager.restart_scene().connect(func():instance = null)
#




const CT_BOTTLECAP = preload("uid://4jioa8dy36vc")
const CT_BROKEN_LURE = preload("uid://cc0gsuw7favvy")
const CT_COIN = preload("uid://od6su03rimr5")
const CT_FOSSIL = preload("uid://bs0xhs6kxhexr")
const CT_NECKLACE_EMERALD = preload("uid://ds4vy3o88jy6f")
const CT_NECKLACE_GOLD = preload("uid://cgx64kq3muqp7")
const CT_NECKLACE_RUBY = preload("uid://ck5m6l7jlnh7y")
const CT_NECKLACE_TOPAZ = preload("uid://brk0lv0kl46ty")
const CT_OLD_CAN = preload("uid://d14r0bngcw8lo")
const CT_POTTERY_ANCIENT = preload("uid://dpv66a4sdtc2f")
const CT_POTTERY_CLAY = preload("uid://b71jhg0b6wm7p")
const CT_POTTERY_JADE = preload("uid://cbfm67a57couy")
const CT_POTTERY_PRISTINE = preload("uid://c3006xk01ugbk")
const CT_PULL_TAB = preload("uid://cysb1l4todtv8")
const CT_RING_ANCIENT = preload("uid://bqdlk7np7c12m")
const CT_RING_GOLD = preload("uid://b3ketqrdog68w")
const CT_RING_JADE = preload("uid://dlme0siyqne0q")
const CT_SEA_GLASS_CYAN = preload("uid://bri8u7r1v5itr")
const CT_SEA_GLASS_DARK = preload("uid://dm6n0jgxng1kg")
const CT_SEA_GLASS_RED = preload("uid://ctg1vve2tkxxn")
const CT_SEA_GLASS_VIBRANT = preload("uid://b5ujulgxrg7t2")
const CT_SHARK_TOOTH = preload("uid://cpymbs4tdpnb7")




#region PERSISTANT DATA


static var total_dosh_earned: int = 0
static var total_dosh_spent: int = 0

static var bottlecaps_earned: int = 0


static var total_bottlecap : int = 0 
static var total_broken_lure : int = 0 
static var total_coin : int = 0 
static var total_fossil : int = 0 
static var total_necklace_emerald : int = 0 
static var total_necklace_gold : int = 0 
static var total_necklace_ruby : int = 0
static var total_necklace_topaz : int = 0 
static var total_old_can : int = 0
static var total_pottery_ancient : int = 0 
static var total_pottery_clay : int = 0
static var total_pottery_jade : int = 0 
static var total_pottery_pristine : int = 0
static var total_pull_tab : int = 0 
static var total_ring_ancient : int = 0 
static var total_ring_gold : int = 0 
static var total_ring_jade : int = 0 
static var total_sea_glass_cyan : int = 0 
static var total_sea_glass_dark : int = 0 
static var total_sea_glass_red : int = 0 
static var total_sea_glass_vibrant : int = 0
static var total_shark_tooth : int = 0 


#endregion

static var inventory : Dictionary[CollectableType,int] = {}
	#CT_SEA_GLASS_CYAN: 1,
	#CT_SEA_GLASS_DARK: 1,
	#CT_SEA_GLASS_RED: 1,
	#CT_SEA_GLASS_VIBRANT:1,
	#CT_NECKLACE_GOLD :1
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
	if amount > 0:
		total_dosh_earned += amount
		#AudioManager.play_sound(AudioManager.Sounds.COINS)
	elif amount < 0: total_dosh_spent += abs(amount)
func _add_dosh(amount:int) -> void:
	dosh += amount
	_on_dosh_changed.emit(dosh)


static func add_collectable(type:CollectableType,amount:int=1) -> void:
	instance._add_collectable(type,amount)
func _add_collectable(type:CollectableType,amount:int) -> void:
	if type.name == "Coin":
		InventoryManager.add_dosh(1)
	else:
		if inventory.has(type):
			inventory[type] = inventory[type] + amount
			if inventory[type] <= 0:
				inventory.erase(type)
		elif amount > 0:
			inventory[type] = amount
			AudioManager.play_sound(AudioManager.Sounds.PICKUP)
		_on_inventory_changed.emit(inventory)
		_on_collectable_added.emit(type)
	
	if amount > 0:
		track_total_collectable(type,amount)
	


func track_total_collectable(type:CollectableType,amount:int) -> void:
	match type:
		CT_BOTTLECAP:
			total_bottlecap += amount
		CT_BROKEN_LURE:
			total_broken_lure += amount
		CT_COIN:
			total_coin += amount 
		CT_FOSSIL:
			total_fossil += amount  
		CT_NECKLACE_EMERALD:
			total_necklace_emerald += amount
		CT_NECKLACE_GOLD:
			total_necklace_gold += amount 
		CT_NECKLACE_RUBY:
			total_necklace_ruby += amount
		CT_NECKLACE_TOPAZ:
			total_necklace_topaz += amount 
		CT_OLD_CAN:
			total_old_can += amount
		CT_POTTERY_ANCIENT:
			total_pottery_ancient += amount 
		CT_POTTERY_CLAY:
			total_pottery_clay += amount
		CT_POTTERY_JADE:
			total_pottery_jade += amount
		CT_POTTERY_PRISTINE:
			total_pottery_pristine += amount
		CT_PULL_TAB:
			total_pull_tab += amount 
		CT_RING_ANCIENT:
			total_ring_ancient += amount 
		CT_RING_GOLD:
			total_ring_gold += amount 
		CT_RING_JADE:
			total_ring_jade += amount 
		CT_SEA_GLASS_CYAN:
			total_sea_glass_cyan += amount 
		CT_SEA_GLASS_DARK:
			total_sea_glass_dark += amount 
		CT_SEA_GLASS_RED:
			total_sea_glass_red += amount 
		CT_SEA_GLASS_VIBRANT:
			total_sea_glass_vibrant += amount 
		CT_SHARK_TOOTH:
			total_shark_tooth += amount 
