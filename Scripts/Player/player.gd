extends CharacterBody2D
class_name Player
@onready var animation = $AnimationPlayer
@onready var sprite = $IdleSword01
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var attaking = false
@export var hit = false
var jump = 0
var can_jump = true

var max_health = 2
var health = 0
var can_take_damage = true

func _ready() -> void:
	GameManager.damage_taken = 0
	GameManager.pause_menu = $"../UIManager/PauseMenu"
	health = max_health
	GameManager.player = self

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack") && !hit:
		attack()
	

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("recall_checkpoint"):
		die()
	if Input.is_action_pressed("left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
		$AttackArea.scale.x = abs($AttackArea.scale.x) * -1
		
	if Input.is_action_just_pressed("right"):
		sprite.scale.x = abs(sprite.scale.x)
		$AttackArea.scale.x = abs($AttackArea.scale.x)
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump")  and can_jump == true:
		$Jump2.play()
		jump+=1
		velocity.y = JUMP_VELOCITY
	if jump >= 2:
		can_jump = false
		jump = 0
	if is_on_floor():
		can_jump = true

		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	update_animation()
	move_and_slide()
	
	if position.y >= 600:
		die()
	
func attack():
	var overlapping_object = $AttackArea.get_overlapping_areas()
	
	for area in overlapping_object:
		if area.get_parent().is_in_group("Enemies"):
			area.get_parent().take_damage(1)
			$AudioStreamPlayer2D.play()
	attaking = true
	animation.play("attack")
	

func update_animation():
	if !attaking && !hit:
		if velocity.x != 0:
			animation.play("run")
		else:
			animation.play("idle")
		if velocity.y < 0:
			animation.play("jump")
		if velocity.y > 0:
			animation.play("fall")

func take_damge(damge_amount : int):
	if can_take_damage:
		iframes()
		
		hit = true
		attaking = false
		animation.play("Hit")
		
		GameManager.damage_taken += 1
		
		health -= damge_amount
		
		if health <= 0:
			die()
			
func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true

func die():
	GameManager.respawn_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down") && is_on_floor():
		print("Under")
		position.y += 16
