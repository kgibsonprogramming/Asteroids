extends Label
var score = 0
func update_score(points_scored: int):
	score += points_scored
	text = "Score: " + str(score)

func reset():
	score = 0
	update_score(0)
