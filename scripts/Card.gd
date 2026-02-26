extends Panel

signal card_clicked

@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var lerp_speed: float = 10.0
@export var tilt_amount: float = .15

var is_hovered: bool = false
var target_scale: Vector2 = Vector2.ONE
var target_rotation: float = 0.0

func _ready():
	# Ensure the pivot is centered for the tilt effect
	pivot_offset = size / 2
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exit", _on_mouse_exited)

func _process(delta):
	# Smoothly interpolate scale
	scale = scale.lerp(target_scale, delta * lerp_speed)
	
	# Smoothly interpolate rotation
	rotation = lerp_angle(rotation, target_rotation, delta * lerp_speed)
	
	if is_hovered:
		handle_tilt()
	else:
		target_rotation = 0.0
		target_scale = Vector2.ONE

func handle_tilt():
	# Get mouse position relative to the center of the card
	var mouse_pos = get_local_mouse_position()
	var center = size / 2
	var offset = (mouse_pos - center) / center
	
	# Balatro cards tilt slightly on the Z-axis (simulated here via rotation)
	# and move slightly opposite to the mouse pointer
	target_rotation = (offset.x / center.x) * tilt_amount

func _on_mouse_entered():
	is_hovered = true
	target_scale = hover_scale
	z_index = 10 # Pop to the front
	
func _on_mouse_exited():
	is_hovered = false
	# Resets
	target_scale = Vector2.ONE
	target_rotation = 0.0
	z_index = 0

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Play a "punchy" click effect
			scale *= 0.9 
			card_clicked.emit()
	
