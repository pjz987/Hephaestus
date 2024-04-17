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
#var dsound = get_path()


@onready var ray_cast_2d = $RayCast2D
@onready var animation_player = $AnimationPlayer
@onready var label = $Label
@onready var resource_spawn_point = $ResourceSpawnPoint
@onready var death_sound_player = $DeathSoundPlayer
@onready var WOOD_SCENE = load('res://wood.tscn')


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
			animation_player.play('RESET')
		STATE.REST:
			velocity.x = 0.0
			animation_player.play('RESET')
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
	#var rest_period_randomness_factor = 
	#var rest_period = rest_period_base 
	await get_tree().create_timer(rest_period_base).timeout
	start_moving()
	
func start_moving():
	state = STATE.MOVE
	await get_tree().create_timer(move_period_base).timeout
	start_resting()



func _on_hurtbox_area_entered(area):
	# TODO this attacked the wood, not the soldiers and crashed
	health -= area.get_parent().attack
	if health <= 0:
		die()
	label.text = str(health)

func die():
	var wood_count = randi_range(3, 5)
	for _i in range(wood_count):
		var wood = WOOD_SCENE.instantiate()
		get_tree().current_scene.add_child(wood)
		wood.global_position = resource_spawn_point.global_position
	#death_sound_player.play()
	
	#print(death_sound_player.playing)
	#await not death_sound_player.playing
	#print("player should have played")
	dsound.play()
	queue_free()
  
