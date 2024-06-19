extends Area2D


func _on_body_entered(body):
	TransitionChangeManager.change_scene("res://Scenes/shop_scene.tscn")
