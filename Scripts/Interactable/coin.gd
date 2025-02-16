extends Node2D
class_name Coin

@export var score = 10
@export var coins = 1

func _ready() -> void:
	$AnimatedSprite2D.play("idle")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		GameManager.gain_coins(coins)
		GameManager.score += score
		queue_free()
