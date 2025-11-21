@tool extends Node3D
@export_tool_button("Create Hitboxes") var create_hitboxes:Callable = _create_hitboxes
@export_tool_button("Remove Hitboxe Meshes") var remove_hitboxes:Callable = _remove_hitbox_meshes
const hitbox_as_is:Array[StringName] = [
	"Gorge",
	"Water",
	"Mound",
	"Pillar",
	"TallPillar",
	"TreeTrunks",
	"Log",
]
func _remove_hitbox_meshes() -> void:
	for mesh:MeshInstance3D in get_children():
		if mesh.name.contains("Hitbox"):
			mesh.queue_free()

func _create_hitboxes() -> void:
	for mesh:MeshInstance3D in get_children():
		var name_parts:PackedStringArray = mesh.name.split("_")
		var mesh_name:String = name_parts[0]
		var mesh_index:String = ("_%s" % name_parts[1]) if name_parts.size() > 1 else ""
		await _remove_children(mesh)
		if hitbox_as_is.has(mesh_name):
			mesh.create_trimesh_collision()
		else:
			var hitbox_name:String = "%sHitbox%s" % [mesh_name, mesh_index]
			var hitbox_mesh:MeshInstance3D = find_child(hitbox_name)
			if not hitbox_mesh:
				continue
			var shape:ConcavePolygonShape3D = hitbox_mesh.mesh.create_trimesh_shape()
			var collision_shape:CollisionShape3D = CollisionShape3D.new()
			collision_shape.shape = shape
			var hitbox:StaticBody3D = StaticBody3D.new()
			hitbox.add_child(collision_shape)
			mesh.add_child(hitbox)
			hitbox.owner = get_tree().edited_scene_root
			collision_shape.owner = get_tree().edited_scene_root

func _remove_children(node:Node) -> void:
	for child:Node in node.get_children():
		child.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
