class_name Giant
extends CharacterBody2D

@export var movement_speed = 10

enum STATE {MOVE, REST, ATTACK}
@export var state = STATE.MOVE
@export var rest_period_base = 1.5
@export var rest_period_randomness = 0.2
@export var move_period_base = 2.5
@export var move_period_randomness = 0.2

@export var max_health = 50
@export var health: int

@export var attack_damage = 10


var dsound = MasterAudio.get_child(0)
var hitsound = MasterAudio.get_child(5)
#var dsound = get_path()


@onready var ray_cast_2d = $RayCast2D
@onready var animation_player = $AnimationPlayer
@onready var label = $Label
@onready var resource_spawn_point = $ResourceSpawnPoint
@onready var death_sound_player = $DeathSoundPlayer
@onready var blood_spawn_point = $BloodSpawnPoint
@onready var WOOD_SCENE = load('res://wood.tscn')
@onready var STONE_SCENE = load('res://stone.tscn')
@onready var BLOOD_SCENE = load('res://blood.tscn')


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
			velocity.x = -movement_speed
			animation_player.play('walk')
		STATE.REST:
			velocity.x = 0.0
			animation_player.play('idle')
		STATE.ATTACK:
			velocity.x = 0.0
			animation_player.play('attack')
			
	move_and_slide()
			

func start_attacking():
	state = STATE.ATTACK
	
func attack():
	animation_player.play('attack')

func start_resting():
	state = STATE.REST
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
	health -= area.get_parent().attack
	area.get_parent().hitsound.play()
	if health <= 0:
		die()
	label.text = str(health)

func die():
	GameManager.giant_kill()
	var wood_count = randi_range(3, 4)
	for _i in range(wood_count):
		var wood = WOOD_SCENE.instantiate()
		get_tree().current_scene.add_child(wood)
		wood.global_position = resource_spawn_point.global_position
	var stone_count = randi_range(0, 1)
	for _i in range(stone_count):
		var stone = STONE_SCENE.instantiate()
		get_tree().current_scene.add_child(stone)
		stone.global_position = resource_spawn_point.global_position
	
	var blood = BLOOD_SCENE.instantiate()
	get_tree().current_scene.add_child(blood)
	blood.global_position = blood_spawn_point.global_position
	blood.emitting = true
	
	#death_sound_player.play()
	
	#print(death_sound_player.playing)
	#await not death_sound_player.playing
	#print("player should have played")
	dsound.play()
	queue_free()
  
