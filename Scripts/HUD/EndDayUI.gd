class_name EndDayUI extends Control
const DEBUG_NAME : String = "[b][EndDayUI][/b] "

@onready var gfx: Control = $Book/Gfx


### ITEMS

@onready var coins: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/Coins
@onready var bottlecaps: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/Bottlecaps
@onready var pull_tabs: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/PullTabs
@onready var old_cans: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/OldCans
@onready var broken_lures: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/BrokenLures
@onready var cyan_seaglass: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/CyanSeaglass
@onready var red_seaglass: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/RedSeaglass
@onready var dark_seaglass: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/DarkSeaglass
@onready var vibrant_seaglass: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/VibrantSeaglass
@onready var shark_tooth: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/SharkTooth
@onready var clay_pottery: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/ClayPottery
@onready var jade_pottery: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/JadePottery
@onready var pristine_pottery: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/PristinePottery
@onready var ancient_pottery: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/AncientPottery
@onready var gold_ring: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/GoldRing
@onready var jade_ring: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/JadeRing
@onready var ancient_ring: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/AncientRing
@onready var topaz_necklace: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/TopazNecklace
@onready var gold_necklace: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/GoldNecklace
@onready var ruby_necklace: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/RubyNecklace
@onready var emerald_necklace: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/EmeraldNecklace
@onready var fossil: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/Fossil

### BEACHGOERS

@onready var betting_lads: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/BettingLads
@onready var generous_benefactors: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/GenerousBenefactors
@onready var groom_to_be: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/GroomToBe
@onready var lost_necklace: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/LostNecklace
@onready var prospective_professor: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/ProspectiveProfessor
@onready var seaglass_collector: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/SeaglassCollector
@onready var the_sea_captain: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/TheSeaCaptain
@onready var the_pppp: RichTextLabel = $"Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/The PPPP"
@onready var the_fisher_king: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/TheFisherKing
@onready var a_ghost_maybe: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/AGhostMaybe


### ALLOWANCE

@onready var dosh_earned: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/Allowance/DoshEarned
@onready var dosh_spent: RichTextLabel = $Book/Gfx/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/RightPanel/Border/RightPage/Allowance/DoshSpent


@onready var leave: Button = $Book/Gfx/MarginContainer/VBoxContainer/Leave

func _ready() -> void:
	leave.pressed.connect(on_button_clicked)
	set_allowance()
	set_collectables()
	set_dialogues() 
	call_deferred("move_in")




func set_allowance() -> void:
	dosh_earned.text = "Earned: $" + str(InventoryManager.total_dosh_earned)
	dosh_spent.text = "Spent: $" + str(InventoryManager.total_dosh_spent)

