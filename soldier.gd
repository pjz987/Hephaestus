extends CharacterBody2D

@export var movement_speed = 15

enum STATE {MOVE, REST, ATTACK}
@export var state = STATE.MOVE
@export var rest_period_base = 1.0
@export var rest_period_randomness = 0.2
@export var move_period_base = 3.0
@export var move_period_randomness = 0.2

@export var max_health = 50
@export var health: int

@export var attack = 10

func _ready():
	if randf() >= 0.5:
		start_resting()
	else:
		start_moving()

func _physics_process(_delta):
	match state:
		STATE.MOVE:
			velocity.x = movement_speed
		STATE.REST:
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

