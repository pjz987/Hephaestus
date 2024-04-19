extends Node2D

@onready var SOLDIER_SCENE = load('res://soldier.tscn')
@onready var GIANT_SCENE = load('res://giant.tscn')

@onready var soldier_spawn_point = $SoldierSpawnPoint
@onready var giant_spawn_point = $GiantSpawnPoint
@onready var resources_label = $UI/ResourcesLabel

func _ready():
	GameManager.resource_change.connect(_on_resource_changed)

func _on_spawn_soldier_button_button_down():
	if GameManager.resources.wood >= 1:
		GameManager.resource_spend('wood')
		var soldier = SOLDIER_SCENE.instantiate()
		add_child(soldier)
		soldier.global_position = soldier_spawn_point.position
	#else:
		#print('nah nah nah')


#func _on_spawn_giant_button_button_down():
	#var giant = GIANT_SCENE.instantiate()
	#add_child(giant)
	#giant.global_position = giant_spawn_point.position

func _on_resource_changed():
	update_resources()

func update_resources():
	var wood_count = GameManager.resources['wood']
	resources_label.text = 'Wood: ' + str(wood_count)

#func spawn_giant():
	

func _on_giant_spawn_timer_timeout():
	var giant = GIANT_SCENE.instantiate()
	add_child(giant)
	giant.global_position = giant_spawn_point.position
