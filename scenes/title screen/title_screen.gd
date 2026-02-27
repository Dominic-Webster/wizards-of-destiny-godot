extends Control

@onready var background : Sprite2D = $Background
@onready var title = $Title/TitleText
@onready var buttons = $Buttons
@onready var intro_anim = $AnimationPlayer
@onready var shimmer_anim = $Title/AnimationPlayer
@onready var shimmer_timer = $Timer


func _ready():
	randomize()
	
	#Initial States
	background.modulate.a = 0.0
	title.scale = Vector2(0.1, 0.1)
	buttons.modulate.a = 0.0
	buttons.scale = Vector2(0.8, 0.8)
	
	intro_anim.play("intro")
	intro_anim.queue("hover")
	
	# Setup shimmer timer
	shimmer_timer.one_shot = true
	shimmer_timer.start(randf_range(3.0, 6.0))


func _on_PlayButton_pressed():
	print("Play pressed")
	# get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_timer_timeout() -> void:
	shimmer_anim.play("glimmer")
	shimmer_timer.start(randf_range(4.0, 8.0))
