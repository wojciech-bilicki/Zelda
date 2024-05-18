extends VBoxContainer

class_name OnScreenEquipmentSlot

@onready var slot_label = $SlotLabel
@onready var texture_rect = %TextureRect

@export var slot_name: String

func _ready():
	slot_label.text = slot_name
	
func set_equipment_texture(texture: Texture):
	texture_rect.texture = texture
	
