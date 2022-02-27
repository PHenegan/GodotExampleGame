extends Actor

# This function is run on initialization
func _ready() -> void:
	_velocity.x = speed.x

func _physics_process(delta: float) -> void:
	if (is_on_wall()):
		_velocity.x *= -1.0
		
	_velocity.y += gravity * delta
	
	# Only moves the y component
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
