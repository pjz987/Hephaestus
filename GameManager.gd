extends Node


var resources = {
	'wood': 0,
	'iron': 0,
	'stone': 0
}


var giants_killed = 0
var giant_spawn_increase_rate = 3

#enum RESOURCE {WOOD, IRON, STONE}

signal resource_change
signal increase_giant_spawn_rate
signal game_lost
signal game_won


func giant_kill():
	giants_killed += 1
	if giants_killed % giant_spawn_increase_rate == 0:
		increase_giant_spawn_rate.emit()


func resource_spend(resource_name: String, amount: int):
	resources[resource_name] -= amount
	resource_change.emit()

func resource_pickup(resource_name):
	resources[resource_name] += 1
	resource_change.emit()

func reset_battle():
	resources['wood'] = 0
	resources['stone'] = 0
	giants_killed = 0

func win_game():
	game_won.emit()
