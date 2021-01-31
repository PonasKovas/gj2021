extends Sprite

var i = 0

var since_talked = -1.0

var time_since_hit = 10

func _process(delta):
	if since_talked == -1 or since_talked >= 5.0:
		#get_node("/root/Node2D/CanvasLayer/penalty").modulate.a = 0
		if position.distance_to(get_node("/root/Node2D/YSort/player").position) <= 48:
			if position.distance_to(get_node("/root/Node2D/YSort/player").position) >= 16:
				i += delta
				if time_since_hit > 1:
					frame = 1 if (int(i*10/1.5) % 2) == 0 else 2
					# move
					var direction = get_node("/root/Node2D/YSort/player").position - position
					position += direction.normalized()*25.0*delta
				else:
					frame = 0
			else:
				frame = 0
				$talk.play()
				get_node("/root/Node2D/YSort/player").time_left -= 30
				since_talked = 0
		else:
			i = 0
			frame = 0
	else:
		since_talked += delta
		get_node("/root/Node2D/CanvasLayer/penalty").modulate.a = max(0, 1 - since_talked / 0.3)
		get_node("/root/Node2D/CanvasLayer/status/penalty_text").modulate.a = max(0, 1 - since_talked / 1.5)
	
	# check if colliding with any thrown item
	for item in get_node("/root/Node2D/in_air").get_children():
		if item.position.distance_to(position) <= 16:
			item.queue_free()
			time_since_hit = 0
	
	time_since_hit += delta
