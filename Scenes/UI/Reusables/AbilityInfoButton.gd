extends TextureButton
@onready var open_menu_label: Label = $"../OpenMenuLabel"

@export var kbm_texture: Texture2D
@export var controller_texture: Texture2D

var button_text: String = "Open Ability Menu"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OptionsManager.input_scheme_changed.connect(_on_input_scheme_changed)
	_update_icon(OptionsManager.current_scheme)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	open_menu_label.text = button_text

func _on_mouse_exited() -> void:
	release_focus()
	await get_tree().create_timer(0.5).timeout
	open_menu_label.text = ""
	
func _on_pressed() -> void:
	get_parent().get_parent().AbilityInfoMenu()
	release_focus()

func _on_input_scheme_changed(scheme_name: String) -> void:
	if scheme_name == "kbm":
		texture_normal = kbm_texture
	else:
		texture_normal = controller_texture

func _update_icon(scheme_enum) -> void:
	if scheme_enum == OptionsManager.Scheme.KEYBOARD_MOUSE:
		texture_normal = kbm_texture
	else:
		texture_normal = controller_texture
