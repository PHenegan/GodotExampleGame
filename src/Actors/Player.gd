extends Actor

# Maximum number of air jumps the player has by default
const MAX_AIR_JUMPS = 1
# Number of air jumps the player has left
var _jumps_left = MAX_AIR_JUMPS

# the impulse the player gets whenever they stomp on an enemy
export var stomp_impulse = 1000.0


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	queue_free()

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	# updates the jump count as if the player touched the ground
	_jumps_left = update_jump_count(_jumps_left, true)
	# makes the player bounce when they kill the enemy
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _physics_process(delta: float) -> void:
	#left and right movement
	var direction: = get_direction()
	
	# did the player just let go of the jump key?
	var is_jump_interrupted = (Input.is_action_just_released("jump") and _velocity.y < 0.0) 
	
	# handles double jumping
	_jumps_left = update_jump_count(_jumps_left, is_on_floor())
	
	# calculates the direction that the _velocity needs to go in
	_velocity = calculate_move_velocity(_velocity, direction, speed, maxSpeed, is_jump_interrupted)
	
	# Moves the Player and any changes (due to collision) in _velocity
	# NOTE: the FLOOR_NORMAL argument represents the direction perpendicular to the floor
	# and pointing away from it. it is used for the is_on_floor() function 
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

# PURPOSE: Gets the direction that the user is trying to go in
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and _jumps_left > 0 else 1.0
	)

# Calculates an updated _velocity given the current _velocity, the directional inputs,
# abd a movement speed vector
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		maxVel: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	
	# The x direction is pretty simple, just multiplies the magnitude of the speed
	# by the directional vector
	out.x = direction.x * speed.x
	
	out.y += gravity * get_physics_process_delta_time()
	
	# The y-axis is facing down, so moving up on the screen means moving in the
	# negative y direction
	if (direction.y == -1.0):
		out.y = speed.y * direction.y
	if (is_jump_interrupted):
		out.y = 0.0
	
	#finally, checks the movement speed against their maximum possible values
	out.x = min(out.x, maxSpeed.x)
	out.x = max(out.x, -maxSpeed.x)
	out.y = min(out.y, maxSpeed.y)
	out.y = max(out.y, -maxSpeed.y)
	
	return out

# Applies the given impulse to the given velocity in the upwards direction
func calculate_stomp_velocity(
		linear_velocity: Vector2,
		impulse: float
	) -> Vector2:
	var out: = linear_velocity
	out.y = -impulse
	
	return out
	
	

# Finds out how many jumps the player should have
func update_jump_count(current: int, reset: bool) -> int:
	var out: int
	if (reset):
		out = max(MAX_AIR_JUMPS, current)
	elif (Input.is_action_just_pressed("jump") && current > 0):
		out = _jumps_left - 1
	else:
		out = _jumps_left
	return out
