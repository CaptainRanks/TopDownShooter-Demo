extends CanvasLayer

# Updates the lives displayed on the HUD
func update_lives(player_lives: int, enemy_lives: int):
	$PlayerLivesLabel.text = "Player Lives: %d" % player_lives
	$EnemyLivesLabel.text = "Enemy Lives: %d" % enemy_lives
