extends KinematicBody2D
#slower than player
const MOVE_SPEED = 300
const maxHealth = 2
var currentHealth = maxHealth
var attackDamage = 1

onready var raycast = $RayCast2D
 
var player = null
#zombie added to zombie group
#first frame, game load zombies added to zombie group
#first frame, player waits
#second frame, then zombies are added
func _ready():
    add_to_group("zombies")
 
func _physics_process(delta):
	#make sure there is a player
    if player == null:
        return
	#vector pointing to the player
    var vec_to_player = player.global_position - global_position
    vec_to_player = vec_to_player.normalized()
	#rotate to face player
    global_rotation = atan2(vec_to_player.y, vec_to_player.x)
    move_and_collide(vec_to_player * MOVE_SPEED * delta)
   
    if raycast.is_colliding():
        var coll = raycast.get_collider()
        if coll.name == "Player":
            coll.enemyHit(attackDamage)
 
func playerHit(damage):
	currentHealth -= damage
	#free node if zombie takes lethal damage
	if(currentHealth <= 0):
    	queue_free()
 
func set_player(p):
    player = p