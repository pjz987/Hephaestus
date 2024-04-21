extends Control

@onready var label = $Container/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = 'Defeat'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
