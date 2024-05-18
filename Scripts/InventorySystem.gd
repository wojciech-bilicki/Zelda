extends Node

class_name Inventory

@onready var player_ui = $"../PlayerUI" as PlayerUI
@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var on_screen_ui = $"../OnScreenUI" as OnScreenUI

@onready var combat_system = $"../CombatSystem" as CombatSystem

@onready var item_scene = preload("res://Scenes/pick_up_item.tscn")

@export var size = 8
@export var items: Array[InventoryItem] = []

var selected_spell_index = null

var taken_inventory_slots_count = 0

var is_full:
	get: 
		return taken_inventory_slots_count == size

func _ready():
	randomize()
	player_ui.drop_item_on_the_ground.connect(drop_item)
	player_ui.equip_item.connect(on_item_equiped)
	player_ui.spell_slot_clicked.connect(spell_slot_clicked)

func _input(event):
	if Input.is_action_just_pressed("toggle_inventory"):
		player_ui.toggle()


func add_item(item: InventoryItem, stacks: int):
	#item is stackable
	if stacks && item.max_stacks != 0:
		add_the_stackable_item_to_inventory(item, stacks)
	#add stackable item to the inventory
			
	else:
		var idx = items.find(null)
		if idx != -1:
			items[idx] = item
		else:
			items.append(item)
		player_ui.add_item(item)
	taken_inventory_slots_count += 1
	
func drop_item(idx: int):
	
	taken_inventory_slots_count -= 1
	player_ui.clear_slot_at_index(idx)
	eject_item_into_the_ground(idx)
	
	
func add_the_stackable_item_to_inventory(item: InventoryItem, stacks: int):
		# is item already in inventory
	# we have to reverse search
		var item_index = -1
		for i in items.size():
			
			if items[i] != null and items[i].name == item.name:
				item_index = i
				
		if item_index != -1:
			#item is in inventory
			#get the item from inventory
			var inventory_item = items[item_index]
			#can we add current stack to item in the inventory
			if inventory_item.stacks + stacks <= item.max_stacks:
				inventory_item.stacks += stacks
				items[item_index] = inventory_item
				player_ui.update_stack_at_slot_index(inventory_item.stacks, item_index)
			else:
				var stacks_diff = inventory_item.stacks + stacks - item.max_stacks
				var additional_inventory_item = inventory_item.duplicate(true)
				inventory_item.stacks = item.max_stacks
				player_ui.update_stack_at_slot_index(inventory_item.max_stacks, item_index)
				additional_inventory_item.stacks = stacks_diff
				items.append(additional_inventory_item)
				player_ui.add_item(additional_inventory_item)
		else:
			item.stacks = stacks
			items.append(item)	
			player_ui.add_item(item)

func on_item_equiped(idx: int, slot_to_equip: String):
	print_debug("ON ITEM EQUIPPED")
	var item_to_equip = items[idx]
	on_screen_ui.equip_item(item_to_equip, slot_to_equip)
	combat_system.set_active_weapon(item_to_equip.weapon_item, slot_to_equip)
	
	check_magic_ui_visibility()
	

func eject_item_into_the_ground(idx: int):
	var inventory_item_to_eject = items[idx]
	var item_to_eject = item_scene.instantiate() as PickUpItem
	item_to_eject.inventory_item = inventory_item_to_eject
	item_to_eject.stacks = inventory_item_to_eject.stacks
	get_tree().root.add_child(item_to_eject)
	item_to_eject.disable_collision()
	item_to_eject.global_position = get_parent().global_position
	
	var drop_direction_vector = animated_sprite_2d.item_drop_direction
	if drop_direction_vector.x == 0:
		drop_direction_vector.x = randf_range(-1, 1)
	else:
		drop_direction_vector.y = randf_range(-1, 1)
		
	var drop_position = get_parent().global_position + Vector2(20,20) * drop_direction_vector
	
	var ejection_tween = get_tree().create_tween()
	ejection_tween.set_trans(Tween.TRANS_BOUNCE)
	ejection_tween.tween_property(item_to_eject, "global_position", drop_position , .2)
	ejection_tween.finished.connect(func(): item_to_eject.enable_collision())
	
	if combat_system.right_weapon == inventory_item_to_eject.weapon_item:
		combat_system.right_weapon = null
		on_screen_ui.right_slot.set_equipment_texture(null)
	if combat_system.left_weapon == inventory_item_to_eject.weapon_item:
		combat_system.left_weapon = null
		on_screen_ui.left_slot.set_equipment_texture(null)
	check_magic_ui_visibility()
		
	items[idx] = null	
	
	

func spell_slot_clicked(idx: int):
	selected_spell_index = idx
	player_ui.set_selected_spell_slot(selected_spell_index)

func check_magic_ui_visibility():
	var should_show_magic_ui = (combat_system.left_weapon != null and combat_system.left_weapon.attack_type == "Magic") or (combat_system.right_weapon != null and combat_system.right_weapon.attack_type == "Magic")
	player_ui.toggle_spells_ui(should_show_magic_ui) 
