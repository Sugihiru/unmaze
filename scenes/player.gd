extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var jump_speed = 5
var mouse_sensitivity = 0.002
var is_dead = false

@onready var collider = $Collider
@onready var animation_player = $AnimationPlayer
# Footsteps
@onready var footsteps_audio_stream_player: AudioStreamPlayer3D = $Footsteps/FootstepsAudioPlayer
@onready var footsteps_timer: Timer = $Footsteps/FootstepsTimer
# Ambiant sounds
@onready var ambiant_audio_stream_player1: AudioStreamPlayer3D = $AmbiantAudios/AmbiantAudioPlayer1
@onready var ambiant_audio_stream_player2: AudioStreamPlayer3D = $AmbiantAudios/AmbiantAudioPlayer2
@onready var ambiant_audio_stream_player3: AudioStreamPlayer3D = $AmbiantAudios/AmbiantAudioPlayer3
@onready var ambiant_timer: Timer = $AmbiantAudios/AmbiantTimer


signal stairs_found

func _ready():
	collider.connect("area_entered", on_area_entered)
	reset_ambiant_timer()

func on_area_entered(area):
	if area.is_in_group("stairs"):
		stairs_found.emit()

func _input(event):
	if is_dead:
		return
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

func _physics_process(_delta):
	if is_dead:
		return

	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	if not movement_dir.is_zero_approx():
		if footsteps_timer.time_left <= 0:
			footsteps_audio_stream_player.pitch_scale = randf_range(0.8, 1.2)
			footsteps_audio_stream_player.play()
			footsteps_timer.start(0.45)

	move_and_slide()


func reset_ambiant_timer():
	ambiant_timer.start(randi_range(30, 40))


func _on_ambiant_timer_timeout():
	var audio_players = [ambiant_audio_stream_player1, ambiant_audio_stream_player2, ambiant_audio_stream_player3]
	audio_players.pick_random().play()


func _on_monster_player_hit():
	is_dead = true
	animation_player.play("death")
