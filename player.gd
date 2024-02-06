extends Area2D
signal hit
@export var speed = 400 # How fast the player will move (pixel/sec)
var screen_size # size of the game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
# Called every frame. 'delta' is tass # Replace with function body.he elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO	# The player's movement vector
	# records key inputs and updates vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	# if there is an input (per frame) normalize the vector
	# speed controls how fast sprite moves	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# update position based on movement vector and frame
	# clamp to esnure in viewport
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# flip sprite to simulate accurate movement
	# first if checks if you are pressing left and right
	# if you are pressing left, flip horizontally
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		#$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
 
func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deffered as we can't change physics properties 
	# on a physics call back
	$CollisionShape2D.set_deferred("disabled",true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
