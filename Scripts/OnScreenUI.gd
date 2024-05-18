
extends CanvasLayer

class_name OnScreenUI

@onready var right_slot = %RightSlot as OnScreenEquipmentSlot
@onready var left_slot = %LeftSlot as OnScreenEquipmentSlot
@onready var potion_slot = %PotionSlot as OnScreenEquipmentSlot

@onready var slots_dictionary = {
	"Right_Hand": right_slot,
	"Left_Hand": left_slot,
	"Potions": potion_slot
}

func equip_item(item: InventoryItem, slot_to_eqiup: String):
	slots_dictionary[slot_to_eqiup].set_equipment_texture(item.texture)
