extends CharacterBody2D

@export var movement_speed = 15

enum STATE {MOVE, REST, ATTACK}
@export var state = STATE.MOVE
@export var rest_period_base = 1.0
@export var rest_period_randomness = 0.2
@export var move_period_base = 3.0
@export var move_period_randomness = 0.2

@export var max_health = 20
@export var health: int

@export var attack = 10

@onready var label = $Label
@onready var ray_cast_2d = $RayCast2D
@onready var animation_player = $AnimationPlayer

func _ready():
	health = max_health
	label.text = str(health)
	if randf() >= 0.5:
		start_resting()
	else:
		start_moving()

func _physics_process(_delta):
	if ray_cast_2d.is_colliding():
		state = STATE.ATTACK
	match state:
		STATE.MOVE:
			velocity.x = movement_speed
			animation_player.play('RESET')
		STATE.REST:
			velocity.x = 0.0
			animation_player.play('RESET')
		STATE.ATTACK:
			animation_player.play('attack')
			velocity.x = 0.0
	move_and_slide()
			


func start_resting():
	state = STATE.REST
	#var rest_period_randomness_factor = 
	#var rest_period = rest_period_base 
	await get_tree().create_timer(rest_period_base).timeout
	start_moving()
	
func start_moving():
	state = STATE.MOVE
	await get_tree().create_timer(move_period_base).timeout
	start_resting()



func _on_hurtbox_area_entered(area):
	health -= 5
	if health <= 0:
		die()
	label.text = str(health)

func die():
	queue_free()