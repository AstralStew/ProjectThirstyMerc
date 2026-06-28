class_name DialogueSettings extends Resource

@export var name : String = ""

@export var npc_default_text : String = ""
@export var npc_complete_text : String = ""

@export var requirements : Dictionary[CollectableType,int]

@export var player_has_requirements_text : String = ""
@export var player_leave_incomplete_text : String = ""
@export var player_leave_complete_text : String = ""

@export var is_completed: bool = false

@export var reward: int = 0

signal complete

func complete_dialogue() -> void:
	is_completed = true
	WorldManager.complete_dialogue(self)
	complete.emit()
	#
	#if reward > 0:
		#InventoryManager.add_dosh(reward)
