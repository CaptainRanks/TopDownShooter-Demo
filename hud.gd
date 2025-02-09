extends CanvasLayer

func update_player_lives(player_lives: int):
	$PlayerLivesLabel.text = "Enemy Points: %d" % player_lives

func update_enemy_hits(enemy_hits: int):
	$"EnemyLivesLabel".text = "Player Points: %d" % enemy_hits
