extends Area2D

@export var group_name:String


func _ready() -> void:
	self.add_to_group(group_name)
