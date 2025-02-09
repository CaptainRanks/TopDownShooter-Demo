extends CharacterBody2D

@export var speed: float = 200.0  # Adjust movement speed
@export var bullet_scene: PackedScene  # Reference to bullet scene
@export var zoom_speed: float = 0.1  # Speed of zooming
@export var min_zoom: float = 0.25  # Smaller value zooms out more
@export var max_zoom: float = 1.0  # Default value, cannot zoom in more than original shot
#@export var lives: int = 3  # Player starts with 3 lives

var camera: Camera2D
var muzzle: Marker2D # Used to be Position2D
var hud: CanvasLayer
var hit_count: int = 0

func _ready():
	camera = $Camera2D  # Finds the Camera2D node
	muzzle = $Muzzle  # Reference the Muzzle (Marker2D) node
	add_to_group("player")  # Ensure player is in "damage" group
	hud = get_tree().get_root().get_node("Main/HUD")  # Adjust "Main" to your actual root node name

func _process(_delta):
	var direction = Vector2.ZERO  # Default no movement
	var mouse_position = get_global_mouse_position()  # Mouse position in world coordinates
	rotation = (mouse_position - global_position).angle()  # Rotate player to face mouse

	# Check for movement inputs
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	# Normalize diagonal movement and apply speed
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

func _input(event):
	if event.is_action_pressed("fire"):
		shoot()
	if event.is_action_pressed("zoom_out"):
		adjust_zoom(-zoom_speed)
	elif event.is_action_pressed("zoom_in"):
		adjust_zoom(zoom_speed)

func adjust_zoom(amount):
	if camera:
		var new_zoom = camera.zoom + Vector2(amount, amount)
		new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
		new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
		camera.zoom = new_zoom

func shoot():
	if bullet_scene == null:
		print("Player bullet scene is not set!")
		return
	var bullet = bullet_scene.instantiate()
	bullet.position = muzzle.global_position  # Use the Muzzle node for bullet spawn position
	bullet.direction = Vector2.RIGHT.rotated(rotation)  # Fire in the player's facing direction

	# Get the mouse position in world coordinates
	var mouse_position = get_global_mouse_position()
	# Calculate direction from player to mouse
	bullet.direction = (mouse_position - position).normalized()
	get_parent().add_child(bullet) 

func increment_hit_count():
	hit_count += 1  # Increment the hit counter
	#print("Player hit! Total hits:", hit_count)  # Debugging
	if hud:
		hud.update_player_lives(hit_count)  # Update the HUD
