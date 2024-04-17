extends CharacterBody2D

@export var SPEED = 40

var attack = 10
var dir : float
var spawnPos : Vector2
var spawnRot : float


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = spawnPos
	global_rotation = spawnRot 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector2(SPEED, 0).rotated(dir)
	move_and_slide()

