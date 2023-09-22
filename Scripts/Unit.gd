extends CharacterBody2D
class_name Unit

@export var health : int = 100
@export var damage : int = 20

@export var move_speed : float = 50.0
@export var attack_range : float = 20.0
@export var attack_rate : float = 0.5
var last_attack_time : float

var target : CharacterBody2D

var nav_agent : NavigationAgent2D
var sprite : Sprite2D

@export var is_player : bool

func _ready():
	nav_agent = $NavigationAgent2D
	sprite = $Sprite

func _process(delta):
	target_check()

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
	var direction = global_position.direction_to(nav_agent.get_next_path_position())
	velocity = direction * move_speed
	move_and_slide()

func move_to_location(location):
	target = null
	nav_agent.target_position = location

func set_target(new_target):
	target = new_target

func target_check():
	if target != null:
		var dist = global_position.distance_to(target.global_position)
		if dist <= attack_range:
			nav_agent.target_position = global_position
			_try_attack_target()
		else:
			nav_agent.target_position = target.global_position

func _try_attack_target():
	var current_time = Time.get_unix_time_from_system()
	if current_time - last_attack_time > attack_rate:
		target.take_damage(damage)
		last_attack_time = current_time

func take_damage(damage_to_take):
	health -= damage_to_take
	if health <= 0:
		queue_free()
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

