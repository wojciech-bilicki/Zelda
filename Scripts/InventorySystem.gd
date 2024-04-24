extends Node

class_name Inventory

@onready var player_ui = $"../PlayerUI"

@export var size = 8
@export var items: Array[InventoryItem] = []

func _input(event):
	if Input.is_action_just_pressed("toggle_inventory"):
		player_ui.toggle()


func add_item(item: InventoryItem, stacks: int):
	#item is stackable
	if stacks && item.max_stacks:
	# is item already in inventory
	# we have to reverse search
		var item_index = -1
		for i in items.size():
			if items[i].name == item.name:
				item_index = i
				
	
		if item_index != -1:
			#item is in inventory
			#get the item from inventory
			var inventory_item = items[item_index]
			#can we add current stack to item in the inventory
			if inventory_item.stacks + stacks <= item.max_stacks:
				inventory_item.stacks += stacks
				items[item_index] = inventory_item
			else:
				var stacks_diff = inventory_item.stacks + stacks - item.max_stacks
				var additional_inventory_item = inventory_item.duplicate(true)
				inventory_item.stacks = item.max_stacks
				additional_inventory_item.stacks = stacks_diff
				items.append(additional_inventory_item)
		else:
			item.stacks = stacks
			items.append(item)	
			
			#
	else:
		items.append(item)
		player_ui.add_item(item)
	
