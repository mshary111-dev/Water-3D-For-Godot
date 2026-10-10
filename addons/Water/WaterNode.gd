@tool
extends Node3D
class_name Water

var water_scene := preload("res://addons/Water/water.tscn")

@export var setup_water := false:
	set(value):
		setup_water = value
		if value:
			# Delete every existing child
			for child in get_children():
				child.queue_free()
			
			# Add the water scene
			var w = water_scene.instantiate()
			add_child(w)
			
			# Reset the button
			setup_water = false
