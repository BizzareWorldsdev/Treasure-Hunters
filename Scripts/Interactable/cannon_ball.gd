extends Node2D

var direction
@export var speed = 200.0
var lifetime = 2.0
var hit = false

func _ready():
	await get_tree().create_timer(lifetime).timeout
	die()

func die():
	hit  = true
	speed = 0
	$AnimationPlayer.play("Hit")

func _physics_process(delta: float) -> void:
	position.x += abs(speed * delta) * direction

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !hit:
		area.get_parent().take_damge(1)
		die()
