extends AnimatedSprite2D

class_name AnimationController

const MOVEMENT_TO_IDLE = {
	"back_walk": "back_idle",
	"front_walk": "front_idle",
	"right_walk": "right_idle",
	"left_walk": "left_idle"
}

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
