extends KinematicBody2D

const SPEED = 70;
var i = 0

const STANDING_TEX = preload("res://assets/player.png")
const RUNNING1_TEX = preload("res://assets/player_run1.png")
const RUNNING2_TEX = preload("res://assets/player_run2.png")

var collected = 0
var time_left = 120.0;
var in_hand = 0

var in_hand_textures = [preload("res://assets/items/book.png"), preload("res://assets/items/book.png"), preload("res://assets/items/book.png")]

var starting_in = 3.0

const NUMBER_OF_iTEMS = 100
const NUMBER_OF_CUSTOMERS = 20
const NUMBER_OF_KARENS = 3

var timeout = false
var listen_for_key = false

var time_since_bonus = 10

func _ready():
	# spawn random items throughout the supermarket
	# calculate how many items should be spawned in each individual segment (all_items*segment_area/all_area)
	var all_area = 0
	var spawnables = get_node("/root/Node2D/spawnable").get_children()
	for spawnable in spawnables:
		all_area += spawnable.shape.extents.x*spawnable.shape.extents.y
	
	var rseed = OS.get_unix_time()
	# spawn items in each area
	for spawnable in spawnables:
		var to_spawn = NUMBER_OF_iTEMS * spawnable.shape.extents.x*spawnable.shape.extents.y / all_area
		var i = 0
		while i < to_spawn:
			seed(rseed)
			rseed +=1
			var x = (randi() % int(2*spawnable.shape.extents.x - 20)) + spawnable.position.x - spawnable.shape.extents.x + 10
			seed(rseed)
			rseed +=1
			var y = (randi() % int(2*spawnable.shape.extents.y - 20)) + spawnable.position.y - spawnable.shape.extents.y + 10
			var position = Vector2(x, y)
			
			# todo: make sure no items are too close
			var restart = false
			for item in get_node("/root/Node2D/items").get_children():
				if item.position.distance_to(position) <= 40:
					restart = true
					break
			
			if restart:
				continue
			
			var scene = preload("res://item.tscn")
			var scene_instance = scene.instance()
			scene_instance.position = position
			scene_instance.scale = Vector2(0.7, 0.7)
			seed(rseed)
			rseed +=1
			scene_instance.get_node("sprite").texture = [
				preload("res://assets/items/book.png"),
				preload("res://assets/items/football.png"),
				preload("res://assets/items/glasses.png"),
				preload("res://assets/items/key.png"),
				preload("res://assets/items/laikrodis.png"),
				preload("res://assets/items/passport.png"),
				preload("res://assets/items/pepsi.png"),
				preload("res://assets/items/phone.png"),
				preload("res://assets/items/ring.png"),
				preload("res://assets/items/spritas.png"),
				preload("res://assets/items/supreme.png"),
				preload("res://assets/items/umbrella.png"),
				preload("res://assets/items/wallet.png")
				][randi()%13]
			get_node("/root/Node2D/items").call_deferred("add_child", scene_instance)
			i+=1
		
		# customers
		to_spawn = NUMBER_OF_CUSTOMERS * spawnable.shape.extents.x*spawnable.shape.extents.y / all_area
		i = 0
		while i < to_spawn:
			seed(rseed)
			rseed +=1
			var x = (randi() % int(2*spawnable.shape.extents.x - 20)) + spawnable.position.x - spawnable.shape.extents.x + 10
			seed(rseed)
			rseed +=1
			var y = (randi() % int(2*spawnable.shape.extents.y - 20)) + spawnable.position.y - spawnable.shape.extents.y + 10
			var position = Vector2(x, y)
			
			# todo: make sure no items or customers or otherstuff are too close
			var restart = false
			for item in get_node("/root/Node2D/items").get_children():
				if item.position.distance_to(position) <= 40:
					restart = true
					break
			for item in get_node("/root/Node2D/YSort").get_children():
				if item.position.distance_to(position) <= 40:
					restart = true
					break
			
			if restart:
				continue
			
			var scene = preload("res://customer.tscn")
			var scene_instance = scene.instance()
			scene_instance.position = position
			scene_instance.scale = Vector2(1.5, 1.5)
			seed(rseed)
			rseed +=1
			scene_instance.texture = [
				preload("res://assets/customers/bluehood.png"),
				preload("res://assets/customers/buff-dude.png"),
				preload("res://assets/customers/green-boi.png"),
				][randi()%3]
			scene_instance.get_node("talk").stream = [
				preload("res://assets/sounds/talk1.ogg"),
				preload("res://assets/sounds/talk2.ogg")
				][randi()%2]
			get_node("/root/Node2D/YSort").call_deferred("add_child", scene_instance)
			i+=1
	
	
	# spawn karens
	spawnables = get_node("/root/Node2D/karen_zones").get_children()
	
	# spawn karens in each zone
	for spawnable in spawnables:
		seed(rseed)
		rseed +=1
		var x = (randi() % int(2*spawnable.shape.extents.x - 20)) + spawnable.position.x - spawnable.shape.extents.x + 10
		seed(rseed)
		rseed +=1
		var y = (randi() % int(2*spawnable.shape.extents.y - 20)) + spawnable.position.y - spawnable.shape.extents.y + 10
		var position = Vector2(x, y)
		
		var scene = preload("res://karen.tscn")
		var scene_instance = scene.instance()
		scene_instance.position = position
		scene_instance.scale = Vector2(1.5, 1.5)
		seed(rseed)
		rseed +=1
		get_node("/root/Node2D/YSort").call_deferred("add_child", scene_instance)

