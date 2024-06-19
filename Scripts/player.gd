extends CharacterBody2D
class_name Player

const SPEED = 100.0


@export var health = 100


@onready var animated_sprite_2d = $AnimatedSprite2D as AnimationController
@onready var inventory = $Inventory
@onready var health_system = $HealthSystem as HealthSystem
@onready var combat_system = $CombatSystem
@onready var on_screen_ui = $OnScreenUI

@onready var notification_label = $NotificationLabel




func _ready():
	health_system.init(health)
	health_system.died.connect(on_player_dead)
	health_system.damage_taken.connect(on_damage_taken)
	on_screen_ui.init_health_bar(health)


func _physics_process(delta):
	if animated_sprite_2d.animation.contains("attack"):
		return 
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if velocity != Vector2.ZERO:
		animated_sprite_2d.play_movement_animation(velocity)
	else: 
		animated_sprite_2d.play_idle_animation()
		
	move_and_slide()
		
func _on_area_2d_area_entered(area: Area2D):
	
	if area is PickUpItem:
		if !inventory.is_full:
			inventory.add_item(area.inventory_item, area.stacks)
			area.queue_free()
		else:
			notification_label.show()
			area.shake()
			await get_tree().create_timer(1.5).timeout
			notification_label.hide()
	if area.get_parent() is Enemy:
		var damage_to_player = (area.get_parent() as Enemy).damage_to_player
		health_system.apply_damage(damage_to_player)

func on_player_dead():
	combat_system.set_process_input(false)
	set_physics_process(false)
	animated_sprite_2d.play("dead")
	
func on_damage_taken(damage: int):
	on_screen_ui.apply_damage_to_health_bar(damage)
