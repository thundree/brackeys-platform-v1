extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -300.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Coyote time configuration
@export_range(4, 10, 0.2) var coyote_frames := 6.4
@export var show_debug := false
var coyote_time := false
@onready var coyote_timer: Timer = $CoyoteTimer

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	coyote_timer.wait_time = coyote_frames / 60.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if not coyote_time:
			velocity.y += gravity * delta
	else:
		coyote_timer.stop()
		coyote_timer.start()
		coyote_time = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_time):
		coyote_time = false
		velocity.y = JUMP_VELOCITY
		coyote_timer.stop()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play('idle')
		else:
			animated_sprite.play('run')
	else:
		animated_sprite.play('jump')

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_coyote_timer_timeout():
	coyote_time = false


# maybe for future use like removing life points
func hurted():
	animation_player.play("hurt")
