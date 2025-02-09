extends Area2D

@export var speed: float = 500.0  # Bullet speed
var direction = Vector2.ZERO  # Bullet direction

func _process(delta):
	position += direction * speed * delta  # Move the bullet

func _on_screen_exited():
	queue_free()  # Destroy the bullet when off-screen

#func _on_body_entered(body):
	#if body.is_in_group("enemies"):  # Check if the hit object is an enemy
		#body.queue_free()  # Destroy the enemy
		#queue_free()  # Destroy the bullet
