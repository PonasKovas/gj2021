extends Sprite

var i = 0

var since_talked = -1.0

func _process(delta):
	if since_talked == -1 or since_talked >= 5.0:
		#get_node("/root/Node2D/CanvasLayer/penalty").modulate.a = 0
		if position.distance_to(get_node("/root/Node2D/YSort/player").position) <= 48:
			if position.distance_to(get_node("/root/Node2D/YSort/player").position) >= 16:
				i += delta
				frame = 1 if (int(i*10/1.5) % 2) == 0 else 2
				# move
				var direction = get_node("/root/Node2D/YSort/player").position - position
				position += direction.normalized()*25.0*delta
			else:
				frame = 0
				$talk.play()
				get_node("/root/Node2D/YSort/player").time_left -= 10
				since_talked = 0
		else:
			i = 0
			frame = 0
	else:
		since_talked += delta
		get_node("/root/Node2D/CanvasLayer/penalty").modulate.a = max(0, 1 - since_talked / 0.3)
