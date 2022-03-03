extends Actor

# This function is run on initialization
func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x

# Called a callback function - typically placed right under the ready function
# Whenever something enters the stomp hitbox, this script is called.
func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if (body.global_position.y > get_node("StompDetector").global_position.y):
		return
	else:
		get_node("CollisionShape2D").disabled = true
		queue_free()



func _physics_process(delta: float) -> void:
	if (is_on_wall()):
		_velocity.x *= -1.0
		
	_velocity.y += gravity * delta
	
	# Only moves the y component
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
