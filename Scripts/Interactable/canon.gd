extends StaticBody2D
class_name Canon

var cannon_ball = load("res://Scenes/Interactables/cannon_ball.tscn")
var debris = load("res://Scenes/Interactables/cannon_debris.tscn")

@export var score = 100
@export var shooting : bool
var firerate = 2

@onready var animation_player = $AnimationPlayer
@onready var firepoint = $FirePoint

var max_health  = 3
var health

func _ready() -> void:
	health = max_health
	shooting = true
	shoot()

func shoot():
	while shooting:
		animation_player.play("fire")
		await get_tree().create_timer(firerate).timeout

func fire():
	var spawned_ball = cannon_ball.instantiate()
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.position
	add_child(spawned_ball)

func take_damage(damge_amount):
	health -= damge_amount
	
	get_node("Healthbar").update_healthbar(health, max_health)
	
	animation_player.play("hit")
	
	if health <= 0:
		die()

func die():
	GameManager.score += score
	var spawned_debris = debris.instantiate()
	spawned_debris.global_position = position
	spawned_debris.scale.x = scale.x
	spawned_debris.get_child(1).play("Crumble")
	get_tree().get_root().get_child(1).add_child(spawned_debris)
	queue_free()
	
