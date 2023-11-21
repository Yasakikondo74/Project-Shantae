extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")
@onready var Standing = $Standing
@onready var Duck = $Duck
@onready var Whip = $Whip
@onready var Whip_Duck = $"Whip Duck"

func _ready():
	anim.play("Idle")
	set_states(false, true, true, true)

func set_states(standing_state, duck_state, whip_state, whip_Duck_state):
	Standing.disabled = standing_state
	Duck.disabled = duck_state
	Whip.disabled = whip_state
	Whip_Duck.disabled = whip_Duck_state
	#more states later like transforming

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		anim.play("Jump")
		velocity.y = JUMP_VELOCITY
		
	if Input.get_action_strength("ui_right") > 0:
		sprite.flip_h = false
	elif Input.get_action_strength("ui_left") > 0:
		sprite.flip_h = true
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if Input.is_action_pressed("ui_down"):
			velocity.x = direction * SPEED
			anim.play("Crawling")
			set_states(true, false, true, true)
		else:
			set_states(false, true, true, true)
			if Input.is_action_pressed("ui_run") and Input.is_action_pressed("ui_up"):
				velocity.x = direction * SPEED * 2
				anim.play("Jump")
			elif Input.is_action_pressed("ui_run"):
				velocity.x = direction * SPEED * 2
				anim.play("Run")
			elif Input.is_action_pressed("ui_up"):
				velocity.x = direction * SPEED
				anim.play("Jump")
			else:
				velocity.x = direction * SPEED
				anim.play("Walk")
	else:
		if Input.is_action_pressed("ui_down") and is_on_floor():
			velocity.x = 0
			if Input.is_action_pressed("whip"):
				anim.play("Whip_duck")
				set_states(true, false, true, false)
			else:
				set_states(true, false, true, true)
				anim.play("Duck Idle")
		else:
			set_states(false, true, true, true)
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if Input.is_action_pressed("whip"):
				anim.play("Whip")
				set_states(false, true, false, true)
			else:
				set_states(false, true, true, true)
				anim.play("Idle")
	if velocity.y > 0:
		anim.play("Fall")

	move_and_slide()
