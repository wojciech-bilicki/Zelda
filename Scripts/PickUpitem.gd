extends Area2D

class_name PickUpItem

@export var inventory_item: InventoryItem

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@export var stacks: int = 1


func _ready():
	sprite_2d.texture = inventory_item.texture
	collision_shape_2d.shape = inventory_item.ground_collision_shape
