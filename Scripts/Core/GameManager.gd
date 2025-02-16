extends Node

signal level_beaten()
signal gained_coins()

var coins : int
var score : int = 0
 
var current_checkpoint : Checkpoint

var player : Player
var damage_taken = 0

var pause_menu

var paused = false
var win_screen 
var score_label

func respawn_player():
	player.health = player.max_health
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

func gain_coins(coins_gained:int):
	coins += coins_gained
	emit_signal("gained_coins", coins)

func win():
	emit_signal("level_beaten")
	win_screen.visible = true
	
	score_label.text = "score: " + str(score)

func pause_play():
	paused = !paused
	
	pause_menu.visible = paused
	
	
func resume():
	get_tree().paused = false
	pause_play()
	
func restart():
	coins = 0
	score = 0
	get_tree().reload_current_scene()

func load_world():
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/world_map.tscn")

func quit():
	get_tree().quit()
