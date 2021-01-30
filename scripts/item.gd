extends KinematicBody2D

var i = 0
var j = 0

func _process(delta):
	if position.distance_to(get_node("/root/Node2D/YSort/player").position) <= 48:
		j = 0
		i += delta
		if i <= 0.1:
			$sprite.frame = 1
		else:
			$sprite.frame = 2 if (int(i*10/1.5) % 2) == 0 else 3
			# move
			var direction = position - get_node("/root/Node2D/YSort/player").position
			move_and_slide(direction.normalized()*40)
	else:
		i = 0
		j += delta
		if j <= 0.1:
			$sprite.frame = 1
		else:
			$sprite.frame = 0
