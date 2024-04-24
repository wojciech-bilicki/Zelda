extends CanvasLayer

class_name PlayerUI

@onready var grid_container = %GridContainer
@onready var inventory_slot_scene = preload("res://Scenes/Inventory/inventory_slot.tscn")

@export var size = 8
@export var columns = 4

func _ready():
	grid_container.columns = columns
	for i in size:
		var inventory_slot = inventory_slot_scene.instantiate()
		grid_container.add_child(inventory_slot)

func toggle():
	visible = !visible

func add_item(item: InventoryItem): 
	var slots = grid_container.get_children().filter(func (slot): return slot.is_empty)
	var first_empty_slot = slots.front() as InventorySlot
	first_empty_slot.add_item(item)
	
