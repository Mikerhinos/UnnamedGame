extends Spatial

var fullscreen = false

func _ready():
	# cache le curseur de souris
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Si le joueur appuie sur le raccourci quit, re-show le curseur de souris et quitte le jeu
	if (Input.is_action_just_pressed("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	# Si le joueur appuie sur le raccourci reset, relance le jeu
	if (Input.is_action_just_pressed("reset")):
		get_tree().reload_current_scene()
		
	if (Input.is_action_just_pressed("set_fullscreen")):
		if (fullscreen == false):
			OS.window_fullscreen = true
			fullscreen = true
		else: 
			OS.window_fullscreen = false
			fullscreen = false
