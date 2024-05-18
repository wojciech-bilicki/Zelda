extends Node2D

class_name CombatSystem

@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var right_hand_weapon_sprite = $RightHandWeaponSprite
@onready var right_hand_collision_shape_2d = $RightHandWeaponSprite/Area2D/CollisionShape2D
@onready var left_hand_weapon_sprite = $LeftHandWeaponSprite

@onready var left_hand_collision_shape_2d = $LeftHandWeaponSprite/Area2D/CollisionShape2D


@export var right_weapon: WeaponItem 
@export var left_weapon: WeaponItem

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("attack"):
		animated_sprite_2d.play_attack_animation()
		var attack_direction = animated_sprite_2d.attack_direction
		if right_weapon == null:
			return
		var attack_data = right_weapon.get_data_for_direction(attack_direction)
		
		
		right_hand_weapon_sprite.position = attack_data.get('attachment_position') 
		right_hand_weapon_sprite.rotation_degrees = attack_data.get('rotation')
		right_hand_weapon_sprite.z_index = attack_data.get('z_index')
		right_hand_weapon_sprite.show()
	
	if Input.is_action_just_pressed("block"):
		animated_sprite_2d.play_attack_animation()
		var attack_direction = animated_sprite_2d.attack_direction
		
		if left_weapon == null:
			return

		
		if (attack_direction == "left" or attack_direction == "right") and left_weapon != null and left_weapon.side_in_hand_texture != null :
		
			left_hand_weapon_sprite.texture = left_weapon.side_in_hand_texture
		else:
			left_hand_weapon_sprite.texture = left_weapon.in_hand_texture
	
		var attack_data = left_weapon.get_data_for_direction(attack_direction)
	
		left_hand_weapon_sprite.position = attack_data.get('attachment_position') 
		left_hand_weapon_sprite.rotation_degrees = attack_data.get('rotation')
		left_hand_weapon_sprite.z_index = attack_data.get('z_index')
		left_hand_weapon_sprite.show()
		
func _on_animated_sprite_2d_attack_animation_finished():
	right_hand_weapon_sprite.hide()
	left_hand_weapon_sprite.hide()
	
func set_active_weapon(weapon, slot_to_equip: String):
	
	if slot_to_equip == "Left_Hand":
		if weapon.collision_shape != null:
			left_hand_collision_shape_2d.shape = weapon.collision_shape

		left_hand_weapon_sprite.texture = weapon.in_hand_texture
		left_weapon = weapon
		
	elif slot_to_equip == "Right_Hand":
		if weapon.collision_shape:
			right_hand_collision_shape_2d.shape = weapon.collision_shape
		right_hand_weapon_sprite.texture = weapon.in_hand_texture
		right_weapon = weapon
	
