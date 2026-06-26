class_name EndDayScene extends Control
const DEBUG_NAME : String = "[b][EndDayUI][/b] "

@onready var gfx: Control = $Gfx
@onready var crickets: AudioStreamPlayer = $Crickets
@onready var book: MarginContainer = $Gfx/MarginContainer/VBoxContainer/Book


### ITEMS

@onready var coins: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/Coins
@onready var bottlecaps: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/Bottlecaps
@onready var pull_tabs: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/PullTabs
@onready var old_cans: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/OldCans
@onready var broken_lures: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/BrokenLures
@onready var cyan_seaglass: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/CyanSeaglass
@onready var red_seaglass: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/RedSeaglass
@onready var dark_seaglass: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/DarkSeaglass
@onready var vibrant_seaglass: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/VibrantSeaglass
@onready var shark_tooth: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/SharkTooth
@onready var clay_pottery: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/ClayPottery
@onready var jade_pottery: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/JadePottery
@onready var pristine_pottery: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/PristinePottery
@onready var ancient_pottery: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/AncientPottery
@onready var gold_ring: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/GoldRing
@onready var jade_ring: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/JadeRing
@onready var ancient_ring: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/AncientRing
@onready var topaz_necklace: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/TopazNecklace
@onready var gold_necklace: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/GoldNecklace
@onready var ruby_necklace: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/RubyNecklace
@onready var emerald_necklace: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/EmeraldNecklace
@onready var fossil: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/LeftPanel/Border/LeftPage/ItemsFound/Fossil

### BEACHGOERS

@onready var betting_lads: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/BettingLads
@onready var generous_benefactors: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/GenerousBenefactors
@onready var groom_to_be: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/GroomToBe
@onready var lost_necklace: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/LostNecklace
@onready var prospective_professor: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/ProspectiveProfessor
@onready var seaglass_collector: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/SeaglassCollector
@onready var the_sea_captain: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/TheSeaCaptain
@onready var the_pppp: RichTextLabel = $"Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/The PPPP"
@onready var the_fisher_king: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/TheFisherKing
@onready var a_ghost_maybe: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/BeachgoersHelped/AGhostMaybe


### ALLOWANCE

@onready var dosh_earned: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/Allowance/DoshEarned
@onready var dosh_spent: RichTextLabel = $Gfx/MarginContainer/VBoxContainer/Book/HBoxContainer/RightPanel/Border/RightPage/Allowance/DoshSpent


@onready var leave: Button = $Gfx/MarginContainer/VBoxContainer/Leave

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
	#ScreenBars.activate(0,1)
	await get_tree().create_timer(1).timeout
	var _tween:Tween = create_tween().set_parallel()
	_tween.tween_property(crickets,"volume_linear",0.75,2)
	_tween.tween_callback(ScreenBars.activate.bind(0,1))
	_tween.tween_property(book,"offset_transform_position_ratio",Vector2(0,0),1.25).set_delay(1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween.tween_property(book,"offset_transform_rotation",deg_to_rad(0),1.25).set_delay(1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	await get_tree().create_timer(2.0).timeout
	leave.disabled = false
	leave.modulate = Color.WHITE

func on_button_clicked()-> void:
	
	leave.disabled = true
	leave.modulate = Color(Color.WHITE,0)
	AudioManager.play_sound(AudioManager.UI_POP_UP,1,1.25)
	
	var _tween:Tween = create_tween().set_parallel()
	_tween.tween_property(crickets,"volume_linear",0,1)
	_tween.tween_property(book,"offset_transform_position_ratio",Vector2(1,0.5),1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	_tween.tween_property(book,"offset_transform_rotation",deg_to_rad(15),1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	_tween.tween_callback(ScreenBars.activate.bind(1,1)).set_delay(0.5)
	
	
	#var _tween:Tween = create_tween()
	#_tween.tween_property(Screen,"modulate",Color(Color.WHITE,0),1.0)
	#ScreenBars.activate(1,1)
	await get_tree().create_timer(1.5).timeout
	
	Main.change_current_scene(Main.Scene.GAME)
