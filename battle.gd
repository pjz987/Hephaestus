extends Node2D

@onready var SOLDIER_SCENE = load('res://soldier.tscn')
@onready var ARCHER_SCENE = load('res://archer.tscn')
@onready var GIANT_SCENE = load('res://giant.tscn')

@onready var soldier_spawn_point = $SoldierSpawnPoint
@onready var giant_spawn_point = $GiantSpawnPoint
@onready var resources_label = $UI/ResourcesLabel
@onready var archer_spawn_point = $ArcherSpawnPoint
@onready var giant_spawn_timer = $GiantSpawnTimer
@onready var end_screen = $EndScreen
@onready var end_screen_label = $EndScreen/EndScreenLabel
@onready var victory_countdown_label = $UI/VictoryCountdownLabel
@onready var victory_timer = $VictoryTimer

var zapsound = MasterAudio.get_child(9)
var thundsound = MasterAudio.get_child(10)


func _ready():
	GameManager.resource_change.connect(_on_resource_changed)
	GameManager.increase_giant_spawn_rate.connect(_on_increase_giant_spawn_rate)
	update_resources()

func _process(delta):
	victory_countdown_label.text = 'Help Arrives\nIn ' + str(ceil(victory_timer.time_left))

func _on_spawn_soldier_button_button_down():
	if GameManager.resources.wood >= 3:
		GameManager.resource_spend('wood', 3)
		var soldier = SOLDIER_SCENE.instantiate()
		add_child(soldier)
		soldier.global_position = soldier_spawn_point.position
	#else:
		#print('nah nah nah')

func _on_spawn_archer_button_button_down():
	if GameManager.resources.wood >= 2 and GameManager.resources.stone >= 2:
		GameManager.resource_spend('wood', 2)
		GameManager.resource_spend('stone', 2)
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

func _on_increase_giant_spawn_rate():
	giant_spawn_timer.wait_time -= 1.5


func _on_defeat_zone_area_entered(area):
	end_screen_label.text = 'DEFEAT'
	end_screen.visible = true
	end_screen.z_index = 2


func _on_play_again_button_button_down():
	GameManager.reset_battle()
	get_tree().reload_current_scene()


func _on_exit_button_button_down():
	get_tree().quit()


func _on_victory_timer_timeout():
	GameManager.win_game()
	zapsound.play()
	end_screen_label.text = 'VICTORY'
	end_screen.visible = true
	end_screen.z_index = 2
	thundsound.play()
	#await get_tree().create_timer(1.0).timeout
