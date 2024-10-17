extends CharacterBody3D

@export var mvt_speed = 2.0
var target = null  
var nav = null
var vel = Vector3()

func _physics_process(delta):
	if target == null:
		return
		
	var path 
