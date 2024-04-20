extends Node2D

@onready var SOLDIER_SCENE = load('res://soldier.tscn')
@onready var ARCHER_SCENE = load('res://archer.tscn')
@onready var GIANT_SCENE = load('res://giant.tscn')

@onready var soldier_spawn_point = $SoldierSpawnPoint
@onready var giant_spawn_point = $GiantSpawnPoint
@onready var resources_label = $UI/ResourcesLabel
@onready var archer_spawn_point = $ArcherSpawnPoint


func _ready():
	GameManager.resource_change.connect(_on_resource_changed)
	update_resources()

func _on_spawn_soldier_button_button_down():
	print('this run?!?!?')
	if GameManager.resources.wood >= 2:
		GameManager.resource_spend('wood', 2)
		var soldier = SOLDIER_SCENE.instantiate()
		add_child(soldier)
		soldier.global_position = soldier_spawn_point.position
	#else:
		#print('nah nah nah')

func _on_spawn_archer_button_button_down():
	if GameManager.resources.wood >= 2 and GameManager.resources.stone >= 1:
		GameManager.resource_spend('wood', 2)
		GameManager.resource_spend('stone', 1)
		var archer = ARCHER_SCENE.instantiate()
		add_child(archer)
		archer.global_position = archer_spawn_point.position

func _on_resource_changed():
	update_resources()

func update_resources():
	var wood_count = GameManager.resources['wood']
	var stone_count = GameManager.resources['stone']
	resources_label.text = 'Wood : ' + str(wood_count) \
		+ '\nStone: ' + str(stone_count)


func _on_giant_spawn_timer_timeout():
	var giant = GIANT_SCENE.instantiate()
	add_child(giant)
	giant.global_position = giant_spawn_point.position


