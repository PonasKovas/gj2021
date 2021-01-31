extends Control

var i = 0

func _ready():
	Singleton.boss_music = false

func _process(delta):
	$Label.visible = (int(i*1.6) % 2 == 0)
	
	$cloud.rect_position = Vector2(
		50*cos(i),
		5*sin(i) -50
	)
	
	i += delta

func _input(event):
	if event is InputEventKey and event.pressed:
		get_tree().change_scene("res://game.tscn")
