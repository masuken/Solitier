extends TextureRect

#@export var card_node: PackedScene
var id 
var data 

#signal drag_completed(data)
signal played_card(id)

func _ready():
	connect("played_card", yobidashi)
	data = {}
	if texture != null:
		id = RandomNumberGenerator.new()
		

func _get_drag_data(at_position):
	#var data = {}
	data["texture"] = texture
	data["id"] = id
	
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.modulate.a = .5
	preview_texture.size = Vector2(200,290)
	
	#var c = Control.new()
	#c.add_child(preview_texture)
	#set_drag_preview(c)
	set_drag_preview(preview_texture)
	
	texture = null
	id = null
	
	return data
	

func _can_drop_data(_pos, data):
	#return data["texture"] is Texture2D
	#texture = data["texture"]
	#print("go")
	return true
	
func _drop_data(_pos, data):
	#print("owari")
	
	#texture = data
	
	#if data["id"] == id:
	#	queue_free()
	emit_signal("played_card", data["id"])
	texture = data["texture"]
	id = data["id"]
	
func yobidashi(card_id):
	print(card_id)
		

#func _on_tree_exiting()->void:
#	drag_completed.emit(self)
	
#func _unhandled_input(event):
#	if event.is_action_released("ui_left_mouse"):
#		print("release")
