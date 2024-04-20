class_name Soldier
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
var hitsound=MasterAudio.get_child(3)

@export var attack = 2
var is_hero: bool

@onready var sprite_2d = $Sprite2D
@onready var label = $Label
@onready var ray_cast_2d = $RayCast2D
@onready var animation_player = $AnimationPlayer

func _ready():
	is_hero = randf() > 0.8
	health = max_health
	if is_hero:
		health *= 2
		attack *= 2
		sprite_2d.modulate = Color(0.8, 0.9, 0.5, 1.0)
		scale *= 1.5
		
	label.text = str(health)
	if randf() >= 0.5:
		start_resting()
	else:
		start_moving()

func _physics_process(_delta):
	#print(global_position)
	if ray_cast_2d.is_colliding():
		state = STATE.ATTACK
	match state:
		STATE.MOVE:
			velocity.x = movement_speed
			animation_player.play('walk')
		STATE.REST:
			velocity.x = 0.0
			animation_player.play('idle')
		STATE.ATTACK:
			animation_player.play('attack')
			velocity.x = 0.0
			#hitsound.play() # think about hitsound workaround
			print("melee hit!")
	move_and_slide()
			


func start_resting():
	state = STATE.REST
	print(rest_period_base, rest_period_randomness)
	var rest_period = randf_range(
		rest_period_base * 1 - rest_period_randomness,
		rest_period_base * 1 + rest_period_randomness
	)
	await get_tree().create_timer(rest_period).timeout
	start_moving()
	
func start_moving():
	state = STATE.MOVE
	var move_period = randf_range(
		move_period_base * 1 - move_period_randomness,
		move_period_base * 1 + move_period_randomness
	)
	await get_tree().create_timer(move_period).timeout
	start_resting()



func _on_hurtbox_area_entered(area):
	area.get_parent().hitsound.play()
	health -= 5
	if health <= 0:
		die()
	label.text = str(health)

func die():
	queue_free()
