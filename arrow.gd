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



func _on_area_2d_area_entered(area):
	queue_free()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	#print("poof")
	queue_free()
	pass # Replace with function body.
