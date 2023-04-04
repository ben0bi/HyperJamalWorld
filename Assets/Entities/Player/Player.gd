extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var isOnMap = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0.0
var olddirection = 0.0 # used to determine idle animations direction.
var is_on_spike = false
var is_on_ladder = false
var is_jumping = false
var is_dead = false
var already_laddered = false # did the player already press up or down?
var lock_animations = false
var lock_steering = false
var actual_spawn_point:Area2D = null

signal allLifesLost
signal onValueChange

# the player will be controlled from outside on the map 
# because it has different behaviours on different maps and levels.
# use JumpRunControl for controlling the player
# with jump and run controls.

# set an animation on the player.
func setAnimation(animname:String):
	$AnimationPlayer.play(animname)
	#print("play "+animname)

# add a life to the players lifes.
func addLife():
	PlayerData.actual_lifes+=1
	$Sounds/ExtraLife.play()
	emit_signal("onValueChange")

# add a coin to the players coins.
func addCoin():
	# get coins
	var coins = PlayerData.actual_coins
	# add a coin and maybe a life
	PlayerData.addCoin()
	# if it was the 100st coin, "coins" must be 99
	if coins==99:
		# play the extra life sound
		$Sounds/ExtraLife.play()
	else:
		# play the coin sound
		$Sounds/Coin.play()
		
	emit_signal("onValueChange")


# the player grows and has one life more.
func grow():
	PlayerData.is_big=true
	setAnimation("grow")
	PlayerData.is_active=false
	lock_animations=true
	lock_steering = true
	$Sounds/Grow.play()

# the player loses his extra life and shrinks to normal size.
func shrink():
	PlayerData.is_big = false
	setAnimation("shrink")
	PlayerData.is_active=false
	lock_animations=true
	lock_steering=true
	$Sounds/Shrink.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	# setup hud
	emit_signal("onValueChange")

# set the actual spawn point
func setSpawnPoint(spawnpoint):
	actual_spawn_point = spawnpoint

func hit():
	# determine if BIG, make smaller
	# if small:
	# play death animation
	if PlayerData.is_active==true:
		# shrink the player when it is big or
		# play the death animation and start the death timer
		# if the player is small.
		if PlayerData.is_big==true:
			shrink()
		else:
			print("You are dead.")
			PlayerData.actual_lifes-=1
			PlayerData.is_active = false # reset on restart
			lock_animations=true
			lock_steering=true
			is_dead=true
			emit_signal("onValueChange")
			$InactiveTimer.start()
			setAnimation("death")
		
		# player has no lifes left, game over
		if PlayerData.actual_lifes<=0:
			gameOver()
	pass

# absolute game over, no lifes left.
func gameOver():
	emit_signal("allLifesLost")
	print("+++ GAME OVER +++")

# Jump And Run Controller
func JumpRunControl(delta):
	var diry=0.0
	var onfloor = is_on_floor()
	# only move the player if steering is not locked.
	if lock_steering==false:
		if (not onfloor and not is_on_ladder) or is_jumping:
			velocity.y+=gravity*delta
		
		# reset jumping flag	
		if onfloor:
			is_jumping=false
		
		# player is on ladder, allow up and down control
		if is_on_ladder:
			diry=Input.get_axis("ui_up", "ui_down")
			if diry:
				velocity.y=diry*SPEED
				already_laddered = true
				# also reset jumping when moving up or down on the ladder.
				is_jumping = false
			else:
				# only move y towards 0 when not jumping.
				if not is_jumping:
					velocity.y=move_toward(velocity.y,0,SPEED)

		# jump. Must be after ladder code to work correctly.
		if Input.is_action_just_pressed("ui_accept") and (onfloor or is_on_ladder):
			is_jumping=true
			velocity.y = JUMP_VELOCITY
	
		# player is also jumping when he is in air and not on a ladder.
		if not is_on_ladder and not onfloor:
			is_jumping = true
	
		# only set old direction if direction is set.
		if direction:
			olddirection=direction
		# get new direction
		direction = Input.get_axis("ui_left", "ui_right")
		# apply direction
		if direction:
			velocity.x = direction*SPEED
		else:
			velocity.x=move_toward(velocity.x,0,SPEED)
		
		move_and_slide()
		
	# hit if on deadly area
	if is_on_spike==true:
		hit()
		
	# set animations
	# prevent from setting animations when locked
	if lock_animations:
		return
		
	# set walk or jump animation		
	if direction<0:
		if onfloor:
			setAnimation("left_walk")
		else:
			setAnimation("left_jump")
	if direction>0:
		if onfloor:
			setAnimation("right_walk")
		else:
			setAnimation("right_jump")
	# set idle animation
	if direction==0 and (not is_on_ladder or onfloor):
		if olddirection<0:
			setAnimation("left_idle")
		if olddirection>0:
			setAnimation("right_idle")
			
	# set up idle animation when on ladder
	if is_on_ladder and already_laddered and diry==0.0:
		setAnimation("up_idle")
	# set up walk animation when is on ladder
	if diry!=0 and is_on_ladder:
		setAnimation("up_walk")

func _physics_process(delta):
	if not isOnMap:
		JumpRunControl(delta)
	# map movement is controlled from outside.

# player is on a spike
func _on_spike_detection_2d_on_spike():
	is_on_spike=true

# player is not on spikes anymore	
func _on_spike_detection_2d_off_spike():
	is_on_spike=false
	
# set the player back to active when 
# this timer runs out. When he is dead, set new spawn position.
func _on_inactive_timer_timeout():
	if is_dead:
		if actual_spawn_point!=null:
			self.position=actual_spawn_point.position
	is_dead=false
	is_on_spike=false
	#is_on_ladder = false
	PlayerData.is_active = true
	lock_animations=false
	lock_steering=false
	setAnimation("right_idle")
	pass # Replace with function body.

# some animations have lock animation and lock steering on true,
# reset that here
func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.
	if anim_name=="grow" or anim_name=="shrink":
		$InactiveTimer.start() # start the timer to reset players 
							# active status, so that we have some time 
							# to escape stuff.
		lock_animations=false
		lock_steering = false

# player is on a ladder
func _on_ladder_detection_2d_on_ladder():
	is_on_ladder = true
	pass # Replace with function body.

# player is off all ladders
func _on_ladder_detection_2d_off_ladder():
	is_on_ladder=false
	already_laddered = false
	# bugfix for not moving when on top of ladder.
	if not is_on_floor():
		setAnimation("up_idle")
	pass # Replace with function body.
