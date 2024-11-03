extends Node2D

@export var card_node: PackedScene
@export var cardFaces:Array[Texture2D]

@onready var spawner: Area2D = $Spawner

@export var bottomArea0:Area2D
@export var bottomArea1:Area2D
@export var bottomArea2:Area2D
@export var bottomArea3:Area2D
@export var bottomArea4:Area2D
@export var bottomArea5:Area2D
@export var bottomArea6:Area2D
var bottomAreas:Array[Area2D]

var bottom0:Array[Dictionary]#var bottom0:Array[String]
var bottom1:Array[Dictionary]
var bottom2:Array[Dictionary]
var bottom3:Array[Dictionary]
var bottom4:Array[Dictionary]
var bottom5:Array[Dictionary]
var bottom6:Array[Dictionary]
var bottomList:Array[Array]

"""
var deck:Array[Array]
var arr = ["neruma",4,"aaaaa"]
var dict = {"suit":"C","value":3,"arr":arr}
"""

var deck:Array[Dictionary]
var suits:Array[String] = ["C", "D", "H", "S"]
var values:Array[int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
#var values:Array[String] = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

var yOffset = 70


func _ready() -> void:
	bottomList = [bottom0, bottom1, bottom2, bottom3, bottom4, bottom5, bottom6]
	bottomAreas = [bottomArea0, bottomArea1, bottomArea2, bottomArea3, bottomArea4, bottomArea5, bottomArea6]
	GenerateDeck()
	SolitaireSort()
	SolitaireDeal()
	

func GenerateDeck():
	var count = 0
	
	for suit in suits:
		for value in values:
			var path
			if cardFaces[count]:
				path = cardFaces[count].resource_path
			#else:
			#	path = "res://PNG-cards-1.3/2_of_clubs.png"
			
			deck.append({"suit":suit,"value":value,"path":path})
			count += 1
	
	randomize()
	deck.shuffle()
	

func SolitaireSort():
	for i in range(0,7):
		for j in range(i,7):
			#print(j)
			#var last:Dictionary = deck.pop_back()
			var last:Dictionary = deck.pop_front()
			bottomList[j].append(last)
	
	#残りのデックはスポウナーに
	#for i in 19:
	#	deck.pop_back()
	spawner.remaining_cards = deck

func SolitaireDeal():
	
	var top_cards:Array
	
	for i in range(0,7):
		
		var CardParent = null
		var size = bottomList[i].size()
		var count = 0
		
		for dict in bottomList[i]:
				
			var card = card_node.instantiate()
			card.suit = dict["suit"]
			card.value = dict["value"]
			card.path = dict["path"]
			card.call_deferred("load_cardface", card.path)
			card.add_to_group("card")
			
			count += 1
			if count == size:
				top_cards.push_back(card)

			
			if CardParent == null:
					bottomAreas[i].add_child(card)
					card.position = Vector2(0, 0)
			else:
					CardParent.add_child(card)
					card.position = Vector2(0, yOffset)
			
			CardParent = card
			card.origin_position = card.position
		
	flip_top_cards(top_cards)
	
	
	
func flip_top_cards(array):
	
	for card in array:
		var timer = self.get_tree().create_timer(0.2)
		await timer.timeout
		card.faceup = true
		card.animation_player.play("card_flip")
	
	
