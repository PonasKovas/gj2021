extends Sprite

var i = 0

var talking = false

var time_since_noticed = 0
var time_since_lost = 5

func _process(delta):
	if position.distance_to(get_node("/root/Node2D/YSort/player").position) <= 160:
		time_since_lost = 0
		# camera effect
		var camera = get_node("/root/Node2D/YSort/player/Camera2D")
		var force = max(0.0, -4*pow(time_since_noticed - 0.5, 2) + 1)
		if force > 1.0:
			force = 0
		camera.offset = force*(position - get_node("/root/Node2D/YSort/player").position)
		camera.zoom = Vector2(0.3 - force*0.05, 0.3 - force*0.05)
		$boss_music.volume_db = min(60*time_since_noticed/0.5 - 80, -20)
		Singleton.volume_db = max(-80, -74.5*time_since_noticed/0.5 - 6.5)
		time_since_noticed += delta
		$Sprite.visible = true
		if position.distance_to(get_node("/root/Node2D/YSort/player").position) >= 16:
			i += delta
			frame = 1 if (int(i*10/1.5) % 2) == 0 else 2
			# move
			var direction = get_node("/root/Node2D/YSort/player").position - position
			position += direction.normalized()*50.0*delta
		else:
			# if not already
			if not talking:
				frame = 0
				$talk.play()
				talking = true
				get_node("/root/Node2D/YSort/player").time_left -= 120
	else:
		time_since_noticed = 0
		$boss_music.volume_db = max(-80, -60*time_since_lost/0.5 - 20)
		Singleton.volume_db = min(74.5*time_since_lost/0.5 - 80, -6.5)
		time_since_lost += delta
		i = 0
		$Sprite.visible = false
		frame = 0
	
	$Sprite.position.y = sin(5*i) * 3 - 25
