extends CharacterBody2D
class_name Sabertooth

var SPEED = -60.0
var current_speed = 0.0
const JUMP_VELOCITY = -400.0
var dead = false
var facing_right = false
var max_health = 2
var health
var hit = false
var can_attack = true
@export var score = 50

func _ready() -> void:
	health = max_health
	$AnimationPlayer.play("run")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
		
	velocity.x = SPEED
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		SPEED = abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1

func take_damage(damage_amount):
	if !dead:
		$AnimationPlayer.play("Hit")
		
		health -= damage_amount
	
		get_node("Healthbar").update_healthbar(health, max_health)
		
		if health <= 0:
			die()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !dead && can_attack:
		area.get_parent().take_damge(1)

func get_hit():
	hit = !hit
	
	if hit:
		current_speed = SPEED
		SPEED = 0
		can_attack = false
	else:
		SPEED = current_speed
		can_attack  = true
		$AnimationPlayer.play("run")

func die():
	GameManager.score += score
	$AnimationPlayer.play("death")
	dead = true
	SPEED = 0
	
	
