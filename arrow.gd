extends CharacterBody2D


#@export var SPEED = 500
@export var SPEED = 415
@export var ARC = -20
@onready var area_2d = $Area2D

var attack = 5
var dir : float
var spawnPos : Vector2
var spawnRot : float
var firesound=MasterAudio.get_child(1)
var hitsound=MasterAudio.get_child(2)
@onready var sprite = $Sprite2D

#@export var arc_force = -700


#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")/2
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")/8
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")/8

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = spawnPos
	global_rotation = spawnRot 
	#velocity = Vector2(SPEED,ARC)
	velocity = Vector2(SPEED, ARC)
	sprite.rotation = velocity.y/300
	#sprite.scale *= 5
	firesound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#velocity = Vector2(SPEED, 0).rotated(dir)
	velocity.y += gravity * delta
	sprite.rotation = velocity.y/300
	
	move_and_slide()



func _on_area_2d_area_entered(area):
	#await get_tree().create_timer(0.01).timeout
	#hitsound.play()
	queue_free()
	
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	#print("poof")
	queue_free()
	pass # Replace with function body.
