extends Node3D

const GRIDMAP_ITEM_ID_WALL = 0
const GRIDMAP_ITEM_ID_FLOOR = 1

const spotlight = preload("res://scenes/levels/props/spotlight.tscn")
const spotlight_flashing = preload("res://scenes/levels/props/flashing_light.tscn")

@export var x_dim = 20
@export var y_dim = 20
@export var starting_coords = Vector2i(0, 0)

@onready var navregion: NavigationRegion3D = $NavigationRegion3D
@onready var gridmap: GridMap = $NavigationRegion3D/GridMap
@onready var lights_container: Node = $NavigationRegion3D/GridMap/LightsContainer


func _ready():
	place_border()
	dfs(starting_coords)
	navregion.bake_navigation_mesh()


func place_border():
	for y in range(-1, y_dim):
		place_element(Vector2(-1, y), GRIDMAP_ITEM_ID_WALL)
	for x in range(-1, x_dim):
		place_element(Vector2(x, -1), GRIDMAP_ITEM_ID_WALL)
	for y in range(-1, y_dim + 1):
		place_element(Vector2(x_dim - 1, y), GRIDMAP_ITEM_ID_WALL)
	for x in range(-1, x_dim + 1):
		place_element(Vector2(x, y_dim - 1), GRIDMAP_ITEM_ID_WALL)


func place_element(pos: Vector2, element_id: int):
	var pos_3d = Vector3(pos.x, 0, pos.y)
	gridmap.set_cell_item(pos_3d, element_id)


func will_be_converted_to_wall(spot: Vector2i):
	return (spot.x % 2 == 1 and spot.y % 2 == 1)


func is_wall(pos: Vector2i):
	var pos_3d = Vector3(pos.x, 0, pos.y)
	return gridmap.get_cell_item(pos_3d) == GRIDMAP_ITEM_ID_WALL


func can_move_to(current: Vector2i):
	return (
		current.x >= 0 and current.y >= 0 and \
		current.x < x_dim - 1 and current.y < y_dim - 1 and \
		not is_wall(current)
	)


func dfs(start: Vector2i):
	var adj4 = [
		Vector2i(-1, 0),
		Vector2i(1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1),
	]

	var fringe: Array[Vector2i] = [start]
	var seen = {}
	while fringe.size() > 0:
		var current: Vector2i
		current = fringe.pop_back() as Vector2
		if current in seen or not can_move_to(current):
			continue

		seen[current] = true
		# Place a wall at all odds coordinates
		if current.x % 2 == 1 and current.y % 2 == 1:
			place_element(current, GRIDMAP_ITEM_ID_WALL)
			continue

		place_element(current, GRIDMAP_ITEM_ID_FLOOR)

		# Guarantees that the first element in front of the player
		# will be a walkable floor
		if current != start:
			adj4.shuffle()

		var found_new_path = false
		for pos in adj4:
			var new_pos = current + pos
			if new_pos not in seen and can_move_to(new_pos):
				var chance_of_no_loop = randi_range(1, 5)
				if will_be_converted_to_wall(new_pos) and chance_of_no_loop == 1:
					place_element(new_pos, GRIDMAP_ITEM_ID_WALL)
				else:
					found_new_path = true
					fringe.append(new_pos)

		# If we hit a dead end or are at a cross section
		if not found_new_path:
			place_element(current, GRIDMAP_ITEM_ID_WALL)
