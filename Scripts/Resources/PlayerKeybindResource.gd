class_name PlayerKeybindResource
extends Resource

const LEFT : String = 'Left'
const RIGHT : String = 'Right'
const JUMP : String = 'Jump'

@export var DEFAULT_LEFT_KEY = InputEventKey.new()
@export var DEFAULT_RIGHT_KEY = InputEventKey.new()
@export var DEFAULT_JUMP_KEY = InputEventKey.new()

var left_key = InputEventKey.new()
var right_key = InputEventKey.new()
var jump_key = InputEventKey.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Opened pkr.gd")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
