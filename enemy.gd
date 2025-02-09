extends CharacterBody2D

@export var speed: float = 50.0  # Movement speed
@export var bullet_scene: PackedScene  # Reference to the enemy's bullet scene
@export var shoot_interval: float = 2.0  # Time between shots
#@export var lives: int = 3  # Enemy starts with 3 lives
var hit_count: int = 0  # Tracks how many times the enemy has been hit
var hud: CanvasLayer  # Reference to the HUD
var shoot_timer: float = 0.0  # Internal timer
var player: Node2D  # Reference to the player node
var muzzle: Marker2D  # Reference to the enemy's firing point

func _ready():
	# Find the player in the scene
	player = get_parent().get_node("Player")  # Adjust the path if necessary
	muzzle = $Muzzle  # Reference the Muzzle (Marker2D) node
	add_to_group("enemy")  # Ensure player is in "damage" group
	hud = get_tree().get_root().get_node("Main/HUD")  # Adjust "Main/HUD" to your scene structure

func _process(delta):
	follow_player(delta)  # Make the enemy follow the player
	rotation = (player.global_position - global_position).angle()
	shoot_timer += delta
	if shoot_timer >= shoot_interval:
		shoot()
		shoot_timer = 0.0

func follow_player(_delta):
	if player == null:
		return  # No player to follow
		# Calculate direction to the playerss
	var direction_to_player = (player.position - position).normalized()
	# Set velocity to move toward the player
	velocity = direction_to_player * speed
	move_and_slide()

func shoot():
	if bullet_scene == null:
		print("Enemy bullet scene is not set!")
		return
		
	var bullet = bullet_scene.instantiate()
	bullet.position = muzzle.global_position  # Spawn bullet from Muzzle node
	bullet.direction = (player.global_position - bullet.position).normalized()  # Aim at the player
	get_parent().add_child(bullet)  # Add to the game world
	
func decrement_lives():
	hit_count += 1  # Increment the hit counter
	if hud:
		hud.update_enemy_hits(hit_count)  # Update HUD (0 for player lives, hit_count for enemy lives)
