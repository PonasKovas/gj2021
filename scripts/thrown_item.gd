extends Sprite


var direction = Vector2(1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * delta * 120.0
	rotation_degrees += delta*360
