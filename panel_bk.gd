extends Panel

var id 
var data 

#signal drag_completed(data)
signal played_card(id)

func _ready():
	connect("played_card", yobidashi)
	data = {}
	


	

func _can_drop_data(_pos, data):
	#return data["texture"] is Texture2D
	#texture = data["texture"]
	#print("go")
	return true
	
func _drop_data(_pos, data):
	pass
	
	
func yobidashi(card_id):
	print(card_id)

