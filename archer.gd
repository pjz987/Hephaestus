class_name Archer
extends CharacterBody2D

@export var movement_speed = 15

enum STATE {MOVE, REST, ATTACK, RELOAD}
@export var state = STATE.MOVE
@export var rest_period_base = 1.0
@export var rest_period_randomness = 0.2
@export var move_period_base = 3.0
#@export var reload_period_base = 10
@export var move_period_randomness = 0.2

@export var max_health = 20
@export var health: int

@export var attack = 2
var is_hero: bool

@onready var sprite_2d = $Sprite2D
@onready var label = $Label
@onready var ray_cast_2d = $RayCast2D
@onready var animation_player = $AnimationPlayer
@onready var main = get_tree().get_root().get_node("Battle") # play with this
@onready var projectile = load("res://arrow.tscn")
@onready var arrow_spawn_point = $ArrowSpawnPoint
@onready var reload_timer = $ReloadTimer
@onready var arrow_damage = 10

func _ready():
	is_hero = randf() > 0.8
	health = max_health
	#if is_hero:
		#health *= 2
		#attack *= 2
		#sprite_2d.modulate = Color(0.8, 0.9, 0.5, 1.0) # nice
		#scale *= 1.5
		#
	label.text = str(health)
	if randf() >= 0.5:
		start_resting()
	else:
		start_moving()

func _physics_process(_delta):
	
	if ray_cast_2d.is_colliding():
		state = STATE.ATTACK
		 #state != STATE.RELOAD:
			#state = STATE.ATTACK
	match state:
		STATE.MOVE:
			#print("moving")
			velocity.x = movement_speed
			#animation_player.play('RESET')
		STATE.REST:
			#print("resting")
			velocity.x = 0.0
			#animation_player.play('RESET')
		STATE.ATTACK:
			#print("attacking")
			shoot()
			#await get_tree().create_timer(3).timeout
			#animation_player.play('attack')
			velocity.x = 0.0 # will this be redundant? and should is go before shoot?
		#STATE.RELOAD: # currently unused
			#reload()
			#print("reloading")
			
			
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

#func reload():
	##print("reload")
	#await get_tree().create_timer(reload_period_base).timeout
	#state = STATE.MOVE

	


func _on_hurtbox_area_entered(area):
	health -= 5
	if health <= 0:
		die()
	label.text = str(health)

func die():
	queue_free()
	

func shoot():
	#state = STATE.RELOAD
	state = STATE.REST
	if reload_timer.time_left == 0:
		reload_timer.start()
		var instance = projectile.instantiate()
	
		instance.dir = rotation
		instance.spawnPos = arrow_spawn_point.global_position
		instance.spawnRot = rotation
		main.add_child.call_deferred(instance)
		#var arrow = main.add_child.call_deferred(instance)
		#arrow.damage = arrow_damage
	#await get_tree().create_timer(reload_period_base).timeout
	#print("shoot")
