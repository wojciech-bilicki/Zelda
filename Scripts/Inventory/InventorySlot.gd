extends VBoxContainer

class_name InventorySlot

signal drop_item
signal equip_item
signal slot_clicked

var is_empty = true
var is_selected = false


@export var single_button_press = false
@export var starting_texture: Texture
@export var starting_label: String

@onready var texture_rect = %TextureRect
@onready var label = $Label
@onready var stacks_label = $NinePatchRect/StacksLabel
@onready var menu_button = $NinePatchRect/MenuButton as MenuButton
@onready var on_click_button = $NinePatchRect/OnClickButton

var slot_to_equip = "NotEquipable"

func _ready():
	
	if starting_texture != null:
		texture_rect.texture = starting_texture
	
	if starting_label != null:
		label.text = starting_label
	
	menu_button.disabled = single_button_press
	on_click_button.disabled = !single_button_press
	
	on_click_button.visible = single_button_press
	var popup_menu = menu_button.get_popup() as PopupMenu
	popup_menu.id_pressed.connect(on_popup_menu_item_pressed)

func add_item(item: InventoryItem):
	if item.slot_type != "NotEquipable": 	
		var popup_menu = menu_button.get_popup() as PopupMenu
		var equip_slot_name_array = item.slot_type.to_lower().split("_")
		var equip_slot_name = " ".join(equip_slot_name_array)
		
		slot_to_equip = item.slot_type
		popup_menu.set_item_text(0, "Equip to " + equip_slot_name)
	
	is_empty = false
	menu_button.disabled = false
	texture_rect.texture = item.texture	
	label.text = item.name
	if item.stacks == 0 or item.stacks == 1:
		return
	stacks_label.text = str(item.stacks)

func on_popup_menu_item_pressed(id:int):
	
	var pressed_menu_item = menu_button.get_popup().get_item_text(id)
	if pressed_menu_item == "Drop":
		drop_item.emit()
		menu_button.disabled = true
	elif pressed_menu_item.contains("Equip") && slot_to_equip != "Not_Equipable":
		equip_item.emit(slot_to_equip)
		
		
func _on_on_click_button_pressed():
	
	slot_clicked.emit()

func toggle_button_selected_variation(is_selected: bool):
	on_click_button.theme_type_variation = "selected" if is_selected else ""
