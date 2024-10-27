extends CharacterBody3D

@export var mvt_speed = 2.0
var acceleration = 10.0
var target: Node3D = null  
var vel = Vector3()

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var attack_area: Area3D = $AttackArea

signal player_hit

func _ready():
	attack_area.connect("body_entered", on_hit_player)

func _physics_process(delta):
	if target == null:
		target = get_tree().get_first_node_in_group("players")
		return

	var direction = Vector3()

	nav.target_position = target.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * mvt_speed, acceleration * delta)
	move_and_slide()
	look_at(nav.target_position)

func on_hit_player(_body):
	player_hit.emit()
