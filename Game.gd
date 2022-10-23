extends Node2D

var player_scene = load("res://characters/Player.tscn")
var player_start_pos = Vector2(626, 680)

var is_game_over := false
var is_high_score := false

var save_file_path = "res://save_data.json"

var score_data = [
		{"name":"pwningstar", "score": 10000},
		{"name":"chiwillrocku", "score": 9750},
		{"name":"tencountex", "score": 8200},
		{"name":"kg dubz", "score": 2200},
		{"name":"whytheynotfeedme", "score": 0}
	]

func _ready() -> void:
# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "call_wrap_around")

func call_wrap_around():
	get_tree().call_group("wrap_around", "recalculate_wrap_area")

func update_difficulty_text(num: int):
	$GUI/MarginContainer/HBox/VBox/Difficulty.text = "Difficulty: " + str(num)

# Game Over
func _on_Player_player_died():
	$MusicPlayer.stop()
	$MusicPlayer.stream = load("res://assets/audio/music/sawsquarenoise_-_06_-_Towel_Defence_Jingle_Loose.ogg")
	$MusicPlayer.stream.loop = false
	$MusicPlayer.volume_db = -5
	
	$AsteroidSpawner/SpawnTimer.stop()
	$AsteroidSpawner/DifficultyTimer.stop()
	
	for a in get_tree().get_nodes_in_group("asteroids"):
		if not a.is_queued_for_deletion() and a.has_node("AudioStreamPlayer2D"):
			a.get_node("AudioStreamPlayer2D").stop()
	
	$GameOverTimer.start()


func _on_GameOverTimer_timeout():
	_load_scores()
	var final_score = $GUI/MarginContainer/HBox/VBox/Score.score
	var score_status : bool
	var vis_status : bool
	var score_text = ""
	$MusicPlayer.play(0)
	
	if final_score > score_data[score_data.size() - 1]["score"]:
		score_status = true
		vis_status = true
		score_text += "NEW HIGH SCORE: " + str(final_score)
	else:
		score_status = false
		vis_status = false
		score_text += "Your Score: " + str(final_score)
	
	$GameOverLabel/HighScoresLabel.text = ""
	for k in score_data.size():
		var d = score_data[k]
		$GameOverLabel/HighScoresLabel.text += d["name"] + " - " + str(d["score"]) + " points\n"
	
	is_high_score = score_status
	$GameOverLabel/FinalScoreLabel.text = score_text
	$GameOverLabel/NameEdit.visible = vis_status
	if vis_status:
		$GameOverLabel/NameEdit.grab_focus()
	$GameOverLabel.visible = true
	is_game_over = true

func _respawn_player():
	var player = player_scene.instance()
	player.position = player_start_pos
	add_child(player)

func _add_new_high_score(hs_name: String, hs_score:int):
	score_data.pop_back()
	score_data.append({"name": hs_name, "score": hs_score})
	_set_highest_and_lowest_score()

func _save_scores():
	var file = File.new()
	file.open(save_file_path, File.WRITE)
	file.store_var(score_data, true)
	file.close()

func _load_scores():
	var file = File.new()
	file.open(save_file_path, File.READ)
	var file_data = file.get_var(true)
	if file_data != null:
		score_data = file_data

func _set_highest_and_lowest_score():
	score_data.sort_custom(self, "_score_sort_ascending")
	score_data.invert()

func _score_sort_ascending(a, b):
		if a["score"] < b["score"]:
			return true
		return false


func _undo_game_over():
	$GameOverLabel.visible = false
	$MusicPlayer.stop()
	$MusicPlayer.stream = load("res://assets/audio/music/sawsquarenoise_-_03_-_Towel_Defence_Ingame.ogg")
	$MusicPlayer.stream.loop = true
	$MusicPlayer.volume_db = -15
	$MusicPlayer.play()

func _unhandled_input(event: InputEvent) -> void:
	if is_game_over and event.is_action_released("restart_game"):
		_restart_game()

func _restart_game():
	if is_high_score:
		var high_score_name = $GameOverLabel/NameEdit.text
		if high_score_name.length() > 0:
			var final_score = $GUI/MarginContainer/HBox/VBox/Score.score
			_add_new_high_score(high_score_name, final_score)
			_save_scores()
	
	_undo_game_over()
	_respawn_player()
	$AsteroidSpawner.restart()
	$GUI/MarginContainer/HBox/VBox/Score.reset()
	is_game_over = false
	is_high_score = false











