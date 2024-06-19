extends Area2D

class_name Spell

@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var direction: Vector2
var speed: float
var damage: int

func init(config: SpellConfig):
	collision_shape_2d.shape = config.collision_shape
	damage = config.damage
	name = config.spell_name
	speed = config.speed
	animated_sprite_2d.play(config.spell_name)

	
func _process(delta):
	position += speed * delta * direction



func _on_area_entered(area):
	if area.get_parent() is Enemy:
		(area.get_parent() as Enemy).apply_damage(damage)
		queue_free()
