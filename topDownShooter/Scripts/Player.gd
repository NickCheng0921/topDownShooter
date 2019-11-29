extends KinematicBody2D
 #constant for the movespeed
const MOVE_SPEED = 300
const maxHealth = 3
var currentHealth = maxHealth
var attackDamage = 1
#firing delay
var timer = null
var fire_delay = 0.35
var can_shoot = true

 #reference the raycast
onready var raycast = $RayCast2D
 #ready called once at beginning, wait one frame then call in zombies group and set player method
func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(fire_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	
	yield(get_tree(), "idle_frame")
	#called on all zombies, passed to self
	get_tree().call_group("zombies", "set_player", self)
 #called once every physics frame, independent of frame rate
func _physics_process(delta):
	#character move vector
	var move_vec = Vector2()
	#input checks, +y is down
	if Input.is_action_pressed("move_up"):
	    move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
	    move_vec.y += 1
	if Input.is_action_pressed("move_left"):
	    move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
	    move_vec.x += 1
	#doesn't move faster diagonally if normalized
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * MOVE_SPEED * delta)
	   #create a vector from character to mouse position
	var look_vec = get_global_mouse_position() - global_position
	global_rotation = atan2(look_vec.y, look_vec.x)
	#shoot 
	if Input.is_action_just_pressed("shoot") && can_shoot:
		print("shoot called")
		#play firing animation
		$AnimationPlayer.play("pistolBlast")
		#create a ray
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("playerHit"):
	        coll.playerHit(attackDamage)
		#firing delay
		can_shoot = false
		#start timer
		timer.start()
		
func on_timeout_complete():
	can_shoot = true
func enemyHit(damage):
	currentHealth -= damage
	#reload level on lethal damage 
	if(currentHealth <= 0):
    	get_tree().reload_current_scene()
