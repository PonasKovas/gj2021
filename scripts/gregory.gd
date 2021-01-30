extends StaticBody2D

var since_talked = -1.0

func _process(delta):
	if since_talked == -1 or since_talked >= 5.0:
		if position.distance_to(get_node("/root/Node2D/YSort/player").position) < 16:
			$talk.play()
			since_talked = 0
	else:
		since_talked += delta
