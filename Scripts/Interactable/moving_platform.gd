extends Node2D

var moving = false



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !moving:
		moving = true
		$AnimatableBody2D/AnimationPlayer.play("Move")
