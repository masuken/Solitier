extends Area2D


@onready var front: Sprite2D = $front
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var back: Sprite2D = $front/back


var mouse_position = Vector2()

var dragging :bool = false
var faceup: bool = false

var suit:String
var value:int
var path:String


var origin_position = null
var offset = Vector2.ZERO
var yOffset = 70

	
func _ready():
	pass

func load_cardface(path):
	front.texture = load(path)

func _process(delta):
	if dragging:
		z_index = 1
		var mousePos = get_global_mouse_position()
		global_position.x = mousePos.x + offset.x
		global_position.y = mousePos.y + offset.y
		
	else:
		z_index = 0
		if origin_position != null:
			position = lerp(position, origin_position, 10*delta)
		
	
	if Input.is_action_just_released("ui_left_mouse"):
		if dragging:
			#print("リリース")
			dragging = false


func _on_button_pressed() -> void:
	if faceup == false:
		
		#子供がいればリターン
		var children: Array = self.get_children()
		for child in children:
			if child.is_in_group("card"):
				return
		
		faceup = true
		animation_player.play("card_flip")
		
	else:
		dragging = true
		#front.z_index = 1
		var mousePos = get_global_mouse_position()
		offset.x = global_position.x - mousePos.x
		offset.y = global_position.y - mousePos.y
		

func _on_area_entered(area: Area2D) -> void:
	#print("jjj")
	call_deferred("_on_area_entered_deferred", area)


func _on_area_entered_deferred(area: Area2D):
	
	if dragging:
	
		#トップパネルに当たった
		if area.is_in_group("top"):
			
			#子にカードがあればスルー
			var stack_cards: Array = area.get_children()
			for child in stack_cards: #stack_card -> child
				if child.is_in_group("top"):
					return
			
			#自分に子があればスルー
			var child_cards: Array = self.get_children()
			for child in child_cards:
				if child.is_in_group("card"):
					return
		
			#スタックチェック
			facechecker_top(area)
		
		
		elif area.is_in_group("card"):
			#親と同一カードならスルー
			if area == self.get_parent():
				return
			
			#当たった相手が子以下である
			for child in get_all_children_while(self):
				if area == child:
					return
			
			#当たった相手が裏面
			if area.faceup == false:
				return
			
			#相手に子のカードがあればスルー
			var children: Array = area.get_children()
			for child in children:
				if child.is_in_group("card"):
					return
			
			#スタックチェック
			facechecker_card(area)
		
		
		elif area.is_in_group("bottom"):
			#子にカードがあればスルー
			var stack_cards: Array = area.get_children()
			for stack_card in stack_cards:
				if stack_card.is_in_group("card"):
					return
			
			#スタックチェック
			facechecker_bottom(area)
			
		elif area.is_in_group("trip"):
			#print("can't stack to trip")
			pass
			
			
	
func facechecker_card(area):
	
	if self.value != area.value - 1:
		return
		
	if self.suit == "C":
		if area.suit == "C":
			return
		if area.suit == "S":
			return
			
	if self.suit == "D":
		if area.suit == "D":
			return
		if area.suit == "H":
			return
			
	if self.suit == "H":
		if area.suit == "H":
			return
		if area.suit == "D":
			return
			
	if self.suit == "S":
		if area.suit == "S":
			return
		if area.suit == "C":
			return
	
	group_to_card(self)
	#dragging = false
	call_deferred("reparent", area)
	origin_position = Vector2(0,yOffset)
	

func facechecker_top(area):
	
	var is_panel:bool
	var parent = area.get_parent()
	if parent.is_in_group("top"):
		is_panel = false
	else:
		is_panel = true
	
	#トップパネルである
	if is_panel:
		if self.value != 1:
			return
			
	#トップパネルではない
	else:
		if self.value != area.value + 1:
			return
		if self.suit != area.suit:
			return
			
	group_to_top(self)
	#dragging = false
	call_deferred("reparent", area)
	origin_position = Vector2(0,0)
	

func facechecker_bottom(area):
	if self.value != 13:
		return
	
	group_to_card(self)
		
	call_deferred("reparent", area)
	#dragging = false
	origin_position = Vector2(0,0)
	

func group_to_top(area):
	area.remove_from_group("card")
	area.remove_from_group("trip")
	area.add_to_group("top")


func group_to_card(area):
	area.remove_from_group("top")
	area.remove_from_group("trip")
	area.add_to_group("card")
	

func get_all_children_while(in_node):
	var waiting = in_node.get_children()
	var ary:Array = []
	while not waiting.is_empty():
		var node = waiting.pop_back()
		waiting.append_array(node.get_children())
		ary.append(node)
	return ary


