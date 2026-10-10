@tool
extends EditorPlugin

var water_script := preload("res://addons/Water/WaterNode.gd")

func _enter_tree() -> void:
	# Registers "Water" in the Create New Node dialog
	# Base type is Node3D (change to Node2D if your scene is 2D)
	add_custom_type(
		"Water",                                    # Name shown in the node list
		"Node3D",                                   # Base class
		water_script,                                       # No extra script needed
		null                                        # Optional icon (Texture2D)
	)

func _exit_tree() -> void:
	remove_custom_type("Water")
