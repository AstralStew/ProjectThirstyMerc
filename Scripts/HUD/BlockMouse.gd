class_name BlockMouse extends Area2D


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		PlayerCharacter.instance.get_viewport().set_input_as_handled()
		get_viewport().set_input_as_handled()