func _process(delta):
	if starting_in > 0.0:
		starting_in -= delta
		get_node("/root/Node2D/CanvasLayer/countdown").text = str(round(abs(starting_in)))
	elif timeout:
		if not listen_for_key:
			get_node("/root/Node2D/CanvasLayer/timeout").color.a = float(i)/255
			if i > 255:
				get_node("/root/Node2D/CanvasLayer/timeout/Label2").set_visible(true)
				listen_for_key = true
			i+=1
		else:
			if Input.is_key_pressed(16777221): # (enter key)
				get_tree().change_scene("res://main_menu.tscn")
	else:
		get_node("/root/Node2D/CanvasLayer/countdown").set_visible(false)
		time_left -= delta
		get_node("/root/Node2D/CanvasLayer/status").text = "COLLECTED: " + str(collected) + "\nTIME LEFT: " + ("%.1f" % time_left) + "s\nHOLDING: " + str(in_hand) + "/3"
		if time_left <= 0:
			get_node("/root/Node2D/CanvasLayer/status").text = "COLLECTED: " + str(collected) + "\nTIME LEFT: 0.0s\nHOLDING: " + str(in_hand) + "/3"
			timeout = true
			var scene = preload("res://timeout.tscn")
			var scene_instance = scene.instance()
			scene_instance.color.a = 0
			scene_instance.set_name("timeout")
			get_node("/root/Node2D/CanvasLayer").add_child(scene_instance)
			i = 0
			return
		
		# check if any item is near enough to be picked up
		for item in get_node("/root/Node2D/items").get_children():
			if position.distance_to(item.position) <= 16.0:
				if in_hand < 3:
					in_hand += 1
					in_hand_textures[in_hand-1] = item.get_node("sprite").texture
					item.queue_free()
		
		# make the box glow if any items in hand
		if in_hand > 0:
			get_node("/root/Node2D/YSort/box/Sprite").material.set_shader_param("width", 2*sin(float(i)/10)+4)
		else:
			get_node("/root/Node2D/YSort/box/Sprite").material.set_shader_param("width", 0)
		
		# if pressing space - throw item
		if Input.is_action_just_pressed("space"):
			if in_hand > 0:
				in_hand -= 1
				var direction = (get_global_mouse_position() - position).normalized()
				# instantiate a thrown item object
				var scene = load("res://thrown_item.tscn")
				var scene_instance = scene.instance()
				scene_instance.texture = in_hand_textures[in_hand]
				scene_instance.direction = direction
				scene_instance.position = position
				get_node("/root/Node2D/in_air").add_child(scene_instance)
				
				var node = AudioStreamPlayer.new()
				node.stream = preload("res://assets/sounds/throw.wav")
				add_child(node)
				node.play()
		
		var movement = Vector2(0,0)
		if Input.is_action_pressed("ui_down"):
			movement.y += 1
		if Input.is_action_pressed("ui_up"):
			movement.y -= 1
		if Input.is_action_pressed("ui_right"):
			movement.x += 1
		if Input.is_action_pressed("ui_left"):
			movement.x -= 1
		
		movement = movement.normalized()
		
		move_and_slide(movement*SPEED)
		
		# check if touching the lost & found box to leave items
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider == get_node("/root/Node2D/YSort/box"):
				# yep, leave items
				if in_hand > 0:
					collected += in_hand
					time_left += in_hand*5
					get_node("/root/Node2D/CanvasLayer/status/bonus_text").text = "+"+str(in_hand*5)
					time_since_bonus = 0
					in_hand = 0
		
		if movement.length() <= 0.01:
			$Sprite.texture = STANDING_TEX
		else:
			if (i / 15) % 2 == 0:
				$Sprite.texture = RUNNING1_TEX
			else:
				$Sprite.texture = RUNNING2_TEX
		
		get_node("/root/Node2D/CanvasLayer/status/bonus_text").modulate.a = max(0, 1.0 - time_since_bonus/1.5)
		
		i+=1
		time_since_bonus += delta
