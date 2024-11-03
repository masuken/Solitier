extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_button_pressed() -> void:
	animation_player.play("card_flip")
	
