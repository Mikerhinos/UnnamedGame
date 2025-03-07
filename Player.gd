extends KinematicBody

# variables caméra
var camera_angle = 0
var camera_change = Vector2()
var sensitivity = 0.3

var velocity = Vector3()
var direction = Vector3()

# variables fly
const FLY_SPEED = 15
const FLY_ACCEL = 2
var flying = false

# variables walk
var gravity = -9.8 * 3
const MAX_SPEED = 20
const MAX_RUNNING_SPEED = 30
const ACCEL = 2
const DEACCEL = 6

# variables jump
var jump_height = 15

func _physics_process(delta):
	aim()
	if flying:
		fly(delta)
	else:
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
	var target = direction * speed
	
	var acceleration
	# si la direction * vitesse > 0 alors accélération, sinon décélération
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	
	# accélération progressive
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	# move et en cas de rencontre avec un obstacle, glisse le long de celui ci
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_height
	
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
		camera_change = event.relative
		
func aim():
	if camera_change.length() > 0 :
		# camera horizontal
		$Head.rotate_y(deg2rad(-camera_change.x * sensitivity))
	
		# camera vertical
		var change = -camera_change.y * sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90 :
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change
		camera_change = Vector2()
		


func _on_Area_body_entered( body ):
	if body.name == "Player" :
		flying = true


func _on_Area_body_exited( body ):
	if body.name == "Player" :
		flying = false