func set_collectables() -> void:
	
	coins.text = "???" if InventoryManager.total_coin == 0 else str(InventoryManager.total_coin) + "x Coins"	
	bottlecaps.text = "???" if InventoryManager.total_bottlecap == 0 else str(InventoryManager.total_bottlecap) + "x Bottlecaps"
	pull_tabs.text =  "???" if InventoryManager.total_pull_tab == 0 else str(InventoryManager.total_pull_tab) + "x Pull Tabs"
	old_cans.text =  "???" if InventoryManager.total_old_can == 0 else str(InventoryManager.total_old_can) + "x Old Cans"
	broken_lures.text =  "???" if InventoryManager.total_broken_lure == 0 else str(InventoryManager.total_broken_lure) + "x Broken Lures"
	cyan_seaglass.text =  "???" if InventoryManager.total_sea_glass_cyan == 0 else str(InventoryManager.total_sea_glass_cyan) + "x Cyan Seaglass"
	red_seaglass.text =  "???" if InventoryManager.total_sea_glass_red == 0 else str(InventoryManager.total_sea_glass_red) + "x Red Seaglass"
	dark_seaglass.text =  "???" if InventoryManager.total_sea_glass_dark == 0 else str(InventoryManager.total_sea_glass_dark) + "x Dark Seaglass"
	vibrant_seaglass.text =  "???" if InventoryManager.total_sea_glass_vibrant == 0 else str(InventoryManager.total_sea_glass_vibrant) + "x Vibrant Seaglass"
	shark_tooth.text =  "???" if InventoryManager.total_shark_tooth == 0 else str(InventoryManager.total_shark_tooth) + "x Shark Teeth"
	clay_pottery.text =  "???" if InventoryManager.total_pottery_clay == 0 else str(InventoryManager.total_pottery_clay) + "x Clay Pottery"
	jade_pottery.text =  "???" if InventoryManager.total_pottery_jade == 0 else str(InventoryManager.total_pottery_jade) + "x Jade Pottery"
	pristine_pottery.text =  "???" if InventoryManager.total_pottery_pristine == 0 else str(InventoryManager.total_pottery_pristine) + "x Pristine Pottery"
	ancient_pottery.text =  "???" if InventoryManager.total_pottery_ancient == 0 else str(InventoryManager.total_pottery_ancient) + "x Ancient Pottery"
	gold_ring.text =  "???" if InventoryManager.total_ring_gold == 0 else str(InventoryManager.total_ring_gold) + "x Gold Rings"
	jade_ring.text =  "???" if InventoryManager.total_ring_jade == 0 else str(InventoryManager.total_ring_jade) + "x Jade Rings"
	ancient_ring.text =  "???" if InventoryManager.total_ring_ancient == 0 else str(InventoryManager.total_ring_ancient) + "x Ancient Rings"
	topaz_necklace.text =  "???" if InventoryManager.total_necklace_topaz == 0 else str(InventoryManager.total_necklace_topaz) + "x Topaz Necklace"
	gold_necklace.text =  "???" if InventoryManager.total_necklace_gold == 0 else str(InventoryManager.total_necklace_gold) + "x Gold Necklace"
	ruby_necklace.text =  "???" if InventoryManager.total_necklace_ruby == 0 else str(InventoryManager.total_necklace_ruby) + "x Ruby Necklace"
	emerald_necklace.text =  "???" if InventoryManager.total_necklace_emerald == 0 else str(InventoryManager.total_necklace_emerald) + "x Emerald Necklace"
	fossil.text =  "???" if InventoryManager.total_fossil == 0 else str(InventoryManager.total_fossil) + "x Fossils"


func set_dialogues() -> void:
	
	betting_lads.text = "Betting Lads" if WorldManager.completed_betting_lads else "???"
	generous_benefactors.text = "Generous Benefactors" if WorldManager.completed_generous_benefactors else "???"
	groom_to_be.text = "Groom-To-Be" if WorldManager.completed_groom_to_be else "???"
	lost_necklace.text = "Lost Necklace" if WorldManager.completed_lost_necklace else "???"
	prospective_professor.text = "Prospective Professor" if WorldManager.completed_prospective_professor else "???"
	seaglass_collector.text = "Seaglass Collector" if WorldManager.completed_seaglass_collector else "???"
	the_sea_captain.text = "The Sea Captain" if WorldManager.completed_the_sea_captain else "???"
	the_pppp.text = "The PPPP" if WorldManager.completed_the_pppp else "???"
	the_fisher_king.text = "The Fisher King" if WorldManager.completed_the_fisher_king else "???"
	a_ghost_maybe.text = "A Ghost Maybe?" if WorldManager.completed_a_ghost_maybe else "???"





func move_in() -> void:
	var _tween:Tween = create_tween()
	_tween.tween_property(self,"modulate",Color.WHITE,1.0)
	await get_tree().create_timer(2.0).timeout
	leave.disabled = false
	leave.modulate = Color.WHITE

func on_button_clicked()-> void:
	
	leave.disabled = true
	leave.modulate = Color(Color.WHITE,0)
	
	var _tween:Tween = create_tween()
	_tween.tween_property(self,"modulate",Color(Color.WHITE,0),1.0)
	await get_tree().create_timer(1.1).timeout
	
	WorldManager.restart_scene().emit()
	get_tree().call_deferred("reload_current_scene") # .reload_current_scene.call_deferred() # .call_deferred("reload_current_scene")
	
