extends CharacterBody2D

class_name Enemy

@export var speed: float = 100
@export var patrol_path: Array[Vector2] = []
@export var patrol_wait_time = 1.0
@export var damage_to_player = 10

@export var health: int = 50
@export var item_to_drop: InventoryItem

@onready var animated_sprite_2d = $AnimatedSprite2D as EnemyAnimationController
@onready var health_system = $HealthSystem as HealthSystem
@onready var progress_bar = $ProgressBar as ProgressBar


var pickup_item_scene = load("res://Scenes/pick_up_item.tscn") as PackedScene
var current_target: int = 0
var wait_timer: float = 0.0


func _ready():
	health_system.init(health)
	progress_bar.max_value = health
	progress_bar.value = health
	if patrol_path.size() > 0:
		position = patrol_path[0]
	health_system.died.connect(on_died)
	

func apply_damage(damage: int):
	health_system.apply_damage(damage)

func move_along_path(delta: float):
	var target_position = patrol_path[current_target]
	var direction = (target_position - position).normalized()
	var distance_to_target = position.distance_to(target_position)
	
	if distance_to_target > speed * delta:
		animated_sprite_2d.play_movement_animation(direction)
		velocity = direction * speed
		move_and_slide()
	else:
		animated_sprite_2d.play_idle_animation()
		position = target_position
		wait_timer += delta
		if wait_timer >= patrol_wait_time:
			wait_timer = 0.0
			current_target = (current_target + 1) % patrol_path.size()
			


func _physics_process(delta):
	if patrol_path.size() > 1:
		move_along_path(delta)


func on_died():  
	set_physics_process(false)
	animated_sprite_2d.play("died")

func _on_animation_finished():
	if animated_sprite_2d.animation == "died":
		var drop = pickup_item_scene.instantiate() as PickUpItem
		drop.inventory_item = item_to_drop
		drop.stacks = 1
		get_tree().root.add_child(drop)
		drop.global_position = position
		queue_free()
