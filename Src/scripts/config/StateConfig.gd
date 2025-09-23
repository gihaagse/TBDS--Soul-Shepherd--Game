extends Resource
class_name StateConfig

# Behaviour inner class
@export var behaviours: Dictionary = {}
@export var priority: Dictionary = {}

# Behaviour structure helper - niet export maar voor type safety
class Behaviour:
	var canAttack: bool
	var canParry: bool
	var canJump: bool
	var canMove: bool
	var canDash: bool
	var walkSpeedMultiplier: float
	var jumpPowerMultiplier: float
	
	func _init(data: Dictionary = {}):
		canAttack = data.get("canAttack", false)
		canParry = data.get("canParry", false)
		canJump = data.get("canJump", false)
		canMove = data.get("canMove", false)
		canDash = data.get("canDash", false)
		walkSpeedMultiplier = data.get("walkSpeedMultiplier", 1.0)
		jumpPowerMultiplier = data.get("jumpPowerMultiplier", 1.0)

func _init():
	_setup_default_config()

func _setup_default_config():
	# Setup all the behaviours
	behaviours = {
		"IDLE": {
			"canAttack": true,
			"canParry": true,
			"canJump": true,
			"canMove": true,
			"canDash": true,
			"walkSpeedMultiplier": 0.75,
			"jumpPowerMultiplier": 0.75
		},
		"MOVING": {
			"canAttack": true,
			"canParry": true,
			"canJump": true,
			"canMove": true,
			"canDash": true,
			"walkSpeedMultiplier": 0.8,
			"jumpPowerMultiplier": 0.8
		},
		"RUNNING": {
			"canAttack": true,
			"canParry": true,
			"canJump": true,
			"canMove": true,
			"canDash": true,
			"walkSpeedMultiplier": 1.5,
			"jumpPowerMultiplier": 1.5
		},
		"JUMPING": {
			"canAttack": true,
			"canParry": true,
			"canJump": false,
			"canMove": true,
			"canDash": true,
			"walkSpeedMultiplier": 0.8,
			"jumpPowerMultiplier": 1.0
		},
		"STUNNED": {
			"canAttack": false,
			"canParry": false,
			"canJump": false,
			"canMove": false,
			"canDash": false,
			"walkSpeedMultiplier": 0.0,
			"jumpPowerMultiplier": 0.0
		}
	}
	
	priority = {
		"IDLE": 20,
		"MOVING": 25,
		"JUMPING": 40,
		"ATTACKING": 50,
		"PARRYING": 65,
		"DASHING": 70,
		"FEINTING": 80,
		"STUNNED": 90,
		"DEAD": 100
	}
	
