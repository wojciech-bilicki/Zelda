extends VBoxContainer

class_name InventorySlot

var is_empty = true

@onready var texture_rect = %TextureRect
@onready var label = $Label

func add_item(item: InventoryItem):
	is_empty = false
	texture_rect.texture = item.texture	
	label.text = item.name
