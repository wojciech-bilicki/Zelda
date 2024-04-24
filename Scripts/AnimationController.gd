extends AnimatedSprite2D

class_name AnimationController

signal attack_animation_finished

const MOVEMENT_TO_IDLE = {
	"back_walk": "back_idle",
	"front_walk": "front_idle",
	"right_walk": "right_idle",
	"left_walk": "left_idle"
}


const DIRECTION_TO_ATTACK_ANIMATION = {
	"back": "back_attack",
	"front": "front_attack",
	"right": "right_attack",
	"left": "left_attack"
}

var attack_direction = null

func play_movement_animation(velocity: Vector2):
	if velocity.x > 0:
		play("right_walk")
	elif velocity.x < 0:
		play("left_walk")
	
	if velocity.y > 0:
		play("front_walk")
	elif velocity.y < 0: 
		play("back_walk")

func play_idle_animation():
	if MOVEMENT_TO_IDLE.keys().has(animation):
		play(MOVEMENT_TO_IDLE[animation])


func play_attack_animation():
	var direction = animation.split("_")[0]
	attack_direction = direction
	play(DIRECTION_TO_ATTACK_ANIMATION[direction])
	

func _on_animation_finished():
	# Attack animation just finished let's go back to idle animation
	if DIRECTION_TO_ATTACK_ANIMATION.values().has(animation):
		var animation_string = String(animation)
		var direction = DIRECTION_TO_ATTACK_ANIMATION.find_key(animation_string)

		play(direction + "_idle")
		attack_direction = null
		print('finished')
		attack_animation_finished.emit()
