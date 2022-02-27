extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP
var _velocity: = Vector2.ZERO

# represents the movement speed of the player
export var speed: = Vector2(300.0,1000.0)
export var maxSpeed = Vector2(600.0, 3000.0)

export var gravity: = 3000.0

# Everything that involves physics will go here
func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta

