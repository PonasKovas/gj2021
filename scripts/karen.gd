extends Sprite

var i = 0

var talking = false

var time_since_noticed = 0

var time_since_hit = 10

var speed = 50.0

func _process(delta):
	if position.distance_to(get_node("/root/Node2D/YSort/player").position) <= 160:
		# camera effect
		var camera = get_node("/root/Node2D/YSort/player/Camera2D")
		var force = max(0.0, -4*pow(time_since_noticed - 0.5, 2) + 1)
		if force > 1.0:
			force = 0
		camera.offset = force*(position - get_node("/root/Node2D/YSort/player").position)
		camera.zoom = Vector2(0.3 - force*0.05, 0.3 - force*0.05)
		Singleton.boss_music = true
		time_since_noticed += delta
		$Sprite.visible = true
		if position.distance_to(get_node("/root/Node2D/YSort/player").position) >= 16:
			i += delta
			frame = 1 if (int(i*10/1.5) % 2) == 0 else 2
			# move
			var direction = get_node("/root/Node2D/YSort/player").position - position
			position += direction.normalized()*speed*delta
		else:
			# if not already
			if not talking:
				frame = 0
				$talk.play()
				talking = true
				get_node("/root/Node2D/YSort/player").time_left -= 1000000
	elif time_since_noticed > 0:
		var camera = get_node("/root/Node2D/YSort/player/Camera2D")
		camera.offset = Vector2(0, 0)
		camera.zoom = Vector2(0.3, 0.3)
		time_since_noticed = 0
		Singleton.boss_music = false
		i = 0
		$Sprite.visible = false
		frame = 0
	
	$Sprite.position.y = sin(5*i) * 3 - 25
	
	# check if colliding with any thrown item
	for item in get_node("/root/Node2D/in_air").get_children():
		if item.position.distance_to(position) <= 16:
			item.queue_free()
			time_since_hit = 0
			speed = 20.0
	
	if time_since_hit > 1:
		speed = 50.0
	
	time_since_hit += delta
