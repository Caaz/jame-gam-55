@tool class_name LevelBuilder extends GridMap
const LEVEL_ITEMS:Array[String] = [
	"Gorge",
	"Water",
	"TreeTrunks",
	"Leaves",
	"Border"
]
const OBSTACLES:Array[String] = [
	"Ivy",
	"Ivy_001",
	"Ivy_002",
	"Ivy_003",
	"Ivy_004",
	"Ivy_005",
	"Mound",
	"Mound_001",
	"Mound_002",
	"Pillar",
	"Pillar_001",
	"Pillar_002",
	"TallPillar",
	"TallPillar_001",
	"TallPillar_002",
	"TallPillar_003",		
	"TallPillar_004",
	"Log",
	"Log_001"
]
const LEVEL_LENGTH:int = 5
const LEVEL_X:int = -1

@export var target_cell:int:
	set(new):
		if target_cell == new:
			return
		target_cell = new
		_update_cells()

@warning_ignore("unused_private_class_variable")
@export_tool_button("clear_grid") var _clear_grid = clear

var filled_cells:Array[int]
var minimum_obstacles:int:
	get:
		return clamp(target_cell/2., 0, OBSTACLES.size())

var maximum_obstacles:int:
	get:
		return minimum_obstacles
func _ready() -> void:
	clear()
	_update_cells()

func _update_cells() -> void:
	clear_cell(target_cell-2)
	
	for z:int in range(target_cell, target_cell + LEVEL_LENGTH):
		if filled_cells.has(z):
			continue
		populate(z)
		

func clear_cell(z:int):
	var cell:int = filled_cells.find(z)
	if cell != -1:
		filled_cells.remove_at(cell)
	for height:int in range(0, 10):
		set_cell_item(Vector3(LEVEL_X, height, z), INVALID_CELL_ITEM)

func populate(z:int):
	filled_cells.append(z)
	var cell_position:Vector3i = Vector3i(LEVEL_X,0,z)
	## Add objects that should always be there
	for item_name:String in LEVEL_ITEMS:
		var item_index:int = mesh_library.find_item_by_name(item_name)
		set_cell_item(cell_position, item_index)
		cell_position.y += 1
	
	## Choose a set of random obstacles, at least 3 of them
	var obstacle_count:int = minimum_obstacles
	var chosen_obstacles:Array[String]
	while chosen_obstacles.size() < obstacle_count:
		var obstacle_name:String = OBSTACLES.pick_random()
		if chosen_obstacles.has(obstacle_name):
			continue
		chosen_obstacles.append(obstacle_name)
	
	## Add those chosen obstacles.
	for item_name:String in chosen_obstacles:
		var item_index:int = mesh_library.find_item_by_name(item_name)
		set_cell_item(cell_position, item_index)
		cell_position.y += 1
