extends CharacterBody2D


const SPEED = 130.0
const DASH_SPEED = 190
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


var is_dashing = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		audio_stream_player_2d.play()
		velocity.y = JUMP_VELOCITY
		
	# handle dash
	if Input.is_action_just_pressed("dash") and not is_dashing:
		start_dash()

	# get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# flip the sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		
	# play animation
	if is_dashing:
		animated_sprite_2d.play('dash')
	elif is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	# apply movement
	
	if is_dashing:
		velocity.x = DASH_SPEED if not animated_sprite_2d.flip_h else -DASH_SPEED
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func start_dash():
	is_dashing = true
	if not animated_sprite_2d.animation_finished.is_connected(_on_dash_finished):
		animated_sprite_2d.animation_finished.connect(_on_dash_finished)

func _on_dash_finished():
	if animated_sprite_2d.animation == "dash":
		is_dashing = false
		animated_sprite_2d.animation_finished.disconnect(_on_dash_finished)
			
