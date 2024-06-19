extends Node2D

class_name CombatSystem

@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var right_hand_weapon_sprite = $RightHandWeaponSprite
@onready var right_hand_collision_shape_2d = $RightHandWeaponSprite/Area2D/CollisionShape2D
@onready var left_hand_weapon_sprite = $LeftHandWeaponSprite

@onready var left_hand_collision_shape_2d = $LeftHandWeaponSprite/Area2D/CollisionShape2D

@onready var spell_system = $"../SpellSystem"

@export var right_weapon: WeaponItem 
@export var left_weapon: WeaponItem


var can_attack = true
# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.attack_animation_finished.connect(on_attack_animation_finished)

func _input(event):
	
	#prevent_spamming_the_attack_button
	
	if Input.is_action_just_pressed("right_hand_action"):
		if !can_attack:
			return
		can_attack = false
		animated_sprite_2d.play_attack_animation()
		var attack_direction = animated_sprite_2d.attack_direction
		if right_weapon == null:
			return
		var attack_data = right_weapon.get_data_for_direction(attack_direction)
		right_hand_collision_shape_2d.disabled = false
		
		right_hand_weapon_sprite.position = attack_data.get('attachment_position') 
		right_hand_weapon_sprite.rotation_degrees = attack_data.get('rotation')
		right_hand_weapon_sprite.z_index = attack_data.get('z_index')
		right_hand_weapon_sprite.show()
	
	if Input.is_action_just_pressed("left_hand_action"):
		if !can_attack:
			return
		can_attack = false
		animated_sprite_2d.play_attack_animation()
		var attack_direction = animated_sprite_2d.attack_direction
		
		if left_weapon == null:
			return

		
		left_hand_collision_shape_2d.disabled = false
		if (attack_direction == "left" or attack_direction == "right") and left_weapon != null and left_weapon.side_in_hand_texture != null :
		
			left_hand_weapon_sprite.texture = left_weapon.side_in_hand_texture
		else:
			left_hand_weapon_sprite.texture = left_weapon.in_hand_texture
	
		var attack_data = left_weapon.get_data_for_direction(attack_direction)
	
		left_hand_weapon_sprite.position = attack_data.get('attachment_position') 
		left_hand_weapon_sprite.rotation_degrees = attack_data.get('rotation')
		left_hand_weapon_sprite.z_index = attack_data.get('z_index')
		left_hand_weapon_sprite.show()
		
		if left_weapon.attack_type == "Magic":
			spell_system.cast_spell()
		
func _on_animated_sprite_2d_attack_animation_finished():
	right_hand_weapon_sprite.hide()
	left_hand_weapon_sprite.hide()
	left_hand_collision_shape_2d.disabled = true
	right_hand_collision_shape_2d.disabled = true
	
	
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
	
func _on_area_2d_body_entered(body, hand_type):
	if body.has_node("HealthSystem"):
		if hand_type == "right":
			(body.find_child("HealthSystem") as HealthSystem).apply_damage(right_weapon.damage)

func on_attack_animation_finished():
	can_attack = true
	
