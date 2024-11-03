extends Area2D



func _physics_process(delta):
	var velocity = Vector2.ZERO
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 25
	position.x += velocity.x
	position.y += velocity.y



func _on_area_entered(area: Area2D) -> void:
	#if area.is_in_group("card"):
	#print("collide card")
	print("　　GIconから　　" + str(area))
	#if area.owner.get_parent() != self:
		#if self.get_parent() != area.owner:
	#	area.owner.reparent(self)
			
