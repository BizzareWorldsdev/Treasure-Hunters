extends Node
class_name RunTimeLevel

@onready var level_name = name

var max_score = 0
var max_coins = 0

func ready():
	GameManager.level_beaten.connect(beat_level)
	set_values()

func set_values():
	for node in get_children():
		if node is Coin:
			max_score += node.score
			max_coins += node.coins
		if node is Sabertooth or node is Canon:
			max_score += node.score

func beat_level():
	LevelData.generate_level(LevelData.level_dic[level_name]["unlocks"])
	LevelData.level_dic[LevelData.level_dic[level_name]["unlocks"]]["unlocked"] = true
	
	LevelData.update_level(level_name, GameManager.score, max_score, GameManager.coins, max_coins, GameManager.damage_taken, true)
