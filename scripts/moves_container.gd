extends Node

func reorder_move(card: Control, global_mouse_pos: Vector2):
	var hbox = $HBoxContainer
	for i in hbox.get_child_count():
		var child = hbox.get_child(i)
		if global_mouse_pos.x < child.global_position.x + (child.size.x / 2):
			hbox.move_child(card, i)
			return
	# If past the last card, move to the end
	hbox.move_child(card, -1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
