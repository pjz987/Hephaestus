extends Node


var resources = {
	'wood': 0,
	'iron': 0,
	'stone': 0
}

#enum RESOURCE {WOOD, IRON, STONE}

signal resource_change



func resource_spend(resource_name: String, amount: int):
	resources[resource_name] -= amount
	resource_change.emit()

func resource_pickup(resource_name):
	resources[resource_name] += 1
	resource_change.emit()
