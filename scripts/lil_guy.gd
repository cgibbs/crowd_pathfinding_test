extends CharacterBody2D


var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var game: Node2D = $".."

var wanderTimer = randfn(0.8, 1.2)

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	animation_player.advance(randfn(0.0, 0.3))

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2): 
	#navigation_agent.target_position = Vector2(randfn(movement_target.x, 20), randfn(movement_target.y, 20))
	navigation_agent.target_position = movement_target
	#wanderTimer = randfn(0.2, 0.1)

func get_movement_target_from_game():
	var new_pos = game.position_queue.pop_back()
	set_movement_target(new_pos)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		if (timer.is_stopped()):
			timer.start(wanderTimer)
			wanderTimer = 0.1
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()



func _on_timer_timeout() -> void:
	# do Brownian motion, kinda
	pass
	# TODO: for better movement_target setting, check if new target crosses a wall via a raycast?
	#var next_path_position: Vector2 = navigation_agent.target_position
	#var randX = randfn(next_path_position.x, 20)
	#var randY = randfn(next_path_position.y, 20)
	#set_movement_target(Vector2(randX, randY))
