extends RigidBody2D

@export var min_impulse_speed: int
@export var max_impulse_speed: int

var gsound = MasterAudio.get_child(4)

func _ready():
	var rotational_offset = randf_range(-PI * 0.5, PI * 0.5) # ?
	var impulse_direction = Vector2.UP.rotated(rotational_offset) # ?
	apply_impulse(impulse_direction * min_impulse_speed)


func _on_mouse_pickup_area_mouse_entered():
	#GameManager.resource_pickup(GameManager.RESOURCE.WOOD)
	GameManager.resource_pickup('wood')
	gsound.play()
	queue_free()
