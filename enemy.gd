extends CharacterBody2D

@export var speed: float = 50.0  # Movement speed
@export var bullet_scene: PackedScene  # Reference to the enemy's bullet scene
@export var shoot_interval: float = 2.0  # Time between shots

var shoot_timer: float = 0.0  # Internal timer
var player: Node2D  # Reference to the player node

func _ready():
	# Find the player in the scene
	player = get_parent().get_node("Player")  # Adjust the path if necessary

func _process(delta):
	follow_player(delta)  # Make the enemy follow the player
	shoot_timer += delta
	if shoot_timer >= shoot_interval:
		shoot()
		shoot_timer = 0.0

func follow_player(_delta):
	if player == null:
		return  # No player to follow
		# Calculate direction to the player
	var direction_to_player = (player.position - position).normalized()
	# Set velocity to move toward the player
	velocity = direction_to_player * speed
	move_and_slide()

func shoot():
	if bullet_scene == null:
		print("Enemy bullet scene is not set!")
		return
		
	var bullet = bullet_scene.instantiate()
	bullet.position = position  # Enemy's current position
	bullet.direction = (player.position - position).normalized()  # Shoot toward the player
	get_parent().add_child(bullet)  # Add to the game world


func _on_body_entered(body):
	if body.name == "PlayerBullet":  # Assuming your player's bullet is named PlayerBullet
		queue_free()  # Destroy enemy
		body.queue_free()  # Destroy the bullet
