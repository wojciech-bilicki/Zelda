
extends CanvasLayer

class_name OnScreenUI

@onready var right_slot = %RightSlot as OnScreenEquipmentSlot
@onready var left_slot = %LeftSlot as OnScreenEquipmentSlot
@onready var potion_slot = %PotionSlot as OnScreenEquipmentSlot
@onready var spell_slot = %SpellSlot as OnScreenEquipmentSlot

@onready var progress_bar = $MarginContainer/ProgressBar


@onready var slots_dictionary = {
	"Right_Hand": right_slot,
	"Left_Hand": left_slot,
	"Potions": potion_slot
}

func equip_item(item: InventoryItem, slot_to_eqiup: String):
	slots_dictionary[slot_to_eqiup].set_equipment_texture(item.texture)

func toggle_spell_slot(is_visible: bool, ui_texture: Texture):
	spell_slot.visible = is_visible
	if is_visible:
		spell_slot.set_equipment_texture(ui_texture)

func spell_cooldown_activated(cooldown: float):
	spell_slot.on_cooldown(cooldown)


func init_health_bar(max_health: int):
	progress_bar.max_value = max_health
	
func apply_damage_to_health_bar(damage: int):
	progress_bar.value -= damage

