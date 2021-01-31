extends AudioStreamPlayer


var boss_music = false
var was_boss_music = false

var i = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boss_music != was_boss_music:
		i = 0
		was_boss_music = boss_music
	
	if boss_music:
		$boss_music.volume_db = min(60*i/0.5 - 80, -20)
		volume_db = max(-80, -74.5*i/0.5 - 6.5)
	else:
		$boss_music.volume_db = max(-80, -60*i/0.5 - 20)
		volume_db = min(74.5*i/0.5 - 80, -6.5)
	i += delta
