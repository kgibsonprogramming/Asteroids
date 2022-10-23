extends Node2D
var score : int
var score_color : Color

func set_score(points : int):
	score = points
	
	if score > 150:
		score_color = Color(0.5, 0.83, 0.06, 1.0)
	else:
		score_color = Color(1.0, 0.89, 0.38, 1.0)
	$Label.set("custom_colors/font_color", score_color)
	$Label.text = str(score)

func _on_Timer_timeout():
	queue_free()
