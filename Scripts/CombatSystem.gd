extends Node2D

class_name CombatSystem

@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var weapon_sprite = $WeaponSprite
@onready var collision_shape_2d = $WeaponSprite/Area2D/CollisionShape2D

@export var weapon: Resource 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if Input.is_action_just_pressed("attack"):
		animated_sprite_2d.play_attack_animation()
		var attack_direction = animated_sprite_2d.attack_direction
		var attack_data = weapon.get_data_for_direction(attack_direction)
		
		collision_shape_2d.shape = weapon.collision_shape
		weapon_sprite.position = attack_data.get('attachment_position') 
		weapon_sprite.rotation_degrees = attack_data.get('rotation')
		weapon_sprite.z_index = attack_data.get('z_index')
		weapon_sprite.show()


func _on_animated_sprite_2d_attack_animation_finished():
	weapon_sprite.hide()
