class_name ToolType extends Resource

enum Utility{NONE,DIGGER,SCANNER}

@export var name: String = ""
@export var description: String = ""
@export var cost: int = 0
@export var prefab: PackedScene = null
@export var utility: Utility = Utility.NONE
