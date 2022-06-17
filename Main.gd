extends Node


func _ready():
	randomize()
	$UserInterface/Retry.hide()


func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene
	var mob := preload("res://Mob.tscn").instance() as Mob
	
	# Choose a random location on the SpawnPath
	# We store the reference to the SpawnLocation node
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset
	mob_spawn_location.unit_offset = randf()	
	
	var player_position = $Player.transform.origin
	mob.initialize(mob_spawn_location.translation, player_position)
	
	# We connect the mob to the score label to update the score upon squashing one
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")
	
	add_child(mob)


func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restarts the current scene
		get_tree().reload_current_scene()


