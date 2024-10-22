extends SpotLight3D

var timer = null

func _ready():
	timer = Timer.new()
	randomize_time()
	timer.connect("timeout", on_timer_timeout)
	add_child(timer)
	timer.start()


func randomize_time():
	timer.wait_time = randf_range(0.05, 0.1)


func on_timer_timeout():
	randomize_time()
	light_energy = randf_range(0.0, 1.0)
