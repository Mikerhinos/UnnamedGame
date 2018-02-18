extends KinematicBody

var camera_angle = 0
var sensitivity = 0.3

var velocity = Vector3()
var direction = Vector3()

# variables fly
const FLY_SPEED = 40
const FLY_ACCEL = 4

# variables walk
var gravity = 9.8 * 3
const MAX_SPEED = 20
const MAX_RUNNING_SPEED = 30
const ACCEL = 2
const DEACCEL = 6

# variables jump
var jump_height = 15

func _physics_process(delta):
	walk(delta)
	
func walk(delta):
	# reset la direction du player
	direction = Vector3()
	
	# recup les axes de la caméra
	var aim = $Head/Camera.get_global_transform().basis
	
	# Gestion de la torche
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		$Head/Camera/SpotLight.light_energy = 1
	else : $Head/Camera/SpotLight.light_energy = 0
	
	# déplacements
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
		
	direction = direction.normalized()
	
	velocity.y += gravity * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	# courir ou marcher ?
	var speed
	if Input.is_action_pressed("sprint"):
		speed = MAX_RUNNING_SPEED
	else:
		speed = MAX_SPEED
	
	# vitesse maxi
	var target = direction * FLY_SPEED
	
	# accélération progressive
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	# move et en cas de rencontre avec un obstacle, glisse le long de celui ci
	move_and_slide(velocity)
	
func fly(delta):
		# reset la direction du player
	direction = Vector3()
	
	# recup les axes de la caméra
	var aim = $Head/Camera.get_global_transform().basis
	
	# Gestion de la torche
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		$Head/Camera/SpotLight.light_energy = 1
	else : $Head/Camera/SpotLight.light_energy = 0
	
	# déplacements
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
		
	direction = direction.normalized()
	
	# vitesse maxi
	var target = direction * FLY_SPEED
	
	# accélération progressive
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	# move et en cas de rencontre avec un obstacle, glisse le long de celui ci
	move_and_slide(velocity)

func _input(event):
	if event is InputEventMouseMotion :
		# camera horizontal
		$Head.rotate_y(deg2rad(-event.relative.x * sensitivity))

		# camera vertical
		var change = -event.relative.y * sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90 :
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change