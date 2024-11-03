extends Area2D

@export var card_node: PackedScene
var remaining_cards:Array[Dictionary]#@onready
var slot1:Array
var slot2:Array[Dictionary]



func _on_button_pressed() -> void:
	
	delete_and_push_cards()
	
	var xOffset = 60
	var xPos = 0
	
	for i in range(0,3):
		
		if remaining_cards.size() != 0:
			#print(remaining_cards.size())
			xPos += xOffset
			
			var card = card_node.instantiate()
			self.add_child(card)
			card.add_to_group("trip")
			card.back.z_index = -1
			card.faceup = true
			card.position = Vector2(0, 0)
			card.origin_position = Vector2(300 + xPos, 0)
			
			var dict = remaining_cards.pop_back()
			card.suit = dict["suit"]
			card.value = dict["value"]
			card.path = dict["path"]
			card.call_deferred("load_cardface", card.path)
			
			slot1.push_front(card)
	
		else:
			#print("もうないのでブレイク")
			break
			
	
	#print("----slot1のサイズは-----")
	#print(slot1.size())


func delete_and_push_cards():
	
	#slot1のサイズが2や１のときもOK
	for i in range(0, slot1.size()):
		#print("slot1 -> slot2")
		
		var card = slot1.pop_back()
		
		if card.is_in_group("trip"):
			var dict:Dictionary = {"suit":card.suit,"value":card.value,"path":card.path}
			slot2.push_front(dict)
			card.queue_free()
	
	if remaining_cards.size() == 0:
		backto_remaining_cards()
	

func backto_remaining_cards():
	for i in range(0, slot2.size()):
		var dict = slot2.pop_back()
		remaining_cards.push_front(dict)
	

