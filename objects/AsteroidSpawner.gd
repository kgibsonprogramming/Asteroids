extends Node

signal difficulty_changed


var asteroid_scene := load("res://objects/Asteroid.tscn")

var asteroid_spawn_interval := 2.0
var difficulty_index = 1.5

func restart():
	$SpawnTimer.stop()
	$DifficultyTimer.stop()
	asteroid_spawn_interval = 2
	difficulty_index = 1.5
	emit_signal("difficulty_changed", difficulty_index)
	$SpawnTimer.start()
	$DifficultyTimer.start()

func _ready() -> void:
	_spawn_asteroid()
# warning-ignore:return_value_discarded
	connect("difficulty_changed", get_parent(), "update_difficulty_text")

func _spawn_asteroid():
	var asteroid = asteroid_scene.instance()
	
	_set_asteroid_position(asteroid)
	_set_asteroid_trajectory(asteroid)
	
	add_child(asteroid)


func _on_SpawnTimer_timeout():
	_spawn_asteroid()

func _set_asteroid_position(asteroid):
	var rect = get_viewport().size
	asteroid.position = Vector2(rand_range(0, rect.x), -100)

func _set_asteroid_trajectory(asteroid):
	asteroid.angular_velocity = rand_range(-4, 4)
	asteroid.angular_damp = 0
	asteroid.linear_velocity = Vector2(rand_range(-300, 300), 300)
	asteroid.linear_damp = 0


func _on_DifficultyTimer_timeout():
	$SpawnTimer.wait_time = float(asteroid_spawn_interval) / float(difficulty_index)
	difficulty_index += 1
	emit_signal("difficulty_changed", difficulty_index)
